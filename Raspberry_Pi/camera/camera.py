import picamera
import time
import serial
import paho.mqtt.client as mqtt
from twilio.rest import Client

'''
Twilio Sources...
https://www.twilio.com/docs/libraries/python

As it is a fairly simple setup for Twilio programmatically - following this guide was enough
for the actual functionality of sending a text message. All that needed changing were the
individual variables to match the correct phone numbers & auth codes, and a meaningful text
body to be sent. 

MQTT Sources...
https://pypi.python.org/pypi/paho-mqtt/1.1

Fundamentally this is also similar, but has a lot of other logic within it. It connects to
the broker running on the Pi, and displays a message to ensure this is the case. Then it subscribes
to the specified topic of the PIR sensor and waits for a message to be published. When this happens,
an image is captured through the Pi and a Twilio text message.
'''

# Twilio setup
account_sid = "AC3ae40e42edc935551d4b2993f9dc44e4"
auth_token = "287a9d36b8b1f460751aed4111640218"
twilioClient = Client(account_sid, auth_token)

# mqtt setup
client = mqtt.Client()
topic = "PT"

# camera setup
camera = picamera.PiCamera()
camera.vflip = True

# gives view of camera for calibration
camera.start_preview()
time.sleep(5)
camera.stop_preview()

# foundFlag = True
pictureCounter = 0
imgName = "intruder"
imgExtension = ".jpg"

# MQTT setup
def on_connect(client, userdata, flags, rc):
    print ("Connection established")
    client.subscribe(topic)

def on_message(client, userdata, msg):
    global pictureCounter
    print("Message received: ", str(msg.payload))
    imgFile = imgName + str(pictureCounter) + imgExtension
    camera.capture(imgFile) # update to variable jpg name
    pictureCounter = pictureCounter + 1
    #twilioClient.api.account.messages.create(
            #to="+447598722448",
            #from_="+441422400297",
            #body="An intruder has been detected! Image captured...")

client.on_connect = on_connect
client.on_message = on_message

client.connect("192.168.10.124", 1883)

print("Waiting on movement data")

client.loop_forever()
client.disconnect()

