--
--  Copyright (C) 2021 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with RP.PWM; use RP.PWM;

package body Picosystem.LED is

   procedure Initialize is
      P : PWM_Point;
   begin
      if not RP.PWM.Initialized then
         RP.PWM.Initialize;
      end if;

      for I in Lights'Range loop
         Pins (I).Configure (RP.GPIO.Output, RP.GPIO.Floating, RP.GPIO.PWM);
         P := To_PWM (Pins (I));
         Set_Mode (P.Slice, Free_Running);
         Set_Frequency (P.Slice, Hertz (Period'Last) * PWM_Frequency);
         Set_Interval (P.Slice, Period'Last);
         Set_Duty_Cycle (P.Slice, P.Channel, 0);
         Enable (P.Slice);
      end loop;
   end Initialize;

   function Dim
      (I : UInt16)
       return UInt16
   is
      J : UInt32 := UInt32 (I);
   begin
      J := J * J;
      J := Shift_Right (J, 16);
      return UInt16 (J);
   end Dim;

   procedure Set
      (Light : Lights;
       Level : Brightness)
   is
      P    : constant PWM_Point := To_PWM (Pins (Light));
      Duty : constant Period := Dim (Level);
   begin
      Set_Duty_Cycle (P.Slice, P.Channel, Duty);
   end Set;

   procedure Set_Backlight
      (Level : Brightness)
   is
   begin
      Set (Backlight, Level);
   end Set_Backlight;

   procedure Set_Color
      (R, G, B : Brightness)
   is
   begin
      Set (Red, R);
      Set (Green, G);
      Set (Blue, B);
   end Set_Color;

   procedure Set_Color
      (Color : RGB888)
   is
      C : constant UInt32 := UInt32 (Color);
   begin
      Set (Red, Brightness (Shift_Right (C, 16)) * 256);
      Set (Green, Brightness (Shift_Right (C, 8) and 16#FF#) * 256);
      Set (Blue, Brightness (C and 16#FF#) * 256);
   end Set_Color;
end Picosystem.LED;
