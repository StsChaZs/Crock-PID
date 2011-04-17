//LCD-Interface: SparkSoftLCD library for the Arduino by C. A. Church http://openmoco.org/  
#include "SparkSoftLCD.h"
#define LCD_TX 12 // LCD transmit pin
SparkSoftLCD lcd = SparkSoftLCD(LCD_TX);

//RTC-Interface:
#include <Time.h> 
#include <Wire.h>
#include <DS1307RTC.h>  // a basic DS1307 library that returns time as a time_t
time_t time;
bool timer =1;
time_t alarmtime;

//Temperature Control:
volatile float TemperatureSP = 25.2; 
volatile float TemperatureIS = 25.4; 

void setup(void) 
{
 //Start serial communication
 //Serial.begin(9600);
 
 //Setup Lcd
 pinMode(LCD_TX, OUTPUT);
 lcd.begin(9600);
 lcd.clear();
 lcd.cursor(0); // hidden cursor

 welcome();  //Display Welcome message
 
 //Setup RTC
  setSyncProvider(RTC.get);   // the function to get the time from the RTC
  if(timeStatus()!= timeSet) 
     lcd.print("Unable to sync RTC");
  else
     lcd.print("RTC in sync");      
    delay(1000);
    
    //Set Timer for tests
    now = RTC.now();
	
  }

 

  }
  
  void loop(void) {
time = now();  
statusDisplay();
delay(1000);

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

