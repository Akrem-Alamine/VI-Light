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
bool wmResult = false;       // Stores Wi-Fi connection status

bool manualMode = false;
bool autoMode = false;
bool lightState = false;  // Light is off initially

double latitude = 36.8065;   // Tunis latitude
double longitude = 10.1815;  // Tunis longitude
int timezone = 1;            // UTC+1 for Tunis


// =========================================================
//                      Web Server Handlers
// =========================================================

// Handle the root endpoint (GET request)
void handleRoot() {
  server.send(200, "text/plain", "Connected");
}

// Handle POST requests to receive data
void handlePost() {
  String message = server.arg("key");
  server.send(200, "text/plain", "Received: " + message);
}

// =========================================================
//                  WebSocket Event Handler
// =========================================================

// Handle different WebSocket events based on the message received
void webSocketEvent(uint8_t num, WStype_t type, uint8_t *payload, size_t length) {
  if (type == WStype_TEXT) {  // If the WebSocket event is a text message
    String message = String((char *)payload);
    Serial.println(message);
    // Handle automatic mode based on the sunrise and sunset times
    if (message == "ping") {
      // Respond with pong, current mode, and light status
      String response = "pong, Mode: " + getMode() + ", Light: " + (lightState ? "ON" : "OFF");
      webSocket.sendTXT(num, response);
    } else if (message.substring(0, 8) == "AutoMode") {
      manualMode = false;
      autoMode = true;
      lightState = false;
      handleModeAuto(num);
    }
    else if (message == "ManualMode") {
      manualMode = true;
      autoMode = false;
      webSocket.sendTXT(num, "Manual Mode Activated");
    } else if (message == "LightOn" && manualMode) {
      lightState = true;  // Turn on light in manual mode
      webSocket.sendTXT(num, "Light Turned On");
      //digitalWrite(HIGH);
    } else if (message == "LightOff" && manualMode) {
      lightState = false;  // Turn off light in manual mode
      webSocket.sendTXT(num, "Light Turned Off");
      //digitalWrite(LOW);
    }
  }
}

// =========================================================
//                  Automatic Mode Handling
// =========================================================

// Handle automatic mode based on the time of day and solar calculations
void handleModeAuto(uint8_t num) {
  RtcDateTime now = Rtc.GetDateTime();
  int year = now.Year();
  int month = now.Month();
  int day = now.Day();

  // Calculate Julian Day and solar declination
  int JD = julianDay(year, month, day);
  double declination = solarDeclination(JD);
  
  // Calculate sunrise and sunset hour angles
  double sunsetHourAngle = hourAngle(latitude, declination, true);
  double sunriseHourAngle = hourAngle(latitude, declination, false);
  
  // Convert to local time
  double sunriseTime = calculateLocalTime(JD, longitude, sunriseHourAngle, timezone);
  double sunsetTime = calculateLocalTime(JD, longitude, sunsetHourAngle, timezone);

  // Convert to hours and minutes
  int sunriseHour = (int)(sunriseTime / 60) % 24;
  int sunriseMinute = (int)(sunriseTime) % 60;
  int sunsetHour = (int)(sunsetTime / 60) % 24;
  int sunsetMinute = (int)(sunsetTime) % 60;
  int currentMinutes= now.Hour()*60+now.Minute();
  // Determine if it's time to turn lights on or off
  bool lightAuto = (currentMinutes > (sunsetHour * 60 + sunsetMinute)) || 
                   (currentMinutes < (sunriseHour * 60 + sunriseMinute));
  webSocket.sendTXT(num, lightAuto ? "lightON" : "lightOFF");
  if(lightAuto){
    //digitalWrite(HIGH);
  }
  else{
    //digitalWrite(LOW);
  }
}

// =========================================================
//             WebSocket and Server Initialization
// =========================================================

// Initialize WebSocket and set up server routes
void webSocketConnection() {
  server.on("/endpoint", HTTP_GET, handleRoot);
  server.on("/endpoint", HTTP_POST, handlePost);
  server.begin();
  webSocket.begin();
  webSocket.onEvent(webSocketEvent);
}

// =========================================================
//                       Setup Function
// =========================================================

void setup() {
  Serial.begin(115200);
  Rtc.Begin();
  RtcDateTime compiled = RtcDateTime(__DATE__, __TIME__);
  // Attempt to connect to Wi-Fi
  wmResult = wm.autoConnect("VI Light WiFi Manager");

  // If Wi-Fi connection fails, reset configuration and restart
  if (!wmResult) {
    WiFi.disconnect(true);
    ESP.eraseConfig();
    ESP.restart();
  }

  // Initialize WebSocket and server
  webSocketConnection();
}

// =========================================================
//                         Main Loop
// =========================================================

void loop() {
  // If Wi-Fi is disconnected, restart the device
  if (WiFi.status() != WL_CONNECTED) {
    ESP.restart();
  }
  // Handle HTTP server requests and WebSocket events
  server.handleClient();
  webSocket.loop();
}

String getMode() {
  if (manualMode) {
    return "Manual";
  } else{
    return "Auto";
  } 
}
