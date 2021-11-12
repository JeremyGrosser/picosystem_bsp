--
--  Copyright (C) 2021 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Picosystem.Pins; use Picosystem.Pins;
with RP.Device;
with RP.Clock;
with RP.GPIO;
with RP.SPI;
with HAL.SPI;
with HAL; use HAL;

package body Picosystem.Screen is

   LCD : ST7789.ST7789_Screen
      (CS   => LCD_CS'Access,
       DC   => LCD_DC'Access,
       RST  => LCD_RESET'Access,
       Port => LCD_SPI'Access,
       Time => RP.Device.Timer'Access);

   procedure Initialize is
      use HAL.SPI;
      use RP.GPIO;
      use RP.SPI;

      SPI_Config : SPI_Configuration :=
         (Baud      => RP.Clock.Frequency (RP.Clock.SYS) / 2, --  max supported
          Data_Size => Data_Size_8b,
          Polarity  => Active_High,
          Phase     => Falling_Edge,
          Blocking  => True,
          others    => <>);
   begin
      --  Hold reset while we get everything configured
      LCD_RESET.Configure (Output);
      LCD_RESET.Clear;

      LCD_CS.Configure (Output, Pull_Up);
      LCD_DC.Configure (Output, Pull_Up);
      LCD_VSYNC.Configure (Input);
      LCD_SCLK.Configure (Output, Pull_Up, RP.GPIO.SPI);
      LCD_MOSI.Configure (Output, Pull_Up, RP.GPIO.SPI);
      LCD_SPI.Configure (SPI_Config);

      if not RP.Device.Timer.Enabled then
         RP.Device.Timer.Enable;
      end if;
      LCD.Initialize;

      --  Reconfigure for 16-bit transfers
      --  8.8.42 Write data for 16-bit/pixel (RGB-5-6-5-bit input), 65K-Colors, 3Ah=”05h”
      SPI_Config.Data_Size := HAL.SPI.Data_Size_16b;
      LCD_SPI.Configure (SPI_Config);

      declare
         use RP.DMA;
      begin
         RP.DMA.Enable;
         RP.DMA.Configure
            (Channel => DMA_Channel,
             Config  =>
               (Data_Size      => Transfer_16,
                Increment_Read => True,
                Trigger        => SPI0_TX,
                others         => <>));
      end;

      LCD_DC.Set;
      LCD_CS.Clear;
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

   procedure Write
      (Line : not null access Scanline)
   is
   begin
      while RP.DMA.Busy (DMA_Channel) loop
         null;
      end loop;

      RP.DMA.Start
         (Channel => DMA_Channel,
          From    => Line.all'Address,
          To      => LCD_SPI.FIFO_Address,
          Count   => Scanline'Length);
   end Write;
end Picosystem.Screen;
