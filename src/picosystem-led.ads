with Ada.Unchecked_Conversion;
with HAL; use HAL;
with RP; use RP;

package Picosystem.LED is

   type Lights is (Backlight, Red, Green, Blue);

   Step : constant := 1.0 / (2.0 ** 16 - 1.0);
   type Brightness is delta Step range 0.0 .. 1.0
      with Small => Step,
           Size  => 16;

   procedure Initialize;

   procedure Set
      (Light : Lights;
       Level : Brightness);

private

   PWM_Frequency : constant Hertz := 1_000;

   Pins : array (Lights) of GPIO_Point :=
      (Backlight => Picosystem.BACKLIGHT,
       Red       => LED_R,
       Green     => LED_G,
       Blue      => LED_B);

   --  Gamma correction the fast way
   --  Loosely based on dim8_raw/scale8
   --  https://github.com/FastLED/FastLED/blob/master/src/lib8tion/scale8.h
   function Dim
      (I : UInt16)
      return UInt16;

   function To_UInt16 is new Ada.Unchecked_Conversion
      (Source => Brightness,
       Target => UInt16);

end Picosystem.LED;
