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

foundFlag = True
pictureCounter = 0
imgName = "intruder"
imgExtension = ".jpg"

print("Waiting on movement data")
# reads arduino data forever, capturing an image if H is detected
while foundFlag:
	movementData = ser.read()
	print(movementData)
	
	if movementData == 'H':
            print("In if statement")
            foundFlag = False
            imgFile = imgName + str(pictureCounter) + imgExtension
            camera.capture(imgFile) # update to variable jpg name
            pictureCounter = pictureCounter + 1
            while movementData != 'L':
                movementData = ser.read()
                foundFlag = True
            
        

