char val;
const int TrigPin = 2;
const int EchoPin = 3;
int r = 0;
int g = 0;
int b = 0;


void setup()
{
  Serial.begin(9600);
  pinMode(EchoPin, INPUT);
  pinMode(TrigPin, OUTPUT);
  pinMode(9, OUTPUT);
  pinMode(10, OUTPUT);
  pinMode(11, OUTPUT);

}


void loop()
{
  digitalWrite(TrigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(TrigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(TrigPin, LOW);
  int distance = pulseIn(EchoPin, HIGH);
  distance = distance / 58;
  Serial.write(distance);

  while (Serial.available() > 0) {
    val = Serial.read();
  }
  if (val == "LitOn") {
    digitalWrite(9, HIGH);
    digitalWrite(10, HIGH);
    digitalWrite(11, HIGH);
  }
  else {
    digitalWrite(9, LOW);
    digitalWrite(10, LOW);
    digitalWrite(11, LOW);
  }

  
  if (distance >= 1 && distance <= 4) {
    analogWrite(9, 255);
    analogWrite(10, 0);
    analogWrite(11, 0);
  }

  if (distance > 4 && distance <= 7) {
    analogWrite(9, 255);
    analogWrite(10, 255);
    analogWrite(11, 0);
  }

  if (distance > 7 && distance <= 20) {
    analogWrite(9, 0);
    analogWrite(10, 255);
    analogWrite(11, 0);
  }
  delay(50);
}
