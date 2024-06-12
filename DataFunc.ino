// = = = = = = ==============================================================================
//             printInfo ()
//             Periodically print to the serial line (one line space sep's)
// = = = = = = ==============================================================================
void printInfo() {

  // Sampled Data
  Serial.print(temperatureValue);
  Serial.print(" ");
  Serial.print(humidityValue);
  Serial.print(" ");
  Serial.print(pressureValue);
  Serial.print(" ");
  Serial.print(gasValue);
  Serial.print(" ");
  // Device Information
  Serial.print(iWIFIRESTRT);
  Serial.print(" ");
  Serial.print(CODEDIR);
  Serial.print(CODENAME);
  Serial.print(" ");
  Serial.print(DEVNAME);
  Serial.print(" ");
  Serial.print(WiFi.RSSI());
  Serial.print(" ");
  Serial.print(getIPAddressString());

  
  Serial.println();
}

