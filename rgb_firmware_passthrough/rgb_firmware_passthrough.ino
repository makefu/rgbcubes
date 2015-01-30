
#include <FastLED.h>
#include <FastFader.h>

#define DATA_PIN 3
// RCSwitch pin is at 3
#define NUM_LEDS 1



#define STARTCOLOR 0xFFFFFF  // LED colors at start
#define BLACK      0x000000  // LED color BLACK

#define SHOWDELAY  2000       // Delay in micro seconds before showing
//#define BAUDRATE   460800    // Serial port speed, 460800 tested with Arduino Uno R3
#define BAUDRATE   115200    // Serial port speed, 460800 tested with Arduino Uno R3

#define BRIGHTNESS 100        // Max. brightness in %

const char prefix[] = {'B', 'U', 'T', 'T'}; // Start prefix
char buffer[sizeof(prefix)]; // Temp buffer for receiving prefix data


CRGB leds[NUM_LEDS];

int pixel_buffer[NUM_LEDS][3];
int px[3];
FastFader pixel_fader;

int state;                   // Define current state
#define STATE_WAITING   1    // - Waiting for prefix
#define STATE_DO_PREFIX 2    // - Processing prefix
#define STATE_DO_DATA   3    // - Handling incoming LED colors

int readSerial;           // Read Serial data (1)
int currentLED;           // Needed for assigning the color to the right LED



void setup()
{
  Serial.println("Dickbutt");

  FastLED.addLeds<WS2812B, DATA_PIN, RGB>(leds, NUM_LEDS);
  FastLED.setBrightness((255 / 100) * BRIGHTNESS );
  pixel_fader.bind(pixel_buffer, leds, NUM_LEDS, FastLED);
  setAllLEDs(BLACK, 0);
  setAllLEDs(STARTCOLOR, 500);

  Serial.begin(BAUDRATE);   // Init serial speed

  state = STATE_WAITING;    // Initial state: Waiting for prefix
}


void loop()
{
  switch (state)
  {
    case STATE_WAITING:                  // *** Waiting for prefix ***

      if ( Serial.available() > 0 )
      {

        if ( Serial.read() == prefix[0] )   // if this character is 1st prefix char
        {
          state = STATE_DO_PREFIX;  // then set state to handle prefix
        }
      }
      break;


    case STATE_DO_PREFIX:                // *** Processing Prefix ***
      Serial.println("State DO PREFIX");

      if ( Serial.available() > sizeof(prefix) - 2 )
      {
        Serial.readBytes(buffer, sizeof(prefix) - 1);

        for ( int Counter = 0; Counter < sizeof(prefix) - 1; Counter++)
        {
          if ( buffer[Counter] == prefix[Counter + 1] )
          {
            state = STATE_DO_DATA;     // Received character is in prefix, continue
            currentLED = 0;            // Set current LED to the first one
          }
          else
          {
            state = STATE_WAITING;     // Crap, one of the received chars is NOT in the prefix
            break;                     // Exit, to go back to waiting for the prefix
          } // end if buffer
        } // end for Counter
      } // end if Serial
      break;


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
        //FastLED.show();
        currentLED++;
      }

      if ( currentLED >= NUM_LEDS )       // Reached the last LED? Display it!
      {
        pixel_fader.push(1000,500);

        //FastLED.delay(SHOWDELAY);      // Wait a few micro seconds
        //FastLED.show();

        state = STATE_WAITING;         // Reset to waiting ...
        currentLED = 0;                // and go to LED one

        break;                         // and exit ... and do it all over again
      }
      break;
  } // switch(state)

} // loop


// Sets the color of all LEDs in the strand to 'color'
// If 'wait'>0 then it will show a swipe from start to end
void setAllLEDs(uint32_t color, int wait)
{
  for ( int Counter = 0; Counter < NUM_LEDS; Counter++ )    // For each LED
  {
    leds[Counter] = color;

    if ( wait > 0 )                       // if a wait time was set then
    {
      FastLED.show();
      FastLED.delay(wait);                      // and wait before we do the next LED
    } // if wait

  } // for Counter

} // setAllLEDs

