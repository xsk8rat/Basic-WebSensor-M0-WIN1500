
void   initializeBME680() {
  if (!sensorBME.begin()) {
    Serial.println("Could not find a valid BME680 sensor, check wiring!");
    while (1);
  }

  // Set up oversampling and filter initialization
  sensorBME.setTemperatureOversampling(BME680_OS_8X);
  sensorBME.setHumidityOversampling(BME680_OS_2X);
  sensorBME.setPressureOversampling(BME680_OS_4X);
  sensorBME.setIIRFilterSize(BME680_FILTER_SIZE_3);
  sensorBME.setGasHeater(320, 150); // 320*C for 150 ms
}

// = = = = = = ==============================================================================
//             sampleSensorData
// Samples the sensors and adds to the running average
// Stored in globals for now...
void sampleSensorData() {
 if (!sensorBME.performReading()) {
    Serial.println("Failed to perform reading :(");
    return;
  }
  float usePressure = sensorBME.pressure / 100.0;
  pressureValue     = pressureFilter.filter(usePressure);

  float useTemperature = sensorBME.temperature * 1.8 + 32.0;
  temperatureValue     = temperatureFilter.filter(useTemperature);

  float useHumidity = sensorBME.humidity;
  humidityValue     = humidityFilter.filter(useHumidity);
  
  float useGas = sensorBME.gas_resistance/1000;;
  gasValue     = gasFilter.filter(useGas);
}

