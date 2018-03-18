import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import static javax.swing.JOptionPane.*;

Kinect kinect; //Kinect object
float tilt; //Tilt variable to move kinect up and down 
boolean nightVision = false;

void setup() {
  size(600, 520); //Set kinect output image size
  kinect = new Kinect(this); //Initialise kinect object to plugged in kinect
  kinect.initVideo(); //Initialise video from kinect
  kinect.enableIR(true); //Enable infra red
  tilt = kinect.getTilt(); 
}

void draw() {
  background(0);
  image(kinect.getVideoImage(), 0, 0); //Set video image in centre of frame
}

void keyPressed() {
 
    if (keyCode == UP) { //If up key is pressed -- Keycode detects up, down left, right or shift
      tilt+=10;
    } else if (keyCode == DOWN) {// If down key is pressed
      tilt-=10;
    } else if (key == 'c'){
      saveFrame();
       showMessageDialog(null, "Success! Image captured.", 
      "Kinect Camera", ERROR_MESSAGE);
    } else  if(key == 'i'){
      nightVision = !nightVision;
      kinect.enableIR(nightVision);
    }
    tilt = constrain(tilt, 0, 30); //Limit how far the kinect can be tilted
    kinect.setTilt(tilt); //Set the new tilt after a key press
  }