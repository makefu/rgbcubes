#include <FastLED.h>
#include <FastFader.h>

#define CLOCK_PIN 3
#define DATA_PIN 2
// RCSwitch pin is at 3
#define NUM_LEDS 100



#define STARTCOLOR 0xFFFFFF
#define BLACK      0x000000

#define SHOWDELAY  2000       // initial delay
//#define BAUDRATE   460800
#define BAUDRATE   115200    // Serial port speed, 460800 tested with Arduino Uno R3


const char prefix[] = {'B', 'U', 'T','T'}; // Start prefix
char buffer[sizeof(prefix)]; // Temp buffer for receiving prefix data


int px[3];
FastFader pixel_fader;

int state;                   // Define current state
#define STATE_WAITING   1    // - Waiting for prefix
#define STATE_DO_PREFIX 2    // - Processing prefix
#define STATE_DO_CMD 3    // - Processing command
#define STATE_DO_DATA   4    // - Handling incoming LED colors

int readSerial;
int currentLED;           // Needed for assigning the color to the right LED

const int init_num_leds = 100;
int num_leds = init_num_leds;

CRGB leds[init_num_leds];
CRGB color;
int pixel_buffer[init_num_leds][3];

int brightness = 100;
unsigned int trans_speed= 1000;
unsigned int trans_steps= trans_speed/2;

// Sets the color of all LEDs in the strand to 'color'
// If 'wait'>0 then it will show a swipe from start to end
void setAllLEDs(CRGB c, int wait)
{
  px[0] = c.r;
  px[1] = c.g;
  px[2] = c.b;
  for ( int Counter = 0; Counter < NUM_LEDS; Counter++ )    // For each LED
  {
    pixel_fader.set_pixel(Counter,px);
    pixel_fader.push(wait,wait/2);
  } // for Counter

} // setAllLEDs

void setup()
{
  //FastLED.addLeds<WS2812B, DATA_PIN, RGB>(leds, num_leds);
  FastLED.addLeds<WS2801, DATA_PIN,CLOCK_PIN, RGB>(leds, num_leds);
  FastLED.setBrightness( brightness );
  pixel_fader.bind(pixel_buffer, leds, num_leds, FastLED);
  Serial.begin(BAUDRATE);   // Init serial speed
  setAllLEDs(CRGB::Black, 0);
  setAllLEDs(CRGB::White, 400);
  Serial.println("Finish Init");

  state = STATE_WAITING;    // Initial state: Waiting for prefix
}


void loop()
{
  switch (state)
  {
    case STATE_WAITING:                  // *** Waiting for prefix ***

      if ( Serial.available() > 0 )
      {
        Serial.println("waiting");

        if ( Serial.read() == prefix[0] )   // if this character is 1st prefix char
        {
          state = STATE_DO_PREFIX;  // then set state to handle prefix
        }
      }
      break;


    case STATE_DO_PREFIX:                // *** Processing Prefix ***

      if ( Serial.available() > sizeof(prefix) - 2 )
      {
        Serial.readBytes(buffer, sizeof(prefix) - 1);

        for ( int Counter = 0; Counter < sizeof(prefix) - 1; Counter++)
        {
          if ( buffer[Counter] == prefix[Counter + 1] )
          {
            Serial.println("Finished Prefix");
            state = STATE_DO_CMD;     // Received character is in prefix, continue
            currentLED = 0;            // Set current LED to the first one
          }
          else
          {
            state = STATE_WAITING;
            break;
          }
        }
      }
      break;

    case STATE_DO_CMD:                   // *** process what cmd to do
      if (Serial.available() > 0){
        switch (Serial.read()){
          case 'S':                      // (S)et LEDS
            state = STATE_DO_DATA; 
            break;
          case 'T':                     // (T)ransition Speed
            Serial.print("Set transition speed ");
            while (Serial.available() < 2){ }
            // read 16 bits
            trans_speed = ((Serial.read()<< 8) + Serial.read()) ;
            Serial.print(trans_speed);
            if (trans_speed){
              trans_steps = trans_speed/2;
            }
            else{
              trans_steps = 0;
            }
            Serial.print(" ");
            state = STATE_WAITING;
            Serial.println(trans_steps);
            break;
          case 'N':                     // (N)um LEDs
            Serial.print("Set num leds ");
            while (Serial.available() < 1){ }
            num_leds = Serial.read();
            Serial.println(num_leds,HEX);
            FastLED.addLeds<WS2812B, DATA_PIN, RGB>(leds, num_leds);
            pixel_fader.bind(pixel_buffer, leds, num_leds, FastLED);
            state = STATE_WAITING;
            break;
          case 'I':                     // set Br(I)ghtness - 0-255
            Serial.print("Set Brightness ");
            while (Serial.available() < 1){ }
            brightness = Serial.read();
            Serial.println(brightness,HEX);
            FastLED.setBrightness( brightness );
            FastLED.show();
            state = STATE_WAITING;
            break;
          case 'A':                     // set (A)ll LEDs
            Serial.println("set All LEDs");
            while (Serial.available() < 3){
            }
            color.r = Serial.read();
            color.g = Serial.read();
            color.b = Serial.read();
            Serial.print(color.r,HEX);
            Serial.print(color.g,HEX);
            Serial.println(color.b,HEX);

            setAllLEDs(color,trans_speed);
            state = STATE_WAITING;
            break;
        }
        
      }

    case STATE_DO_DATA:                  // *** Process incoming color data ***
      if ( Serial.available() > 2 )      // if we receive more than 2 chars
      {
        px[0] = Serial.read();
        px[1] = Serial.read();
        px[2] = Serial.read();
//        Serial.println(px[0]);
//        Serial.println(px[1]);
//        Serial.println(px[2]);
        pixel_fader.set_pixel(currentLED,px);
        currentLED++;
      }

      if ( currentLED >= num_leds )       // Reached the last LED? Display it!
      {
        pixel_fader.push(trans_speed,trans_steps);
        state = STATE_WAITING;
        currentLED = 0;
        break;
      }
      break;
  } // switch(state)
} // loop



