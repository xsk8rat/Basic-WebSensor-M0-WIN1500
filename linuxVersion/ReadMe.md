These files are for appending the data with a timestamp and the mathematica plotting of the time data.

Put the GetData_WebHumidity_000.bat in the cron file to periodically append sensor data to the JSON file.

The security of this approach is suspect.

The SensorReports_TaskOnly_002.nb is a Mathematica notebook that periodically generates plots of the sensor data. The functions for this are in the Tools_SesnorJSONImport_001.nb notebook.
