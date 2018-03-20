//Kinect code example used and modified: https://github.com/shiffman/OpenKinect-for-Processing
//MQTT example code used and modified: https://github.com/256dpi/processing-mqtt
/*
The code accesses the kinect IR camera to increase the visibility of the kinect output if there are low level 
lighting conditions e.g. if its dark). The IR emitter from the Kinect camera enables a clearer image due to the 
IR light being sent from the emitter lighting up the room, this gives of a night vision effect and makes the image 
considerabley clearer. If the lighting conditions are sufficient, the normal camera is used. The camera used 
on the kinect is set by default depending on the time (that is obtained from the system time). The user can 
also manually set which camera is being used by pressing the "i" key on the keyboard. The up and down keys can also
be used to tilt the kinect up and down, and the 'c' key can be pressed to take a live photo of the kinect video stream. 

The kinect application is also integrated with Paho MQTT. The application is subscribed to the "PT" topic on the broker,
and if a message is sent on the topic, the application receives this and takes a picture automatically. A message is sent on the
topic when the PIR sensor in the automation system detects movement. 

Each photo taken either manually or automatically is saved to the same directory the application is located in with a unique 
time stamp of when the photo is taken. 

The GUI displays the last command initiated by the application at the bottom of the GUI as a string to inform the user of the last executed event.  

This is the code running on the Raspberry Pi 3 to obtain a live stream and take photos either manually, or using MQTT.
*/

import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import static javax.swing.JOptionPane.*;
import java.util.Calendar;
import mqtt.*;

//Variables used to Kinect
Kinect kinect; //Kinect object
float tilt; //Tilt variable to move kinect up and down 
boolean nightVision = false;

//Variables used for obtaining the current time from the system
Calendar rightNow = Calendar.getInstance();
int hour = rightNow.get(Calendar.HOUR_OF_DAY);
int lastHour = 25;
String message =  "Kinect camera starting...";

//Variables used for MQTT communication
MQTTClient client;
String topic = "PT"; //Same as Pi Camera topic

//Function to setup MQTT communications and kinect
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
  rightNow = Calendar.getInstance();
  background(0);
  image(kinect.getVideoImage(), 0, 0); //Set video image in centre of frame
  text(message, 10, 515);
  
  if(hour != lastHour){
     System.out.println("Automatically setting Kinect lense format...");
     message = "Automatically setting Kinect lense format...";
  
  cameraTime();
  }
}

//Function used to set the default camera used depending on the time of day 
void cameraTime(){
  System.out.println("setting camera lense...");
  if((hour >= 9) && (hour < 19)){
    kinect.enableIR(false); //Disable infra red
    nightVision = false; 
    System.out.println("Day time detected. Disabling IR...");
    message = "Day time detected. Disabling IR...";
  }else if(hour >= 19){
    kinect.enableIR(true); //Enable infra red
    nightVision = true; 
    System.out.println("Night time detected. Enabling night vision...");
    message = "Night time detected. Enabling IR...";
  }else if(hour < 9){
    kinect.enableIR(true); //Enable infra red
    nightVision = true; 
    System.out.println("Night time detected. Enabling night vision...");
    message = "Night time detected. Enabling IR...";
  }
   lastHour = hour;
}

//Detected what keys are pressed to initiate actions on the Kinect
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
      saveFrame("security_" + rightNow.getTime().toString() + ".jpg");
       showMessageDialog(null, "Success! Image captured.", 
      "Kinect Camera", ERROR_MESSAGE);
       message = "Image captured and saved to kinect directory.";
       System.out.println("Image captured and saved to kinect directory.");
       //System.out.println(rightNow.getTime().toString());
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
  
  //Function used when a message is received on topic via Paho MQTT
  void messageReceived(String topic, byte[] messages) {
  println("new message from  " + topic + ": " + new String(messages)); //Print message received from broker that is published on topic
  saveFrame("security_" + rightNow.getTime().toString() + ".jpg");
  System.out.println("Automated picture taken!");
  message = "Automated picture taken!";
  
}