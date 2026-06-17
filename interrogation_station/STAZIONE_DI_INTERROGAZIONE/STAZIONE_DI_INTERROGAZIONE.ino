
#include "LORATX.h"


void setup() 
{
  
  Serial.begin(9600);
  Serial.println("Master"); 
  delay(3000);
  
}

void loop() 
{ 

TransmissionTx();


}
