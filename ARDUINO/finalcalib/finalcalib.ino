/// THE CODE IS PERFORMED TAKING INTO ACCOUNT TWO ONLY IMUs

// FASE SETUP
// FASE 1: CONNESSIONE A INTERNET DELL'ARDUINO
// FASE 2: VERIFICA CONNESSIONE PER OGNI SINGOLO IMU E TARATURA PER OGNUNO CON MESSAGGIO DI AVVENUTA CALIBRAZIONE


// FASE LOOP
// FASE 1: LETTURA DATI
// FASE 2: INVIO DATI IN RETE


#include <Wire.h>
#include <SPI.h>
#include <WiFiNINA.h>
#include <WiFiUdp.h>
#include "arduino_secrets.h"
#include "Wire.h"
#include "I2Cdev.h"
#include "MPU6050.h"

//------------------------------------------------------ CONFIGURATION CALIBRATION --------------------------------------------------------------------------------------

//Change this 3 variables if you want to fine tune the skecth to your needs.
int buffersize=1000;     //Amount of readings used to average, make it higher to get more precision but sketch will be slower  (default:1000)
int acel_deadzone=8;     //Acelerometer error allowed, make it lower to get more precision, but sketch may not converge  (default:8)
int giro_deadzone=1;     //Giro error allowed, make it lower to get more precision, but sketch may not converge  (default:1)


int16_t ax, ay, az,gx, gy, gz;

int mean_ax,mean_ay,mean_az,mean_gx,mean_gy,mean_gz,state=0;
int ax_offset,ay_offset,az_offset,gx_offset,gy_offset,gz_offset;

MPU6050 accelgyro(0x68); 


//----------------------------------------------------------- IMU CONFIGURATION ---------------------------------------------------------------------------------

int numImu = 4;

const int8_t MPU_I2C_ADDR = 0x68;

const int8_t XACC_OFFS_USRH = 0x06;   // Accelerometer Offset Cancellation
const int8_t XGY_OFFS_USRH  = 0x13;   // Gyroscope Offset Cancellation
const int8_t ACCEL_CONFIG   = 0x1C;   // Accelerometer Configuration
const int8_t GYRO_CONFIG    = 0x1B;   // Gyroscope Configuration
const int8_t ACCEL_XOUT_H   = 0x3B;   // Accelerometer Measurements
const int8_t PWR_MGMT_1     = 0x6B;   // Power Management 1 register address

// ACCELEROMETER FULL SCALE MODES 
const int8_t AFS_SEL_2G   = 0x00;
const int8_t AFS_SEL_4G   = 0x08;
const int8_t AFS_SEL_8G   = 0x10;
const int8_t AFS_SEL_16G  = 0x18;

// GYROSCOPE CONFIGURATION 
const int8_t MPU6050_SCALE_2000DPS   = 0x11;
const int8_t MPU6050_SCALE_1000DPS   = 0x10;
const int8_t MPU6050_SCALE_500DPS    = 0x01;
const int8_t MPU6050_SCALE_250DPS    = 0x00;

// FASE SETTAGGIO CLOCK 

// FASE SETTAGGIO FIFO 


//SELECT ACCELEROMETER FULL SCALE FOR ALL IMUs
int8_t afs_sel = AFS_SEL_2G; 

// SELECT GYROSCOPE SCALE RANGE
int8_t afs_sel_gy = MPU6050_SCALE_2000DPS; 

// NUMBER OF DETECTED IMUs
int nDevices=0;

//CONVERSION FACTOR
float to_g_force;

// CONFIGURATION PIN
int pin[12];




//---------------------------------------------------------- NETWORK CONFIGURATION ------------------------------------------------------------------------------------

//NETWORK DATA
IPAddress ip(192,168,43,95);
int status = WL_IDLE_STATUS; 
char ssid[] = SECRET_SSID;          // your network SSID (name)
char pass[] = SECRET_PASS;          // your network password (use for WPA, or use as key for WEP)
unsigned int localPort = 5001;   
WiFiUDP Udp;

//---------------------------------------------- FASE SETUP ------------------------------------------------------------------------------------

void setup() {
    
    // FASE 1
    NetworkSetting();

    pin[0]=0;
    pin[1]=1;
    pin[2]=2;
    pin[3]=3;
    pin[4]=4;
    pin[5]=5;
    pin[6]=15;
    pin[7]=16;
    pin[8]=17;
    pin[9]=18;
    pin[10]=19;
    pin[11]=20;
    
    // FASE 2
    WireSetting();
    
    String data = "START!";
    int length = data.indexOf("!") +2;
    char data_final[length+1];
    data.toCharArray(data_final, length+1); 
  
    Udp.beginPacket(ip,localPort);
    Udp.write(data_final);
    Udp.endPacket();  

}

