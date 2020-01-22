#define DISTANCE 15
#define DEBUG 0

class Ultrassonico {
    public:
        Ultrassonico(
            int _trigger, 
            int _echo) : trigger(_trigger), 
                         echo(_echo) {}

        void setup();
        float distance();

    private:
        int trigger;
        int echo;
};

void Ultrassonico::setup(){
    pinMode(trigger, OUTPUT);
    pinMode(echo, INPUT);
}

float Ultrassonico::distance() {
    digitalWrite(trigger, LOW);
    delayMicroseconds(2);
    digitalWrite(trigger, HIGH);
    delayMicroseconds(10);
    digitalWrite(trigger, LOW);
    float dist = pulseIn(echo, HIGH) / 55.2466;
    return dist;
}