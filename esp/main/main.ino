#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <WebSocketsServer.h>
#include <WiFiManager.h>
#include "SunsetSunrise.h"
#include <ThreeWire.h>  
#include <RtcDS1302.h>

ThreeWire myWire(D4,D5,D3); // IO, SCLK, CE
RtcDS1302<ThreeWire> Rtc(myWire);

// WiFi and Server Setup
WiFiManager wm;
ESP8266WebServer server(80);
WebSocketsServer webSocket = WebSocketsServer(81);

// Flags and Parameters
bool wmResult = false;       
bool mode = false;           // false = manual, true = auto
bool lightState = false;     // Light is off initially
bool previousMode = false;   // Tracks previous mode to detect changes
bool lightAuto = false;      // Tracks light state in auto mode
bool lightErrorReported = false; // Indicates if an error message has been sent

double latitude = 36.8065;   
double longitude = 10.1815;  
int timezone = 1;            

// Web Server Handlers
void handleRoot() {
  server.send(200, "text/plain", "Connected");
}

void handlePost() {
  String message = server.arg("key");
  server.send(200, "text/plain", "Received: " + message);
}

// WebSocket Event Handler
void webSocketEvent(uint8_t num, WStype_t type, uint8_t *payload, size_t length) {
  if (type == WStype_TEXT) {
    String message = String((char *)payload);
    Serial.println(message);
    
    if (message == "ping") {
      String response = "pong, Mode: " + String(mode ? "Auto" : "Manual") + ", Light: " + (lightState ? "ON" : "OFF");
      webSocket.sendTXT(num, response);
    } else if (message == "LightOn" && !mode) {
      lightState = true;
      webSocket.sendTXT(num, "Light Turned On");
    } else if (message == "LightOff" && !mode) {
      lightState = false;
      webSocket.sendTXT(num, "Light Turned Off");
    }
  }
}

// Automatic Mode Handling
void handleModeAuto(uint8_t num) {
  RtcDateTime now = Rtc.GetDateTime();
  int year = now.Year();
  int month = now.Month();
  int day = now.Day();
  int currentMinutes = now.Hour() * 60 + now.Minute();

  int JD = julianDay(year, month, day);
  double declination = solarDeclination(JD);
  double sunsetHourAngle = hourAngle(latitude, declination, true);
  double sunriseHourAngle = hourAngle(latitude, declination, false);
  
  double sunriseTime = calculateLocalTime(JD, longitude, sunriseHourAngle, timezone);
  double sunsetTime = calculateLocalTime(JD, longitude, sunsetHourAngle, timezone);

  int sunriseHour = (int)(sunriseTime / 60) % 24;
  int sunriseMinute = (int)(sunriseTime) % 60;
  int sunsetHour = (int)(sunsetTime / 60) % 24;
  int sunsetMinute = (int)(sunsetTime) % 60;

  lightAuto = (currentMinutes > (sunsetHour * 60 + sunsetMinute)) || 
              (currentMinutes < (sunriseHour * 60 + sunriseMinute));
              
  if (lightAuto != lightState) {
    lightState = lightAuto;
    webSocket.sendTXT(num, lightAuto ? "Light ON (Auto)" : "Light OFF (Auto)");
  }
}

// WebSocket and Server Initialization
void webSocketConnection() {
  server.on("/endpoint", HTTP_GET, handleRoot);
  server.on("/endpoint", HTTP_POST, handlePost);
  server.begin();
  webSocket.begin();
  webSocket.onEvent(webSocketEvent);
}

// Setup Function
void setup() {
  Serial.begin(115200);
  pinMode(6, INPUT_PULLUP);   // External button on pin 6
  pinMode(7, INPUT);           // Pin 7 for reading light state
  Rtc.Begin();
  RtcDateTime compiled = RtcDateTime(__DATE__, __TIME__);
  wmResult = wm.autoConnect("VI Light WiFi Manager");

  if (!wmResult) {
    WiFi.disconnect(true);
    ESP.eraseConfig();
    ESP.restart();
  }

  webSocketConnection();
}

// Main Loop
void loop() {
  // If Wi-Fi is disconnected, restart the device
  if (WiFi.status() != WL_CONNECTED) {
    ESP.restart();
  }

  // Check the external switch status
  bool switchState = digitalRead(6);

  // Detect mode changes
  if (switchState != previousMode) {
    mode = switchState;  // Update the mode based on switch
    previousMode = switchState;
    
    // Send WebSocket message to notify about mode change
    webSocket.broadcastTXT(mode ? "Auto Mode Activated" : "Manual Mode Activated");
    
    // In auto mode, handle automatic light control
    if (mode) {
      handleModeAuto(0);
    }
  }

  // Check the state of the light from pin 7
  bool realLightState = digitalRead(7);
  
  // Verify if the real state matches the expected state
  if (realLightState != lightState) {
    // If there's an error and not reported yet, send an error message
    if (!lightErrorReported) {
      webSocket.broadcastTXT("Error: Light state mismatch! Expected: " + String(lightState ? "ON" : "OFF") + ", Actual: " + String(realLightState ? "ON" : "OFF"));
      lightErrorReported = true; // Set the flag to indicate the error has been reported
    }
  } else {
    // Reset the error reported flag when the state matches
    lightErrorReported = false;
  }

  // Handle HTTP and WebSocket events
  server.handleClient();
  webSocket.loop();
}
