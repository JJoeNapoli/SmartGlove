// LIBRERIA I2C 

#include "I2Cdev.h"
#include "MPU6050.h"
#include "Wire.h"

// LIBRERIA WI-FI COMMUNICATION

#include <SPI.h>
#include <WiFiNINA.h>
#include <WiFiUdp.h>
#include "arduino_secrets.h"

int number_imu=12;
// CREAZIONE OGGETTO MPU6050
MPU6050 accelgyro[25];

uint32_t timer; 
int id=0;


//NETWORK DATA
IPAddress ip(130,251,13,118);
int status = WL_IDLE_STATUS; 
char ssid[] = SECRET_SSID;          // your network SSID (name)
char pass[] = SECRET_PASS;          // your network password (use for WPA, or use as key for WEP)
unsigned int localPort = 5001;   
WiFiUDP Udp;

// PARAMETRIZZAZIONE CALIBRAZIONE

//Change this 3 variables if you want to fine tune the skecth to your needs.
int buffersize=1000;     //Amount of readings used to average, make it higher to get more precision but sketch will be slower  (default:1000)
int acel_deadzone=8;     //Acelerometer error allowed, make it lower to get more precision, but sketch may not converge  (default:8)
int giro_deadzone=1;     //Giro error allowed, make it lower to get more precision, but sketch may not converge  (default:1)

int16_t ax, ay, az,gx, gy, gz;
int16_t Ax, Ay, Az,Gx, Gy, Gz;

int mean_ax,mean_ay,mean_az,mean_gx,mean_gy,mean_gz,state=0;
int ax_offset,ay_offset,az_offset,gx_offset,gy_offset,gz_offset;

//CONVERSION FACTOR
float to_g_force;

void setup() {

  NetworkSetting();
  
   #if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
        Wire.begin();
   #elif I2CDEV_IMPLEMENTATION == I2CDEV_BUILTIN_FASTWIRE
        Fastwire::setup(400, true);
   #endif

   Wire.begin();
   
   Serial.begin(38400);
    
   Serial.println("Initializing I2C devices...");

   to_g_force = 1./ (16384);
   
for(int l=0;l<number_imu;l++){
   int i;
   i=l;
   if(i>5){i=i+9;}
   pinMode(i , OUTPUT);}
for(int l=0;l<number_imu;l++){
   int i;
   i=l;
   if(i>5){i=i+9;}

  //due variabili perchè: j mi serve per attivare tutti gli indirizzi. Mentre la k serve per avere gli indirizzi giusti, quindi
  //j-> numero di imu collegati
  //k-> indirizzo che vogliamo, imu 6 avrà indirizzo 15

     
for(int j=0;j<number_imu;j++){  

   int k;
   k=j;
   if(k>5){k=k+9;}
   if(i==k){digitalWrite(k, LOW);}
   else {digitalWrite(k, HIGH);}
   }
   Serial.begin(115200); 


   accelgyro[i].initialize();

    // wait for ready
//    while (Serial.available() && Serial.read()); // empty buffer
//    while (!Serial.available()){
//      Serial.println(F("Send any character to start sketch.\n"));
//      delay(1500);
//    }                
    while (Serial.available() && Serial.read()); // empty buffer again
    Serial.println("Testing device connections...");
   
    //controllo tutte le connessioni
    //int flag = accelgyro[i].testConnection() ;
    Serial.println(accelgyro[i].testConnection() ? "MPU6050 connection successful" : "MPU6050 connection failed");

  if(accelgyro[i].testConnection()==true){
   

   calibration(accelgyro[i]);}
       
 }

 
 }

