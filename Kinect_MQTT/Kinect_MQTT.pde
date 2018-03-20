//MQTT example code used and modified: https://github.com/256dpi/processing-mqtt

//This code has been modified and integrated into both kinect applications to enable photo capturing via MQTT.
import mqtt.*;

MQTTClient client;
String topic = "testTopic"; //Same as Pi Camera topic

void setup() {
  client = new MQTTClient(this);
  client.connect("mqtt://192.168.10.124", "Kinect"); //Connect to broker
  client.subscribe(topic); //Subscribe to test topic
}

void draw(){
}

void messageReceived(String topic, byte[] payload) {
  println("new message: " + topic + " - " + new String(payload)); //Print message received from broker that is published on topic
}