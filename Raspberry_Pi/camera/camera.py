import picamera
import time
import serial

ser = serial.Serial('/dev/ttyACM0', 9600)

camera = picamera.PiCamera()
camera.vflip = True

# gives view of camera for calibration
camera.start_preview()
time.sleep(5)
camera.stop_preview()

# reads arduino data forever, capturing an image if H is detected
while True:
	movementData = ser.readline()
	if movementData == 'H':
		camera.capture('intruder.jpg') # update to variable jpg name