void loop() {
  
for(int l=0;l<number_imu;l++){

   int i;
   i=l;
   if(i>5){i=i+9;}
  
for(int j=0;j<number_imu;j++){  

   int k;
   k=j;
   if(k>5){k=k+9;} 
   
   if(i==k){digitalWrite(k, LOW);}
   else {digitalWrite(k, HIGH);}
   }

  Serial.begin(115200); 

  accelgyro[i].getMotion6(&Ax, &Ay, &Az, &Gx, &Gy, &Gz);
  timer = micros();

  //questo stampa 1,2,3,4,5,15,16,17..
  id = i;
  //se volessi gli id 1,2,3,4,5,6,7...
  //id=j;
  
  sendData(id,Ax,Ay,Az,Gx,Gy,Gz,timer);
}
}


void NetworkSetting(){
  
  // check for the WiFi module:
  if (WiFi.status() == WL_NO_MODULE) {
    Serial.println("Communication with WiFi module failed!");
   // don't continue
    while (true);
  }

  String fv = WiFi.firmwareVersion();
  if (fv < "1.0.0") {
    Serial.println("Please upgrade the firmware");
  }

  // attempt to connect to Wifi network:
  while (status != WL_CONNECTED) {
    Serial.print("Attempting to connect to SSID: ");
    Serial.println(ssid);
    // Connect to WPA/WPA2 network. Change this line if using open or WEP network:
    status = WiFi.begin(ssid, pass);

    // wait 10 seconds for connection:
    delay(10000);
  }
  Serial.println("Connected to wifi");
  printWifiStatus();

  Serial.println("\nStarting connection to server...");
  // if you get a connection, report back via serial:
  Udp.begin(localPort);
  
}

void printWifiStatus() {
  // print the SSID of the network you're attached to:
  Serial.print("SSID: ");
  Serial.println(WiFi.SSID());

  // print your board's IP address:
  IPAddress ip = WiFi.localIP();
  Serial.print("IP Address: ");
  Serial.println(ip);

  // print the received signal strength:
  long rssi = WiFi.RSSI();
  Serial.print("signal strength (RSSI):");
  Serial.print(rssi);
  Serial.println(" dBm");
}

void calibration(MPU6050 accelgyro){

  Serial.println("\nMPU6050 Calibration Sketch");
  delay(2000);
  Serial.println("\nYour MPU6050 should be placed in horizontal position, with package letters facing up. \nDon't touch it until you see a finish message.\n");
  delay(3000);

    accelgyro.setXAccelOffset(0);
    accelgyro.setYAccelOffset(0);
    accelgyro.setZAccelOffset(0);
    accelgyro.setXGyroOffset(0);
    accelgyro.setYGyroOffset(0);
    accelgyro.setZGyroOffset(0);
  

  if (state==0){
    Serial.println("\nReading sensors for first time...");
    meansensors(accelgyro);
    state++;
    delay(1000);
  }
  
  if (state==1) {
    Serial.println("\nCalculating offsets...");
    calibration_gyro(accelgyro);
    state++;
    delay(1000);
  }

  if (state==2) {
    meansensors(accelgyro);
    Serial.println("\nFINISHED!");
    Serial.print("\nSensor readings with offsets:\t");
    Serial.print(mean_ax); 
    Serial.print("\t");
    Serial.print(mean_ay); 
    Serial.print("\t");
    Serial.print(mean_az); 
    Serial.print("\t");
    Serial.print(mean_gx); 
    Serial.print("\t");
    Serial.print(mean_gy); 
    Serial.print("\t");
    Serial.println(mean_gz);
    Serial.print("Your offsets:\t");
    Serial.print(ax_offset); 
    Serial.print("\t");
    Serial.print(ay_offset); 
    Serial.print("\t");
    Serial.print(az_offset); 
    Serial.print("\t");
    Serial.print(gx_offset); 
    Serial.print("\t");
    Serial.print(gy_offset); 
    Serial.print("\t");
    Serial.println(gz_offset); 
    Serial.println("\nData is printed as: acelX acelY acelZ giroX giroY giroZ");
    Serial.println("Check that your sensor readings are close to 0 0 16384 0 0 0");
    Serial.println("If calibration was succesful write down your offsets so you can set them in your projects using something similar to mpu.setXAccelOffset(youroffset)");
  }

  state=0;  
  
}

