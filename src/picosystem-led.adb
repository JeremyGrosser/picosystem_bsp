--
--  Copyright (C) 2021 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with RP.PWM; use RP.PWM;
with Interfaces;

package body Picosystem.LED is

   procedure Initialize is
      P : PWM_Point;
   begin
      if not RP.PWM.Initialized then
         RP.PWM.Initialize;
      end if;

      for I in Lights'Range loop
         Pins (I).Configure (RP.GPIO.Output, RP.GPIO.Pull_Up, RP.GPIO.PWM);
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
      use Interfaces;
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
      Duty : constant Period := Dim (To_UInt16 (Level));
   begin
      Set_Duty_Cycle (P.Slice, P.Channel, Duty);
   end Set;

end Picosystem.LED;