//----------------------------------------------- FASE LOOP ----------------------------------------------------------------------------------------

void loop(){
  
  // LETTURA DATI SINGOLI IMU E INVIO IN RETE TRAMITE UDP
  ManageData();  

}

//----------------------------------------------- NETWORK SETTING -------------------------------------------------------------------------------

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

//------------------------------------------------------- WIRE SETTING ----------------------------------------------------------------------------------------

void WireSetting(){  
       
    Wire.begin(); 
    Serial.begin(9600);
    Serial.println("\nI2C Scanner and Calibration");

    // Configures the specified pin to behave as output
    for (int i= 0;i<numImu;i++){ 
      pinMode(pin[i], OUTPUT);
    }

    changeAddress(pin[numImu],0);
    ImuSetting();
    
    for (int i=0;i<numImu;i++){ 
      changeAddress(pin[i],pin[i+1]);
      ImuSetting();
    }       

    delay(2000);

    // DEFINITION OF THE CONVERSION FACTOR TO G VALUES
    to_g_force = 1./ (16384);
}

void ImuSetting(){

      String data;  
      int flag = 0;

      verifyConnection(&flag);

      if(flag==0) {

        // calibrate IMU
        calibration();
        
        data = "IMU numero " + String(nDevices+1) + " DETECTED AND CALIBRATED!";        
        int length = data.indexOf("!") +2;
        char data_final[length+1];
        data.toCharArray(data_final, length+1); 

        // Send message to the client
        Udp.beginPacket(ip,localPort);
        Udp.write(data_final);
        Udp.endPacket();
      }
      else{

        Serial.println("\nProblem with IMU");
        Serial.print(nDevices+1); 
        data = "PROBLEM WITH IMU numero " + String(nDevices+1)+ "!";  
        delay(100);
        int length = data.indexOf("!") +2;
        char data_final[length+1];
        data.toCharArray(data_final, length+1); 
        // Send message to the client
        Udp.beginPacket(ip,localPort);
        Udp.write(data_final);
        Udp.endPacket();  
      }
 }
//--------------------------------------------------- VERIFICA DELLA CONNESSIONE CON GLI IMU -------------------------------------------------------
  
void verifyConnection(int *flag){     

    byte error, address;

    Serial.println("Scanning..."); 
    
    for(address = 1; address < 127; address++ ) 
    {
      Wire.beginTransmission(address);
      error = Wire.endTransmission();
 
      if (error == 0)
      {      
        if (address<16) 
          Serial.print("0");

        if(address==104){
                     
           // WAKE UP THE MPU-6050
           Wire.beginTransmission(MPU_I2C_ADDR);
           Wire.write(PWR_MGMT_1);
           Wire.write(0);
           Wire.endTransmission();        

          // SET ACCELEROMETER FULL SCALE
          Wire.beginTransmission(MPU_I2C_ADDR);
          Wire.write(ACCEL_CONFIG);
          Wire.write(afs_sel);
          Wire.endTransmission();

          Wire.beginTransmission(MPU_I2C_ADDR);
          Wire.write(GYRO_CONFIG);
          Wire.write(afs_sel_gy);
          Wire.endTransmission();
          
          Serial.print("I2C device found at address 0x");
          Serial.print(address,HEX);
          Serial.println("  !");       
          nDevices++;
          *flag=0;
          }       
        
      }
      else if (error==4) 
      {
        Serial.print("Unknow error at address 0x");
          if (address<16) 
            Serial.print("0");
        Serial.println(address,HEX);
        *flag=1;  
      }    
  }
  
  if (nDevices == 0){
    Serial.println("No I2C devices found\n");
    *flag=2;  
    }
  else{
    Serial.println("done\n");  
    *flag=3;
  }
}

//---------------------------------------------------------- CALIBRAZIONE ----------------------------------------------------------

void calibration(){

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
    meansensors();
    state++;
    delay(1000);
  }
  
  if (state==1) {
    Serial.println("\nCalculating offsets...");
    calibration_gyro();
    state++;
    delay(1000);
  }

  if (state==2) {
    meansensors();
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

  
  
}

// -------------------------------------------------------CALCOLO VALORE MEDIO --------------------------------------------------------


