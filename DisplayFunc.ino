
// = = = = = = ==============================================================================
//             displayDatas ()
//             Periodically update the display
// = = = = = = ==============================================================================
void displayInfo() {
  display.clearDisplay();
  display.display();
  display.setTextSize(2);
  display.setCursor(0,0);
  if(temperatureValue<100) {
   display.print(" "); 
  }
  display.print(temperatureValue,1);
  display.println(" F");
  if(humidityValue<100) {
   display.print(" "); 
  }
  display.print(humidityValue,1);
  display.println(" %RH");
  display.print(pressureValue,1);
  display.println(" hPa");
  display.print(gasValue,1);
  display.println(" kOhm");

  delay(10);
  yield();
  display.display();
}

void initDisplay() {
  display.begin(0x3C, true); // Address 0x3C default
  Serial.println("OLED begun");
  display.clearDisplay();
  display.display();
  display.setRotation(3);
  display.setTextSize(1);
  display.setTextColor(SH110X_WHITE);
  display.setCursor(0,0);
  display.print("");
  display.display();
  delay(1000);
}

void displayWIFIStart () {
  // Display WiFi Notice
  display.clearDisplay();
  display.setTextSize(2);
  display.setCursor(0,0);
  display.println("Starting");
  display.println("WiFi");
  display.setTextSize(1);
  display.println(SECRET_SSID);
  display.display();
}

void displayWIFIStatus () {
  display.clearDisplay();
  display.setCursor(0,0);
  display.setTextSize(2);
  display.println("Connected: ");
  display.setTextSize(1);
  display.print(getIPAddressString());
  display.display();
  delay(2000);
}