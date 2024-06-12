
// = = = = = = ==============================================================================
//             serveWebPage ()
//             
// = = = = = = ==============================================================================
void serveWebPage() {
  WiFiClient client = server.available();
  if (client) {
    Serial.println("// New Client");
    // an http request ends with a blank line
    bool currentLineIsBlank = true;
    while (client.connected()) {
      if (client.available()) {
        char c = client.read();
        if (c == '\n' && currentLineIsBlank) {
          //send a standard http response header
          client.println("HTTP/1.1 200 OK");
          client.println("Content-Type: text/html");
          client.println("Connection: close");
          client.println("Refresh: 60");
          client.println();
          // Sensor Data
          dataObject["temperaturevalue"]  = temperatureValue;
          dataObject["temperatureunits"]  = "F";
          dataObject["temperaturesensor"] = "BME680";
          
          dataObject["humidityvalue"]  = humidityValue;
          dataObject["humidityunits"]  = "% Rel.";
          dataObject["humiditysensor"] = "BME680";
          
          dataObject["pressurevalue"]  = pressureValue;
          dataObject["pressureunits"]  = "hPa";
          dataObject["pressuresensor"] = "BME680";
          
          dataObject["tvocvalue"]  = gasValue;
          dataObject["tvocunits"]  = "kOhm";
          dataObject["tvocsensor"] = "BME680";

          float useRSSI = float(WiFi.RSSI()); 
          dataObject["wifipowervalue"]  = useRSSI;
          dataObject["wifipowerunits"]  = "dBmW";
          dataObject["wifipowersensor"] = "None";

          // System Data
          dataObject["WIFIRestart"]  = iWIFIRESTRT;
          dataObject["CODEDIR"]      = CODEDIR;
          dataObject["CODENAME"]     = CODENAME;
          dataObject["DEVNAME"]      = DEVNAME;
          dataObject["location"]     = DEVLOCATION;
          // client.println("</html>");
          client.print(dataObject);
          break;
        }
        if (c == '\n') {
          // you're starting a new line
          currentLineIsBlank = true;
        }
        else if (c != '\r') {
          // you've gotten a character on the current line
          currentLineIsBlank = false;
        }
      }
    }
    // give the web browser time to receive the data
    delay(1);

    // close the connection:
    client.stop();
    //Serial.println("client disconnected");
  }

}

// = = = = = = ==============================================================================
//              getIPAddressString ()
//              Abstracting, as it may be different for different systems.
// = = = = = = ==============================================================================
String getIPAddressString() {
  IPAddress ip = WiFi.localIP();
  return IpAddress2String(ip);
}
// = = = = = = ==============================================================================
//             IpAddress2String ()
//             https://forum.arduino.cc/t/how-to-manipulate-ipaddress-variables-convert-to-string/222693/5
// = = = = = = ==============================================================================
String IpAddress2String(const IPAddress& ipAddress)
{
  return String(ipAddress[0]) + String(".") +\
  String(ipAddress[1]) + String(".") +\
  String(ipAddress[2]) + String(".") +\
  String(ipAddress[3])  ; 
}

// = = = = = = ==============================================================================
//             vPrintWiFiStatusString ()
//             Prints string which describes current wifi state.
// = = = = = = ==============================================================================
void vPrintWiFiStatusString() {
  int iWiFi = WiFi.status();
  if (iWiFi == WL_CONNECTED)      {Serial.print("WL_CONNECTED");      return;};
  if (iWiFi == WL_NO_SHIELD)      {Serial.print("WL_NO_SHIELD");      return;};
  if (iWiFi == WL_CONNECT_FAILED) {Serial.print("WL_CONNECT_FAILED"); return;};
  if (iWiFi == WL_NO_SSID_AVAIL)  {Serial.print("WL_NO_SSID_AVAIL");  return;};
  if (iWiFi == WL_SCAN_COMPLETED) {Serial.print("WL_SCAN_COMPLETED"); return;};
  if (iWiFi == WL_DISCONNECTED)   {Serial.print("WL_DISCONNECTED");   return;};
  Serial.print("WiFi Code=");
  Serial.print(iWiFi);
}

// = = = = = = ==============================================================================
//             startWiFiSystem ()
//             Starts the WiFi from a new state (no stopping old processes)
// = = = = = = ==============================================================================
void startWiFiSystem () {
  int iCount = 0;
  //Configure pins for Adafruit ATWINC1500 Feather
  WiFi.setPins(8,7,4,2);

  Serial.print("Starting WiFi");
  status = WL_DISCONNECTED;

  // attempt to connect to Wifi network:
  while ( status != WL_CONNECTED) {
    Serial.print("Connecting to SSID     -> ");
    Serial.println(ssid);
    // Connect to WPA/WPA2 network. Change this line if using open or WEP network:    
    status = WiFi.begin(ssid, pass);
    //wdt_disable( );
    for (int iCount = 0; iCount <= 2; iCount++) {
      vPrintWiFiStatusString();
      Serial.print(" ");
      Serial.print(float(WiFi.RSSI()));
      Serial.print("dBm ");
      Serial.println();
      delay(1000);
    }
    //wdt_reEnable( );
    delay(1000);
  }
  
  // Inform user
  printWifiStatus();

}


// = = = = = = ==============================================================================
//             restartWebserverThingy()
//             Restart the WiFi and webserver if not connected. 
//             Ends old WIFI.
// = = = = = = ==============================================================================
void restartWebserverThingy() {
  // End old dead stuff
     Serial.println("WiFi Disconnected! (restartWebserverThingy)");
     server.flush();
     delay(1000);
     WiFi.disconnect();
     WiFi.end();
     delay(1000);

  // Restart the Wifi
    startWiFiSystem();
    printWifiStatus();
    Serial.println();

  // Restart the server
    server.begin();
    Serial.println("End Of restartWebserverThingy ");
}


// = = = = = = ==============================================================================
//             vCheckWIFIAndReset ()
//             Checks that the WiFi is running okay. Restarts if required.
// = = = = = = ==============================================================================
void vCheckWIFIAndReset() {
  if (WiFi.status() == WL_CONNECTION_LOST 
   || WiFi.status() == WL_DISCONNECTED 
  ) {
    wdt_disable( );
    Serial.print("WiFi Lost - Number Restarts: ");
    Serial.print(iWIFIRESTRT++);
    Serial.print(" Status = ");
    vPrintWiFiStatusString();
    Serial.println();
    restartWebserverThingy();
    vPrintWiFiStatusString();
    Serial.println("End Of vCheckWIFIAndReset ");
    wdt_reEnable( );
  }
  delay(100);
}
