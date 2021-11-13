--
--  Copyright (C) 2021 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Picosystem.Pins;
with HAL; use HAL;
with RP.GPIO;

package Picosystem.LED is

   subtype Brightness is UInt16;
   subtype RGB888 is UInt24;

   procedure Initialize;

   procedure Set_Backlight
      (Level : Brightness);

   procedure Set_Color
      (R, G, B : Brightness);

   procedure Set_Color
      (Color : RGB888);

private

   type Lights is (Backlight, Red, Green, Blue);

   PWM_Frequency : constant Hertz := 1_000;

   Pins : array (Lights) of RP.GPIO.GPIO_Point :=
      (Backlight => Picosystem.Pins.BACKLIGHT,
       Red       => Picosystem.Pins.LED_R,
       Green     => Picosystem.Pins.LED_G,
       Blue      => Picosystem.Pins.LED_B);

   procedure Set
      (Light : Lights;
       Level : Brightness);

   --  Gamma correction the fast way
   --  Loosely based on dim8_raw/scale8
   --  https://github.com/FastLED/FastLED/blob/master/src/lib8tion/scale8.h
   function Dim
      (I : UInt16)
      return UInt16;

end Picosystem.LED;
