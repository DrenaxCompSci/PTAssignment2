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
# Twilio setup
account_sid = "AC3ae40e42edc935551d4b2993f9dc44e4"
auth_token = "287a9d36b8b1f460751aed4111640218"
client = Client(account_sid, auth_token)

while True:
    movementData = ser.readline() # reads in data from serial
    if jsonCheck(movementData): # checks if input is valid json
        if not isinstance(movementData, (int, long)):
            jsonData = json.loads(movementData)
            if jsonData['id'] == "6": # if data is from receiver
                print("Data received!")
                print(movementData)
                # temperature threshholds
                if jsonData['temperature'] > 25:
                    parsed_json = json.loads('{"id": 5, "temperature": 0}')
                    temperatureStatus = "0"
                    #ser.write(json.dumps(parsed_json))
                    print("Temp above 25 degrees")
                else:
                    parsed_json = json.loads('{"id": 5, "temperature": 1}')
                    temperatureStatus = "1"
                    #ser.write(json.dumps(parsed_json))
                    print("Temp below 25 degrees")
                if jsonData['ldr'] < 190:
                    ldrStatus = "1"
                    print("ldr above 190")
                else:
                    ldrStatus = "0"
                    print("ldr below 190")
                jsonString = json.loads('{"id": 5, "radiator": ' + temperatureStatus + ', "motor": ' + ldrStatus + '}')
                ser.write(json.dumps(jsonString))
                time.sleep(5)
    else:
        print("Invalid json")

#while True:
    #movementData = ser.readline()
    #data = json.loads(movementData)
    #if data['temperature'] > 25:
      #  print("hot hot hot")
     #   data['id'] = 5
    #    ser.write(json.dumps(data))
        #client.api.account.messages.create(
        #    to="+447598722448",
        #    from_="+441422400297",
        #    body="Hey, it's bloody hot!")
    #else:
   #     data['id'] = 5
  #      print("nice")
 #       ser.write(json.dumps(data))
#    print(data['ldr'])

