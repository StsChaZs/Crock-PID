#define ULONG_MAX 4294967295

//LCD-Interface: SparkSoftLCD library for the Arduino by C. A. Church http://openmoco.org/  
#include "SparkSoftLCD.h"
#define LCD_TX 12 // LCD transmit pin
SparkSoftLCD lcd = SparkSoftLCD(LCD_TX);

#define PIN_STATUS 13 // Status LED

//RTC-Interface:
#include <Time.h> 
#include <Wire.h>
#include <DS1307RTC.h>  // a basic DS1307 library that returns time as a time_t
time_t time;
bool timer =1;
time_t alarmtime;

//Temperature Control:
#include <OneWire.h>
OneWire ds(11);                  //OneWire temperature interface
#define OneWireDelay 750        //Minimum parasite power time required to
//read a valid temperature (ms)
#define OneWireNextRead 5000   //Frequency to measure temperature (ms)
//volatile float TemperatureCurrent = -1;  //Current temperature measurement (°C)
byte addr[8];        //Address of the temperature sensor
int BadTempCount = 0;            //Counter of the number of consecutive bad temperature reads
#define TEMP_BAD_LIMIT 10       //Number of bad temperatures before switching to OFF
volatile float TemperatureSP = 25.2; 
volatile float TemperatureIS = 25.4; 

volatile unsigned long TemperatureAvailable = ULONG_MAX;  //When the temperature reading will
//be available from parasite power (ms)
volatile unsigned long TemperatureNextRead = ULONG_MAX;   //Next time to read the temperature (ms)


void setup(void) 
{
  //Start serial communication
  //Serial.begin(9600);

  //Setup Lcd
  pinMode(LCD_TX, OUTPUT);
  lcd.begin(9600);
  lcd.clear();
  lcd.cursor(0); // hidden cursor

  //welcome();  //Display Welcome message

  //Setup RTC
  setSyncProvider(RTC.get);   // the function to get the time from the RTC
  lcd.clear();
  if(timeStatus()!= timeSet) 
    lcd.print("Unable to sync RTC");
  else
    lcd.print("RTC in sync");      
  delay(2000);
  lcd.clear();
  //Setup Temperature
  bool OneWireTest = OneWireSearch(); //Locate the temperature sensor
  if (OneWireTest=true)  
    lcd.print("DS18S20 found");
  else
    lcd.print("DS18S20 NOT found");
  delay(2000);
}


void loop(void) {
  time = now();  
  statusDisplay();
  //If it's time for another temperature read, start it
  if(true)
    OneWireStartRead();


  //Check if a temperature is available to read
  if(true)
  {
    delay(1000);
    //lcd.clear();
    //lcd.cursorTo(1,1);
    //lcd.print("Reading Temp");
    //Read the value off the bus
    float Value = OneWireFinishRead();
    TemperatureIS = Value;
    //lcd.clear();
    //lcd.cursorTo(2,1);
    //printFloatLCD(Value,1);
    //delay(1000);
    //If there wasn't a read error, use that as the new temperature
    /*
    if(Value!= -1 && Value < 100 && Value > 0)    //261.3 is an invalid read, as is 30.9
    {
      TemperatureIS = Value;

      //Reset the bad counter
      BadTempCount = 0;
    lcd.cursorTo(2,1);
    printFloatLCD(Value,1);
    lcd.print(" No Error");
    }
    else
    {
      //Count the number of times a bad temperature is read
      BadTempCount++;
      lcd.cursorTo(2,1);
      printFloatLCD(Value,1);
      lcd.print(" Error");
      */
      /*
      //When a reasonable limit has been passed, switch to off, this
       //prevents bad things from happening due to a short
       if(BadTempCount > TEMP_BAD_LIMIT)
       {
       _Mode = MODE_OFF;
       digitalWrite(PIN_POWER, LOW);
       _Output = 0;
       }
       	  
    }*/
  //delay(1000);
  }
}
void welcome() {
  lcd.clear();
  lcd.cursorTo(1,1);
  lcd.print("Welcome to");
  lcd.cursorTo(2,1);
  lcd.print("CROCK-PID");
  delay(1000);
  lcd.clear();
  lcd.cursorTo(1,1);
  lcd.print("Select your language:");
  lcd.cursorTo(2,1);
  lcd.print("1 English 2 Deutsch");
  lcd.cursorTo(2,1);
  delay(1000);
}

void statusDisplay() {
  lcd.clear();
  lcd.cursorTo(1,1);
  lcd.print("Tc=");
  printFloatLCD(TemperatureIS,1);
  lcd.cursorTo(1,12);
  if (hour(time)<10) {
    lcd.print("0");
  }
  lcd.print(hour(time), DEC);
  lcd.print(":");
  if (minute(time)<10) {
    lcd.print("0");
  }
  lcd.print(minute(time), DEC);
  lcd.cursorTo(2,1);
  lcd.print("Ts="); 
  printFloatLCD(TemperatureSP,1);

  //lcd.cursorTo(2,8);
  //lcd.print(TemperatureNextRead-millis());
  /*
  if (countdown = 1) {
   if (countdown_days*24+countdown_hours > 100) {
   lcd.cursorTo(2,11);
   }
   else{
   lcd.cursorTo(2,12);
   if (countdown_days*24+countdown_hours < 10) {
   lcd.print("0");
   }
   }
   lcd.print(countdown_days*24+countdown_hours,DEC);
   lcd.print(":");
   if (countdown_minutes < 10) {
   lcd.print("0");
   }
   lcd.print(countdown_minutes,DEC);
   }
   */
}




