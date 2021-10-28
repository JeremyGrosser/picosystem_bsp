--
--  Copyright (C) 2021 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Picosystem.Pins; use Picosystem.Pins;
with RP.Device;
with RP.GPIO;
with RP.SPI;
with ST7789;
with HAL.SPI;

package body Picosystem.Screen is

   LCD : ST7789.ST7789_Screen
      (CS   => LCD_CS'Access,
       DC   => LCD_DC'Access,
       RST  => LCD_RESET'Access,
       Port => LCD_SPI'Access,
       Time => RP.Device.Timer'Access);

   procedure Initialize is
      use RP.GPIO;

      SPI_Config : RP.SPI.SPI_Configuration :=
         (Baud     => 8_000_000,
          Blocking => True,
          others   => <>);
   begin
      --  Hold reset while we get everything configured
      LCD_RESET.Configure (Output);
      LCD_RESET.Clear;

      LCD_CS.Configure (Output);
      LCD_DC.Configure (Output);
      LCD_VSYNC.Configure (Input);
      LCD_SCLK.Configure (Output, Floating, RP.GPIO.SPI);
      LCD_MOSI.Configure (Output, Floating, RP.GPIO.SPI);
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
         RP.DMA.Configure
            (Channel => DMA_Channel,
             Config  =>
               (Data_Size      => Transfer_16,
                Increment_Read => True,
                Trigger        => SPI0_TX,
                others         => <>));
      end;
   end Initialize;

   procedure Wait_VSync is
   begin
      while RP.DMA.Busy (DMA_Channel) loop
         null;
      end loop;

      --  If already in vsync, wait for it to end
      while LCD_VSYNC.Get loop
         null;
      end loop;

      --  Now wait for the next vsync
      while not LCD_VSYNC.Get loop
         null;
      end loop;
   end Wait_VSync;

   procedure Swap_Buffers is
      Tmp : Buffer_Index;
   begin
      Tmp := Reading;
      Reading := Writing;
      Writing := Tmp;
   end Swap_Buffers;

   procedure Write
      (P : Pixels)
   is
   begin
      Buffers (Writing) := P;

      --  Wait for previous DMA transfer
      while RP.DMA.Busy (DMA_Channel) loop
         null;
      end loop;

      Swap_Buffers;

      --  Start DMA transfer
      RP.DMA.Start
         (Channel => DMA_Channel,
          From    => Buffers (Reading)'Address,
          To      => LCD_SPI.FIFO_Address,
          Count   => Buffers (Reading)'Length);
   end Write;

end Picosystem.Screen;
