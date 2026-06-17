

import processing.serial.*;  // per importare le librerie di gestione della porta seriale
Serial myPort;               // Create object from Serial class

int   FID  = 0;              // IDENTIFICATIVO DEL DRONE
float Flat = 0.00;           // LATITUDINE ACQUISITA DA ARDUINO
float Flon = 0.00;           // LONGITUDINE ACQUISITA DA ARDUINO
float Falt = 0.00;           // ALTITUDINE ACQUISITA DA ARDUINO

         
float Flatp = 0.00;          // vecchia LATITUDINE ACQUISITA DA ARDUINO
float Flonp = 0.00;          // vecchia LONGITUDINE ACQUISITA DA ARDUINO
float Faltp = 0.00;          // vecchia ALTITUDINE ACQUISITA DA ARDUINO

int IDdrone1  = 0;
float Latdrone1 = 0.00;
float Londrone1 = 0.00;
float Altdrone1 = 0.00;

int IDdrone2  = 0;
float Latdrone2 = 0.00;
float Londrone2 = 0.00;
float Altdrone2 = 0.00;

int IDdrone3  = 0;
float Latdrone3 = 0.00;
float Londrone3 = 0.00;
float Altdrone3 = 0.00;

PShape sardinia;            // MAPPA VETTORIALE DELLA SARDEGNA
float l = 1.8;              // SCALA LA MAPPA INIZIALE
float mapWidth =  1000/l;   // LARGHEZZA in pixel DELLA MAPPA
float mapHeight = 1551/l;   // ALTEZZA in pixel DELLA MAPPA


float Xlon = 0;             // LONGITUDINE SCALATA SULLA MAPPA
float Ylat = 0;             // LATITUDINE SCALATA SULLA MAPPA

//////////////////////////  // Coordinates from google maps      (Lat,Lon)=(y,x)     (XLon)     (  y   ,   x  )
//////asse X//////////////                                                 (y,x) |------------->(  0   , Width)     
float MinLon =  08.132375;  // taratura mappa, ovest, 0                     (0,0) |///////////// (MinLat,MaxLon)
float MaxLon =  09.830139;  // taratura mappa, est,  width                       |//         //
//////////////////////////                                                       |//         //
//////asse Y//////////////                                       (  y   ,  x   ) |//         //
float MinLat =  41.256420;  // taratura mappa, nord, 0          (Heigh ,  0   ) |//         //
float MaxLat =  38.866051;  // taratura mappa, sud, heigh        (MaxLat,MinLon) |/////////////  
//////////////////////////                                                       V(YLat)

float e = 0;                // Variabile di controllo rotellina mouse
float zoom = 1;             // VARIABILE ZOOM ATTUALE
float bx = 0;               // MOUSE
float by = 0;               // MOUSE
float xOffset = 0.0;        // MOUSE
float yOffset = 0.0;        // MOUSE


void setup() {
  
  myPort = new Serial(this, "COM3", 9600); //porta seriale di comunicazione
  
  size(970, 1000);                         // Dimensioni della finestra dell'interfaccia grafica
  orientation (LANDSCAPE);                 // Orientazione
  ellipseMode(CENTER);                     // Modalità di disegno delle ellissi
  sardinia = loadShape("Vect_1000x1551_00.svg");  // Vettoriale della Sardegna
  
 }

void draw() 
{  
  
  background(80);               //Colora lo sfondo in grigio 
  sardinia.disableStyle();      // Ignore the colors in the SVG
  fill(255, 200, 50);           // Set the SVG fill to blue
  stroke(100);                  // Set the SVG fill to white
  
  shape(sardinia, bx*zoom, by*zoom, mapWidth*zoom, mapHeight*zoom);  //POSIZIONARE LA MAPPA NEL ANGOLO IN ALTO A SINISTRA
  
  pushMatrix();                 // SALVA LO STATO ATTUALE DELLE COORDINATE (serve per il testo delle coordinate)
   
  position();                   //CHIEDO DI LEGGERE LA SERIALE
  
  
  
//  ABILITANO UNA PORZIONE DI PIANO ALL' ESSERE UTILIZZATO PER GESTIRE LO ZOOM DEL GRAFICO
////////////////////////////////////////////////////////////////////////////////////////////  
  if (mouseX >650 && mouseX <800 && mouseY >0 && mouseY < 130 && mousePressed) {
    zoom = zoom+0.02;
  }
  if (mouseX >650 && mouseX <800 && mouseY >330 && mouseY <480 && mousePressed) {
    zoom = zoom-0.02;
  }
  scale (zoom); 
  
  
//  ZOOM CON ROTELLINA MOUSE  
////////////////////////////////////////////////////////////////////////////////////  
  
 while(e == -1) {
    zoom = zoom+0.1;
    e = -2;
  }
  while (e == 1) {
    zoom = zoom-0.1;
    e = -2;
  }
  scale (zoom); 
  
                                                                                                                   
//  PLOTTA A VIDEO IL PUNTO CORRISPONDENTE AL TARGHET (Y=LATITUDINE, X=LONGITUDINE)   
//////////////////////////////////////////////////////////////////////////////////

// DRONE 1
float Xlon1 = map(Londrone1, MinLon, MaxLon, 0, (mapWidth +(-35 ))/zoom); // FUNZIONE CHE SCALA LE COORDINATE REALI SULLA MAPPA VIRTUALE
float Ylat1 = map(Latdrone1, MinLat, MaxLat, 0, (mapHeight+(+5))/zoom); // FUNZIONE CHE SCALA LE COORDINATE REALI SULLA MAPPA VIRTUALE

fill (255, 0, 0);
noStroke();
ellipse( Xlon1 + bx/zoom,  Ylat1 + by/zoom, 10/zoom, 10/zoom); // PUNTINO ROSSO

// DRONE 2
float Xlon2 = map(Londrone2, MinLon, MaxLon , 0, (mapWidth +(-35 ))/zoom); // FUNZIONE CHE SCALA LE COORDINATE REALI SULLA MAPPA VIRTUALE
float Ylat2 = map(Latdrone2, MinLat, MaxLat , 0, (mapHeight+(+5))/zoom); // FUNZIONE CHE SCALA LE COORDINATE REALI SULLA MAPPA VIRTUALE
 
fill (0, 255, 0);
noStroke();
ellipse(Xlon2 + bx/zoom,  Ylat2 + by/zoom, 10/zoom, 10/zoom); // PUNTINO VERDE

// DRONE 3
float Xlon3 = map(Londrone3, MinLon, MaxLon , 0, (mapWidth +(-35 ))/zoom); // FUNZIONE CHE SCALA LE COORDINATE REALI SULLA MAPPA VIRTUALE
float Ylat3 = map(Latdrone3, MinLat, MaxLat , 0, (mapHeight+(+5))/zoom); // FUNZIONE CHE SCALA LE COORDINATE REALI SULLA MAPPA VIRTUALE
 
fill (0, 0, 255);
noStroke();
ellipse(Xlon3 + bx/zoom,  Ylat3 + by/zoom, 10/zoom, 10/zoom); // PUNTINO BLU


print(FID + ",  ");
print(Flat + ",  ");
print(Flon + ",  ");
println(Falt); 
  
popMatrix(); // LEGA IL TESTO DELLE COORDINATE CON LA MAPPA CHE ZOOMMA E UNZOOMMA
texto();

} 


