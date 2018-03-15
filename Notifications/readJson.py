import serial
import json
from twilio.rest import Client

ser = serial.Serial('/dev/ttyACM0', 9600)
account_sid = "AC3ae40e42edc935551d4b2993f9dc44e4"
auth_token = "287a9d36b8b1f460751aed4111640218"

client = Client(account_sid, auth_token)

while True:
    movementData = ser.readline()
    data = json.loads(movementData)
    if data['temp'] > 20:
        print("hot hot hot")
        client.api.account.messages.create(
            to="+447598722448",
            from_="+441422400297",
            body="Hey, it's bloody hot!")
    else:
        print("nice")
    print(data['light'])

