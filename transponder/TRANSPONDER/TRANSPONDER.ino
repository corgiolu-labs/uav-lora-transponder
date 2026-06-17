
#include "LORA.h"


void setup()
{  
  
  Serial.begin(9600);
  Serial.println("Slave"); 
  delay(3000);

}

void loop()
{

Serial.println(TxMsg);
TransmissionRx();

}  


