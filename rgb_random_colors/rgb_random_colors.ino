
#include <FastLED.h>
#include <FastFader.h>

#define DATA_PIN 3
// RCSwitch pin is at 3
#define NUM_LEDS 4



#define STARTCOLOR {255,255,255}  // LED colors at start
#define BLACK      {0,0,0}  // LED color BLACK

#define SHOWDELAY  5000       // Delay in micro seconds before showing
//#define BAUDRATE   460800    // Serial port speed, 460800 tested with Arduino Uno R3
#define BAUDRATE   115200    // Serial port speed, 460800 tested with Arduino Uno R3

#define BRIGHTNESS 100        // Max. brightness in %



CRGB leds[NUM_LEDS];

int pixel_buffer[NUM_LEDS][3];
int px[3] = {};
FastFader pixel_fader;


int currentLED;           // Needed for assigning the color to the right LED



void setup()
{
  FastLED.addLeds<WS2812B, DATA_PIN, RGB>(leds, NUM_LEDS);
  FastLED.setBrightness((255 / 100) * BRIGHTNESS );
  pixel_fader.bind(pixel_buffer, leds, NUM_LEDS, FastLED);
  px[0] = 0;
  px[1] = 0;
  px[2] = 0;

  //fadeWait(px, 0);
  px[0] = 255;
  px[1] = 255;
  px[2] = 255;
  //fadeWait(px, 500);

  Serial.begin(BAUDRATE);   // Init serial speed

}


void loop()
{     
  //fadeRandom(0);
  fade(255,0,0);
    fade(0,255,0);
    fade(0,0,255);

  //FastLED.delay(1000);

} // loop

void fade(int r,int g,int b)
{
    px[0] = r;
    px[1] = g;
    px[2] = b;
  for ( int Counter = 0; Counter < NUM_LEDS; Counter++ )    // For each LED
  {
    pixel_fader.set_pixel(Counter,px);

  } // for Counter
  pixel_fader.push(SHOWDELAY,SHOWDELAY/2);

} // setAllLEDs


void fadeRandom(int wait)
{
    px[0] = random(0,255);
    px[1] = random(0,255);
    px[2] = random(0,255);
  for ( int Counter = 0; Counter < NUM_LEDS; Counter++ )    // For each LED
  {


    pixel_fader.set_pixel(Counter,px);

  } // for Counter
  pixel_fader.push(SHOWDELAY,SHOWDELAY/2);

  // pixel_fader.push(1000,500);

} // setAllLEDs

