with RP.PWM; use RP.PWM;

package body Picosystem.LED is

   Pins : array (Lights) of GPIO_Point :=
      (Backlight => Picosystem.BACKLIGHT,
       Red       => LED_R,
       Green     => LED_G,
       Blue      => LED_B);

   procedure Initialize is
      P : PWM_Point;
   begin
      if not RP.PWM.Initialized then
         RP.PWM.Initialize;
      end if;

      for I in Lights'Range loop
         Pins (I).Configure (Output, Pull_Up, RP.GPIO.PWM);
         P := To_PWM (Pins (I));
         Set_Mode (P.Slice, Free_Running);
         --  Use the max divider to reduce power consumption
         Set_Divider (P.Slice, RP.PWM.Divider'Last);
         --  Roughly 1 KHz output
         Set_Interval (P.Slice, 488);
         Set_Duty_Cycle (P.Slice, P.Channel, 0);
         Enable (P.Slice);
      end loop;
   end Initialize;

   procedure Set
      (Light : Lights;
       Level : Brightness)
   is
      P : constant PWM_Point := To_PWM (Pins (Light));
   begin
      Set_Duty_Cycle (P.Slice, P.Channel, Period (Level));
   end Set;

end Picosystem.LED;
