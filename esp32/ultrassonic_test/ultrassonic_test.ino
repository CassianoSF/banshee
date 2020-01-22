#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include "Ultrassonico.h"

#define SERVICE_UUID           "ab0828b1-198e-4351-b779-901fa0e0371e" 
#define CHARACTERISTIC_UUID_RX "4ac8a682-9736-4e5d-932b-e9b31405049c"
#define CHARACTERISTIC_UUID_TX "23bf1882-3af7-11ea-b77f-2e728ce88125"

BLECharacteristic *characteristicRX; 
BLECharacteristic *characteristicTX; 
Ultrassonico ultra(22,23);


class ServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
        Serial.println('connected!');
    };

    void onDisconnect(BLEServer* pServer) {
        Serial.println('disconnected!');
    }
};


class CharacteristicCallbacks: public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic *characteristic) {
      
        std::string rxValue = characteristic->getValue(); 
        characteristicTX->setValue(rxValue); 
        characteristicTX->notify(); 

        if (rxValue.length() > 0) {
            Serial.println("*********");
            Serial.print("Received Value: ");

            for (int i = 0; i < rxValue.length(); i++) {
                Serial.print(rxValue[i]);
            }

            Serial.println();
            Serial.println("*********");
        }
    }
};

void setup() {
    ultra.setup();
    Serial.begin(115200);

    BLEDevice::init("ESP32-BLE"); 
    
    BLEServer *server = BLEDevice::createServer(); 
    server->setCallbacks(new ServerCallbacks()); 
    
    BLEService *service = server->createService(SERVICE_UUID);
    
    characteristicTX = service->createCharacteristic(
        CHARACTERISTIC_UUID_TX, 
        BLECharacteristic::PROPERTY_READ  |
        BLECharacteristic::PROPERTY_WRITE  |
        BLECharacteristic::PROPERTY_NOTIFY |
        BLECharacteristic::PROPERTY_INDICATE
    );
    characteristicTX->addDescriptor(new BLEDescriptor((uint16_t)0x2902));

    characteristicRX = service->createCharacteristic(
        CHARACTERISTIC_UUID_RX, 
        BLECharacteristic::PROPERTY_READ  |
        BLECharacteristic::PROPERTY_WRITE  |
        BLECharacteristic::PROPERTY_NOTIFY |
        BLECharacteristic::PROPERTY_INDICATE
    );
    characteristicRX->addDescriptor(new BLEDescriptor((uint16_t)0x2901));
    characteristicRX->setCallbacks(new CharacteristicCallbacks());
    
    service->start();
    server->getAdvertising()->start();
    Serial.println("Waiting a client connection to notify...");

}

void loop() {
    float dist = ultra.distance();
    char str_dist[10];
    sprintf(str_dist, "%f", dist);
    characteristicTX->setValue(str_dist);
    Serial.println(dist);
    delay(10);
}
