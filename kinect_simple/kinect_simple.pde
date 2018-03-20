//Kinect code example used and modified: https://github.com/shiffman/OpenKinect-for-Processing
//MQTT example code used and modified: https://github.com/256dpi/processing-mqtt

//This is the code running on the Raspberry Pi 3 to obtain a live stream and take photos either manually, or using MQTT.
import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import static javax.swing.JOptionPane.*;
import java.util.Calendar;
import mqtt.*;

Kinect kinect; //Kinect object
float tilt; //Tilt variable to move kinect up and down 
boolean nightVision = false;

Calendar rightNow = Calendar.getInstance();
int hour = rightNow.get(Calendar.HOUR_OF_DAY);
int lastHour = 25;
String message =  "Kinect camera starting...";

MQTTClient client;
String topic = "testTopic"; //Same as Pi Camera topic

void setup() {
  client = new MQTTClient(this);
  client.connect("mqtt://192.168.10.124", "Kinect"); //Connect to broker
  client.subscribe(topic); //Subscribe to test topic
  
  size(600, 520); //Set kinect output image size
  kinect = new Kinect(this); //Initialise kinect object to plugged in kinect
  kinect.initVideo(); //Initialise video from kinect
  kinect.enableIR(true); //Enable infra red
  tilt = kinect.getTilt(); 
}

void draw() {
  background(0);
  image(kinect.getVideoImage(), 0, 0); //Set video image in centre of frame
  text(message, 10, 515);
  
  if(hour != lastHour){
     System.out.println("Automatically setting Kinect lense format...");
     message = "Automatically setting Kinect lense format...";
  
  cameraTime();
  }
}

void cameraTime(){
  System.out.println("setting camera lense...");
  if((hour >= 9) && (hour < 19)){
    kinect.enableIR(false); //Disable infra red
    System.out.println("Day time detected. Disabling IR...");
    message = "Day time detected. Disabling IR...";
  }else if(hour >= 19){
    kinect.enableIR(true); //Enable infra red
    System.out.println("Night time detected. Enabling night vision...");
    message = "Night time detected. Enabling IR...";
  }else if(hour < 9){
    kinect.enableIR(true); //Enable infra red
    System.out.println("Night time detected. Enabling night vision...");
    message = "Night time detected. Enabling IR...";
  }
   lastHour = hour;
}

void keyPressed() {
 
    if (keyCode == UP) { //If up key is pressed -- Keycode detects up, down left, right or shift
      tilt+=10;
      System.out.println("Tilting Kinect up");
        message = "Tilting Kinect up...";
    } else if (keyCode == DOWN) {// If down key is pressed
      tilt-=10;
      message = "Tilting Kinect down...";
      System.out.println("Tilting Kinect down...");
    } else if (key == 'c'){
      saveFrame();
       showMessageDialog(null, "Success! Image captured.", 
      "Kinect Camera", ERROR_MESSAGE);
       message = "Image captured and saved to kinect directory.";
    } else  if(key == 'i'){
      nightVision = !nightVision;
      kinect.enableIR(nightVision);
      if(nightVision == false){
         message = "Switching night vision off. Normal lense enabled...";
      System.out.println("Toggling Night Vision...");
      }else{
        message = "Switching night vision on. Normal lense disabled...";
      }
     
    }
    tilt = constrain(tilt, 0, 30); //Limit how far the kinect can be tilted
    kinect.setTilt(tilt); //Set the new tilt after a key press
  }
  
  
  void messageReceived(String topic, byte[] messages) {
  println("new message from  " + topic + ": " + new String(messages)); //Print message received from broker that is published on topic
  saveFrame(); 
  System.out.println("Automated picture taken!");
  message = "Automated picture taken!";
  
}