import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import processing.serial.*; //library used to access serial ports
import controlP5.*; //library to create GUI

Serial port; //Defining serial port to read and write to.

PFont font; //create font object
ControlP5 cp5;  //create Controlp5 object

Kinect kinect; //Kinect object
float tilt; //Tilt variable to move kinect up and down 
boolean nightVision = false;

void setup() {
  size(600, 520); //Set kinect output image size
  kinect = new Kinect(this); //Initialise kinect object to plugged in kinect
  kinect.initVideo(); //Initialise video from kinect
  kinect.enableIR(true); //Enable infra red
  tilt = kinect.getTilt(); 
  
  // printArray(Serial.list());
   // port = new Serial(this, "/dev/cu.usbserial-DA01GW80", 9600); //name of serial port Arduino is using on my Mac or the serial port the Xbee is plugged into
  

  cp5 = new ControlP5(this); //create new cp5

  font = createFont("calibri light", 20); //set custom font
}

void draw() {
  background(0);
  image(kinect.getVideoImage(), 0, 0); //Set video image in centre of frame
}

void keyPressed() {
 
    if (keyCode == UP) { //If up key is pressed -- Keycode detects up, down left, right or shift
      tilt++;
    } else if (keyCode == DOWN) {// If down key is pressed
      tilt--;
    } else if (key == 'h'){
      saveFrame();
    } else  if(key == 'i'){
      nightVision = !nightVision;
      kinect.enableIR(nightVision);
    } 
    
    saveFrame("security.png");
    tilt = constrain(tilt, 0, 30); //Limit how far the kinect can be tilted
    kinect.setTilt(tilt); //Set the new tilt after a key press
  }