with RP.Device;
with RP.SPI;
with ST7789;

package body Picosystem.Screen is

   LCD : ST7789.ST7789_Screen
      (CS   => LCD_CS'Access,
       DC   => LCD_DC'Access,
       RST  => LCD_RESET'Access,
       Port => LCD_SPI'Access,
       Time => RP.Device.Timer'Access);

   procedure Initialize is
      SPI_Config : constant RP.SPI.SPI_Configuration :=
         (Baud     => 8_000_000,
          Blocking => True,
          others   => <>);
   begin
      if not RP.Device.Timer.Enabled then
         RP.Device.Timer.Enable;
      end if;

      --  Hold reset while we get everything configured
      LCD_RESET.Configure (Output);
      LCD_RESET.Clear;

      LCD_CS.Configure (Output);
      LCD_DC.Configure (Output);
      LCD_VSYNC.Configure (Input);
      LCD_SCLK.Configure (Output, Floating, RP.GPIO.SPI);
      LCD_MOSI.Configure (Output, Floating, RP.GPIO.SPI);
      LCD_SPI.Configure (SPI_Config);

      LCD.Initialize;
   end Initialize;

   procedure Wait_VSync is
   begin
      --  If already in vsync, wait for it to end
      while LCD_VSYNC.Get loop
         null;
      end loop;

      --  Now wait for the next vsync
      while not LCD_VSYNC.Get loop
         null;
      end loop;
   end Wait_VSync;

end Picosystem.Screen;
