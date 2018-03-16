import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import processing.serial.*; //library used to access serial ports
import controlP5.*; //library to create GUI
import java.awt.Robot;
import java.awt.AWTException;
import java.awt.event.InputEvent;
import java.awt.event.KeyEvent;
import static javax.swing.JOptionPane.*;

Robot robot;

Serial port; //Defining serial port to read and write to.

PFont font; //create font object
ControlP5 cp5;  //create Controlp5 object
kinectControls cf;
int value; 

Kinect kinect; //Kinect object
float tilt; //Tilt variable to move kinect up and down 
boolean nightVision = false;

void settings() {
  size(600,500,P3D);
}
void setup() {
  size(600, 500); //Set kinect output image size
  kinect = new Kinect(this); //Initialise kinect object to plugged in kinect
  kinect.initVideo(); //Initialise video from kinect
  kinect.enableIR(true); //Enable infra red
  tilt = kinect.getTilt(); 
  
  cf = new kinectControls(this, 400, 380, "Controls");
  surface.setLocation(420,10);
  noStroke();
  
  font = createFont("calibri light", 20); //set custom font
  
      
//Creating robot
  try { 
    robot = new Robot();
  } catch (AWTException e) {
    e.printStackTrace();
    exit();
  }
}

void draw() {
  background(0);
  image(kinect.getVideoImage(), 0, 0); //Set video image in centre of frame
  keyPressed();
  
}

void keyPressed() {
 
    if (value == 1){ //If up key is pressed -- Keycode detects up, down left, right or shift
      tilt+=10;
      System.out.println("value " + value);
      value = 0;
    } else if (value == 2) {// If down key is pressed
      tilt-=10;
       System.out.println("value " + value);
      value = 0;
    } else if (value == 3){
      saveFrame();
       System.out.println("value " + value);
       showMessageDialog(null, "Success! Image captured.", 
      "Kinect Camera", ERROR_MESSAGE);
      value = 0;
    } else  if(value == 4){
       System.out.println("value " + value);
      value = 0;
      nightVision = !nightVision;
      kinect.enableIR(nightVision);
    } 
    
    saveFrame("security.png");
    tilt = constrain(tilt, 0, 30); //Limit how far the kinect can be tilted
    kinect.setTilt(tilt); //Set the new tilt after a key press
  }
  
 
  class kinectControls extends PApplet {

  int w, h;
  PApplet parent;
  ControlP5 cp5;

  public kinectControls(PApplet _parent, int _w, int _h, String _name) {
    super();   
    parent = _parent;
    w=_w;
    h=_h;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    size(w,h);
  }

  public void setup() {
    surface.setLocation(10,10);
    font = createFont("calibri light", 20); //set custom font
    cp5 = new ControlP5(this);
    cp5.addButton("Up").plugTo(parent, "value").setValue(1).setPosition(70, 150).setSize (110, 80).setFont(font);
    cp5.addButton("Down").plugTo(parent, "value").setValue(2).setPosition(210, 150).setSize (110, 80).setFont(font);
    cp5.addButton("Capture").plugTo(parent, "value").setValue(3).setPosition(70,250).setSize (250, 80).setFont(font);
    cp5.addButton("Toggle Night Vision").plugTo(parent, "value").setValue(4).setPosition(70,50).setSize (250, 80).setFont(font);
  }
  

  void draw() {
    background(40);
  }
}