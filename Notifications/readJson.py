import serial
import json
import time
from twilio.rest import Client

# bool, checks if valid json
def jsonCheck(someJson):
    try:
        jsonData = json.loads(someJson)
    except ValueError, e:
        return False
    return True

# usb setup
ser = serial.Serial('/dev/ttyUSB0', 9600)

blindStatus = "0" # 0 means the blind is up, 1 means the blind is down

while True:
    LDRData = 0
    TemperatureData = 0
    while LDRData == 0 or TemperatureData == 0:
        sensorData = ser.readline()
        if jsonCheck(sensorData):
            try:
                jsonSensorData = json.loads(sensorData)
                sensorId = jsonSensorData['id']
                print("Json data: ", jsonSensorData)
                if sensorId == 1: # pir
                    PIRData = jsonSensorData['value']
                elif sensorId == 2: # ldr
                    LDRData = jsonSensorData['value']
                elif sensorId == 3: # thermistor
                    TemperatureData = jsonSensorData['value']
            except TypeError:
                print("ERROR: Integer has been passed in")
        
    print("All Data received")

    if TemperatureData > 25:
        temperatureStatus = "0"
    else:
        temperatureStatus = "1"
        
    if LDRData > 140: # too dark
        if blindStatus == "0": # if blind is up do nothing
            ldrStatus = "0"
        else: # else put blind up
            ldrStatus = "1"
            blindStatus = "0"
            print("Moving blind up")
    else: # too light
        if blindStatus == "1": # if blind is down do nothing 
            ldrStatus = "0"
        else:
            ldrStatus = "1" # else put blind down
            blindStatus = "1"
            print("Moving blind down")
            
    jsonString = json.loads('{"id": 7, "radiator": ' + temperatureStatus + ', "motor": ' + ldrStatus + '}')
    print("Broadcasting JSON packet...")
    print(jsonString)
    ser.write(json.dumps(jsonString))