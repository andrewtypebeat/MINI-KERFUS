#include <Servo.h>

const int servoPin = 15;
int posDegrees = 90;

Servo myServo;

void setup() {
  Serial.begin(9600); //make sure this is the same as the Baud Rate in Godot.
  myServo.attach(servoPin);
}

void loop() {
  myServo.write(posDegrees);
  Serial.println(posDegrees);
  delay(20);

}
