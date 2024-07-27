#include <WiFiManager.h>
#include <Firebase_ESP_Client.h>
#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"
#define API_KEY "AIzaSyCho5UxehCKNKismhYfctB8EQRnuRZtQ8Q"
#define DATABASE_URL "https://varietesinuds-default-rtdb.europe-west1.firebasedatabase.app/"
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
unsigned long sendDataPervMillis = 0;
bool signupOK = false;
bool Switch;
bool ModeAuto;
WiFiManager wm;
bool res;
#define RELAY_PIN 13
void setup() {
  Serial.begin(115200);
  pinMode(RELAY_PIN, OUTPUT);
  digitalWrite(RELAY_PIN, HIGH);
  res = wm.autoConnect("VI Light WiFi Manager");
  if(!res) {
    WiFi.disconnect(true);
    ESP.eraseConfig();
    ESP.restart();
  }
  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;
  if (Firebase.signUp( &config, &auth, "", "")) {
    signupOK = true;
  } else {
    Serial.printf("%s\n", config.signer.signupError.message.c_str());
    ESP.restart();
  }
  config.token_status_callback = tokenStatusCallback;
  Firebase.begin( & config, & auth);
  Firebase.reconnectWiFi(true);
}

void loop() {
  if(WiFi.status() != WL_CONNECTED){
    ESP.restart();//Do not try sending anymore
  }
  if( Firebase.RTDB.getBool(&fbdo,"Light/ModeAuto")){
    if(fbdo.dataType()=="boolean"){
      ModeAuto=fbdo.boolData();
      if (ModeAuto == 1){
        Serial.println("Mode Automatique");
      }
      else{
        Serial.println("Mode Manuelle");
        if( Firebase.RTDB.getBool(&fbdo,"Light/Switch")){
          if(fbdo.dataType()=="boolean"){
            Switch=fbdo.boolData();
            if (Switch == 1){
              Serial.println("Light On");
              digitalWrite(RELAY_PIN, LOW);
              Firebase.RTDB.setBool(&fbdo, "Light/Switch", false);
              digitalWrite(RELAY_PIN, HIGH);
            }
            else{
              Serial.println("Light Off");
            }
          }
        }
      }
    }
  } else {
    Serial.println(fbdo.errorReason());
  }
  if(Firebase.RTDB.getBool(&fbdo,"Menu/Reset")){
    if(fbdo.dataType()=="boolean"){
      if (fbdo.boolData() == 1){
        Firebase.RTDB.setBool(&fbdo, "Menu/Reset", false);
        ESP.restart();
      }
    }
  }
  if(Firebase.RTDB.getBool(&fbdo,"Menu/DisconnectWiFi")){
    if(fbdo.dataType()=="boolean"){
      if (fbdo.boolData() == 1){
        Firebase.RTDB.setBool(&fbdo, "Menu/DisconnectWiFi", false);
        WiFi.disconnect(true);
        ESP.eraseConfig();
        ESP.restart();
      }
    }
  }
  //delay(1000);
}