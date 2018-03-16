import serial
import json
import time
from twilio.rest import Client

ser = serial.Serial('/dev/ttyUSB0', 9600)
account_sid = "AC3ae40e42edc935551d4b2993f9dc44e4"
auth_token = "287a9d36b8b1f460751aed4111640218"

client = Client(account_sid, auth_token)

json_string = '{"id": 5}'

parsed_json = json.loads(json_string)
while True:
    ser.write(json.dumps(parsed_json))
    print("sent")
    time.sleep(5)

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

