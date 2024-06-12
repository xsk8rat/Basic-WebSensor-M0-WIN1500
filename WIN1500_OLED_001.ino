/* 
 * Sensor Server for  Adafruit Feather M0 WiFi with ATWINC1500
                     https://learn.adafruit.com/adafruit-feather-m0-wifi-atwinc1500/

                     with display: 
                     https://learn.adafruit.com/adafruit-128x64-oled-featherwing#arduino-code
                     https://learn.adafruit.com/adafruit-gfx-graphics-library

  000 Basic WIFI, Server and Display
  001 BME 680 (https://learn.adafruit.com/adafruit-bme680-humidity-temperature-barometic-pressure-voc-gas#arduino-wiring-test)

 **************************************************************************/
char CODENAME[]    = "WIN1500_OLED_001";
char CODEDIR[]     = "/HumidityFeather/";
char DEVNAME[]     = "Basic-009";
char DEVLOCATION[] = "LaniStudy";

#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SH110X.h>
#include <wdt_samd21.h>

Adafruit_SH1107 display = Adafruit_SH1107(64, 128, &Wire);
//Adafruit_SH110X display = Adafruit_SH110X(64, 128, &Wire);

// Wifi Stuff
#include <WiFi101.h>
#include "arduino_secrets.h" 
char ssid[] = SECRET_SSID;        // your network SSID (name)
char pass[] = SECRET_PASS;    // your network password (use for WPA, or use as key for WEP)
int keyIndex = 0;            // your network key Index number (needed only for WEP)

int status = WL_IDLE_STATUS;
WiFiServer server(80);
int iWIFIRESTRT     = 0;     // Track number WiFi restarts
int ilastWIFIRESTRT = 0;     // For display of number

#include <SoftTimers.h>
SoftTimer serial_timer; 
SoftTimer display_timer;
SoftTimer sampleTimer;

// = = = = = = 
// Runnning averages - will glitch a bit on re-start!
#include <Ewma.h>
Ewma pressureFilter(0.005);  float pressureValue = 0;
Ewma temperatureFilter(0.5); float temperatureValue = 0;
Ewma humidityFilter(0.1);    float humidityValue = 0;
Ewma gasFilter(0.05);        float gasValue = 0;

float lastTemp     = 0.0;
float lastHumidity = 0.0;
float lastPressure = 0.0;
float lastGas      = 0.0;
float lastdBm      = 0.0;

bool isFirstPass = true;

#include <Arduino_JSON.h>
JSONVar dataObject;

#include <Adafruit_Sensor.h>
#include "Adafruit_BME680.h"
#define BME_SCK 13
#define BME_MISO 12
#define BME_MOSI 11
#define BME_CS 10

Adafruit_BME680 sensorBME; // I2C


// = = = = = = ==============================================================================
void setup() {
  Serial.begin(115200);

  delay(2000);
  Serial.println("");
  Serial.println("");
  Serial.print("Starting Code:         -> ");
  Serial.print(CODEDIR);
  Serial.print(CODENAME);
  Serial.print(" ");
  Serial.println(DEVNAME);

  initDisplay();

  // Start WiFi and Server Initialization
  displayWIFIStart ();
  startWiFiSystem();
  server.begin();
  printWifiStatus();
  displayWIFIStatus ();

  
  //Start Sensors
  Wire.begin();

  initializeBME680();

  //Set timer delays in seconds
  timerResetSeconds(serial_timer, 30.0);
  timerResetSeconds(display_timer, 2.0);
  timerResetSeconds(sampleTimer,  1.0);


  wdt_init ( WDT_CONFIG_PER_16K );
  Serial.print("Started: ");
  Serial.print(CODEDIR);
  Serial.print(CODENAME);
  Serial.print(" ");
  Serial.println(DEVNAME);

}

// = = = = = = ==============================================================================
// = = = = = = ==============================================================================
void loop() {
  wdt_reset ( );
  
  // update running mean  (periodically)
  if (sampleTimer.hasTimedOut() || isFirstPass) {
    sampleSensorData();
    sampleTimer.reset();
  }
  // Print to Serial line
  if (serial_timer.hasTimedOut() || isFirstPass) {
    serial_timer.reset();
    printInfo();
  } 
  //Update the display
  if (display_timer.hasTimedOut() || isFirstPass) {
    displayInfo();
    display_timer.reset();
    isFirstPass = false;
  } 
  
  vCheckWIFIAndReset();
  if (iWIFIRESTRT > 10) {
    Serial.println("Imminent REBOOT!");
    while (true) {};
  }
  serveWebPage();
}

void printWifiStatus() {
  // print the SSID of the network you're attached to:
  Serial.print("SSID:                   ");
  Serial.println(WiFi.SSID());
  // print your WiFi shield's IP address:
  IPAddress ip = WiFi.localIP();
  Serial.print("IP Address:             ");
  Serial.println(ip);
  byte mac[6]; 
  WiFi.macAddress(mac);
  Serial.print("MAC Address:            ");
  Serial.print(mac[5],HEX);
  Serial.print(":");
  Serial.print(mac[4],HEX);
  Serial.print(":");
  Serial.print(mac[3],HEX);
  Serial.print(":");
  Serial.print(mac[2],HEX);
  Serial.print(":");
  Serial.print(mac[1],HEX);
  Serial.print(":");
  Serial.print(mac[0],HEX);
  Serial.println();
  // print the received signal strength:
  long rssi = WiFi.RSSI();
  Serial.print("signal strength (RSSI): ");
  Serial.print(rssi);
  Serial.println(" dBm");

  Serial.print("FirmWare Version:       ");
  Serial.print(WiFi.firmwareVersion());
  Serial.println("");
  Serial.println("");

}

// = = = = = = ==============================================================================
//             timerReset
// Sets the timers usingf the same code,
void timerResetSeconds(SoftTimer &inTimer, float inSec) {
  inTimer.setTimeOutTime(1);
  inTimer.reset();
  delay(2);
  inTimer.setTimeOutTime(inSec*1000); //Resample for time average 
  inTimer.reset();
}
