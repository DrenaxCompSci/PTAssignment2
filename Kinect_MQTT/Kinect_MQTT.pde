import mqtt.*;

MQTTClient client;
String topic = "testTopic"; //Same as Pi Camera topic

void setup() {
  client = new MQTTClient(this);
  //client.connect("192.168.10.124", "1883"); //Connect to broker
  client.connect("mqtt://192.168.10.124", "Kinect"); //Connect to broker
  client.subscribe(topic); //Subscribe to test topic
}

void messageReceived(String topic, byte[] payload) {
  println("new message: " + topic + " - " + new String(payload)); //Print message received from broker that is published on topic
}