//  FUNZIONI DI SUPPORTO PER IL TRASCINAMENTO DELLA MAPPA
//////////////////////////////////////////////////////////////////////
void mouseDragged() { 
  bx = (mouseX-xOffset); 
  by = (mouseY-yOffset);
}
void mousePressed() { 
  xOffset = (mouseX-bx); 
  yOffset = (mouseY-by);
}

//INTERAGISCE CON LA ROTELLA DEL MOUSE PER LO ZOOM
///////////////////////////////////////////////////
void mouseWheel(MouseEvent event) {
  e = event.getCount();
}

//  PLOTTA A VIDEO IL VALORE DEI GRADI LONGITUDINE, LATITUDINE, ALTITUDINE ED IL CODICE IDENTIFICATIVO
///////////////////////////////////////////////////////////////////////////////////////////////////////
void texto() { 
  fill (250, 250, 250, 250);
  rect (0, 900, width, 480);
  fill (0);
  textSize (20);
  
  
  fill (255, 0, 0);
  ellipse(10, 920 , 10, 10); // PUNTINO ROSSO
  text (Londrone1 + "E" + "   " + Altdrone1 + "m  s.l.m", 220, 930);
  text ("ID: 0"+ IDdrone1 + "   " + Latdrone1 + "N" , 30, 930);
  
  
  fill (0, 255, 0);
  ellipse(10, 950 , 10, 10); // PUNTINO VERDE
  text (Londrone2 + "E" + "   " + Altdrone2 + "m  s.l.m", 220, 960);
  text ("ID: 0"+ IDdrone2 + "   " + Latdrone2 + "N" , 30, 960);
  
  fill (0, 0, 255);
  ellipse(10, 980 , 10, 10); // PUNTINO BLU
  text (Londrone3 + "E" + "   " + Altdrone3 + "m  s.l.m", 220, 990);
  text ("ID: 0"+ IDdrone3 + "   " + Latdrone3 + "N" , 30, 990);
  
  textSize (120);
  fill (255, 255, 0, 50);
  ellipse (730, 50, 80, 80);
  ellipse (730, 400, 80, 80);
  fill (0);
  text ("+", 700, 89);
  text ("-", 710, 430);
}

// FUNZIONE DI LETTURA DALLA SERIALE
/////////////////////////////////////////////////////////////////////////
void position(){
  
 String POSITION = myPort.readStringUntil('\n');
 
  if (POSITION != null) {  // if theres data in between the new lines
  POSITION = trim(POSITION); // get rid of any whitespace just in case

  String[] list ;
  
   try {
    list = split(POSITION, ',');
    
          FID  = int   (list[0]);   // Codice identificativo
          Flat = float (list[1]);   // Latitudine
          Flon = float (list[2]);   // Longitudine     
          Falt = float (list[3]);   // Altitudine
    
  } catch (ArrayIndexOutOfBoundsException e) {
    list = null;
  }
  if (list == null) {
    delay(500);
  }
         
         Flatp = Flat;
         delay(20);
         Flonp = Flon;
         delay(20);
         Faltp = Falt;
         delay(20);
              
          
        if(FID == 218){ 
          
          IDdrone1  = FID;
          Latdrone1 = Flat;
          Londrone1 = Flon;
          Altdrone1 = Falt;
        }/* else {
        IDdrone1  = 218;  
        Latdrone1 = Flatp;
        Londrone1 = Flon;
        Altdrone1 = Falt;
        }*/
          
        if(FID == 318){
          
          IDdrone2  = FID;
          Latdrone2 = Flat;
          Londrone2 = Flon;
          Altdrone2 = Falt;
        }/* else {
        IDdrone2  = 318;  
        Latdrone2 = Flatp;
        Londrone2 = Flonp;
        Altdrone2 = Faltp;
        }*/
          
         if(FID == 418){
           
          IDdrone3  = FID; 
          Latdrone3 = Flat;
          Londrone3 = Flon;
          Altdrone3 = Falt;
        }/*else {
        IDdrone3  = 418;  
        Latdrone3 = Flatp;
        Londrone3 = Flonp;
        Altdrone3 = Faltp;
        }*/
       
  }       
}