// -------------------------------------------------------CALCOLO VALORE MEDIO --------------------------------------------------------


void meansensors(MPU6050 accelgyro){
  long i=0,buff_ax=0,buff_ay=0,buff_az=0,buff_gx=0,buff_gy=0,buff_gz=0;

  while (i<(buffersize+101)){
    // read raw accel/gyro measurements from device
    accelgyro.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);
    
    if (i>100 && i<=(buffersize+100)){ //First 100 measures are discarded
      buff_ax=buff_ax+ax;
      buff_ay=buff_ay+ay;
      buff_az=buff_az+az;
      buff_gx=buff_gx+gx;
      buff_gy=buff_gy+gy;
      buff_gz=buff_gz+gz;
    }
    if (i==(buffersize+100)){
      mean_ax=buff_ax/buffersize;
      mean_ay=buff_ay/buffersize;
      mean_az=buff_az/buffersize;
      mean_gx=buff_gx/buffersize;
      mean_gy=buff_gy/buffersize;
      mean_gz=buff_gz/buffersize;
    }
    i++;
    delay(2); //Needed so we don't get repeated measures
  }
}

//----------------------------------------------------- ALGORITMO DI CALIBRAZIONE -----------------------------------------------------

void calibration_gyro(MPU6050 accelgyro){
  
  ax_offset=-mean_ax/8;
  ay_offset=-mean_ay/8;
  az_offset=(16384-mean_az)/8;

  gx_offset=-mean_gx/4;
  gy_offset=-mean_gy/4;
  gz_offset=-mean_gz/4;
  
  while (1){
    
    int ready=0;

    accelgyro.setXAccelOffset(ax_offset);
    accelgyro.setYAccelOffset(ay_offset);
    accelgyro.setZAccelOffset(az_offset);

    accelgyro.setXGyroOffset(gx_offset);
    accelgyro.setYGyroOffset(gy_offset);
    accelgyro.setZGyroOffset(gz_offset);
    
    meansensors(accelgyro);
    Serial.println("...");
      
    if (abs(mean_ax)<=acel_deadzone) ready++;
    else ax_offset=ax_offset-mean_ax/acel_deadzone;

    if (abs(mean_ay)<=acel_deadzone) ready++;
    else ay_offset=ay_offset-mean_ay/acel_deadzone;

    if (abs(16384-mean_az)<=acel_deadzone) ready++;
    else az_offset=az_offset+(16384-mean_az)/acel_deadzone;

    if (abs(mean_gx)<=giro_deadzone) ready++;
    else gx_offset=gx_offset-mean_gx/(giro_deadzone+1);

    if (abs(mean_gy)<=giro_deadzone) ready++;
    else gy_offset=gy_offset-mean_gy/(giro_deadzone+1);

    if (abs(mean_gz)<=giro_deadzone) ready++;
    else gz_offset=gz_offset-mean_gz/(giro_deadzone+1);

    if (ready==6) break;
  }
}

void sendData(int id,int Ax,int Ay,int Az,int Gx,int Gy,int Gz,uint32_t timer){

  float Ax_g = Ax * to_g_force;
  float Ay_g = Ay * to_g_force;
  float Az_g = Az * to_g_force;
  
  String data = "A" + String(Ax_g) + "B"+ String(Ay_g) + "C" + String(Az_g) + "D" + String(Gx) + "E" + String(Gy) + "F" + String(Gz) +"G"+ String(id)+"H"+ String(timer)+"I";
  int length = data.indexOf("I") +2;
  char data_final[length+1];
  data.toCharArray(data_final, length+1); 
  
  Udp.beginPacket(ip,localPort);
  Udp.write(data_final);
  Udp.endPacket();  
}
    