void meansensors(){
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

void calibration_gyro(){
  
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
    
    meansensors();
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

//---------------------------------------------- FUNZIONE PER SETTARE GLI OFFSET -----------------------------------------------------------

void setOffset(int16_t offsetAcc_x,int16_t offsetAcc_y,int16_t offsetAcc_z,int16_t offsetGy_x,int16_t offsetGy_y,int16_t offsetGy_z){
  
  Wire.beginTransmission(MPU_I2C_ADDR);
  Wire.write(XACC_OFFS_USRH);

  uint8_t offsetsAcc[6];
  offsetsAcc[0] = static_cast<uint8_t>(offsetAcc_x >> 8);
  offsetsAcc[1] = static_cast<uint8_t>(offsetAcc_x & 0x00ff);
  offsetsAcc[2] = static_cast<uint8_t>(offsetAcc_y >> 8);
  offsetsAcc[3] = static_cast<uint8_t>(offsetAcc_y & 0x00ff);
  offsetsAcc[4] = static_cast<uint8_t>(offsetAcc_z >> 8);
  offsetsAcc[5] = static_cast<uint8_t>(offsetAcc_z & 0x00ff);  

  Wire.write(offsetsAcc, 6);
  Wire.endTransmission();

  Wire.beginTransmission(MPU_I2C_ADDR);
  Wire.write(XGY_OFFS_USRH);

  uint8_t offsetsGy[6];
  offsetsGy[0] = static_cast<uint8_t>(offsetGy_x >> 8);
  offsetsGy[1] = static_cast<uint8_t>(offsetGy_x & 0x00ff);
  offsetsGy[2] = static_cast<uint8_t>(offsetGy_y >> 8);
  offsetsGy[3] = static_cast<uint8_t>(offsetGy_y & 0x00ff);
  offsetsGy[4] = static_cast<uint8_t>(offsetGy_z >> 8);
  offsetsGy[5] = static_cast<uint8_t>(offsetGy_z & 0x00ff);  

  Wire.write(offsetsGy, 6);
  Wire.endTransmission();

}

//---------------------------------------------- CAMBIO DA HIGH A LOW E VICEVERSA ------------------------------------------------------------- 

void changeAddress(int low,int high){
  
  Wire.beginTransmission(0x68);
  Wire.write(0x3B);
  Wire.endTransmission(false);
  
  digitalWrite(low, HIGH);
  digitalWrite(high, LOW);

  delay(100);
}


//------------------------------ FASE LETTURA E INVIO DATI -----------------------------------------------------------------------------

void ManageData(){

    int16_t id,Ax,Ay,Az,Gx,Gy,Gz;

    Wire.beginTransmission(MPU_I2C_ADDR);
    Wire.write(ACCEL_XOUT_H);
    Wire.endTransmission();
    
    changeAddress(pin[numImu],0); 
    // READ DATA FROM IMU 1
    readData(&Ax,&Ay,&Az,&Gx,&Gy,&Gz);
    // SEND DATA FROM IMU 1
    id = 1;   
    
    sendData(id,Ax,Ay,Az,Gx,Gy,Gz);
     
    for (int i=0;i<numImu;i++){ 
            
      Wire.beginTransmission(MPU_I2C_ADDR);
      Wire.write(ACCEL_XOUT_H);
      Wire.endTransmission();

      changeAddress(pin[i],pin[i+1]); 
      // READ DATA FROM IMU 2
      readData(&Ax,&Ay,&Az,&Gx,&Gy,&Gz);
      // SEND DATA FROM IMU 2
      id = i+1;
      sendData(id,Ax,Ay,Az,Gx,Gy,Gz); 
    
    } 
    
}

//-------------------------------------------------- LETTURA DATI --------------------------------------------------------------------------

void readData(int16_t *Ax,int16_t *Ay,int16_t *Az,int16_t *Gx,int16_t *Gy,int16_t *Gz){
  
  Wire.requestFrom(0x68, 14, true);
  *Ax=Wire.read()<<8|Wire.read();    
  *Ay=Wire.read()<<8|Wire.read(); 
  *Az=Wire.read()<<8|Wire.read();
   int Tmp=Wire.read()<<8|Wire.read(); 
  *Gx=Wire.read()<<8|Wire.read(); 
  *Gy=Wire.read()<<8|Wire.read();
  *Gz=Wire.read()<<8|Wire.read();
  
}

// ---------------------------------------------- INVIO DATI -----------------------------------------------------------------------------------------

void sendData(int id,int Ax,int Ay,int Az,int Gx,int Gy,int Gz){

  float Ax_g = Ax * to_g_force;
  float Ay_g = Ay * to_g_force;
  float Az_g = Az * to_g_force;
  
  String data = "A" + String(Ax_g) + "B"+ String(Ay_g) + "C" + String(Az_g) + "D" + String(Gx) + "E" + String(Gy) + "F" + String(Gz) +"G"+ String(id)+"H";
  int length = data.indexOf("G") +2;
  char data_final[length+1];
  data.toCharArray(data_final, length+1); 
  
  Udp.beginPacket(ip,localPort);
  Udp.write(data_final);
  Udp.endPacket();  
}
