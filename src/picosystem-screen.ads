--
--  Copyright (C) 2021 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with RP.DMA;
with ST7789;

package Picosystem.Screen is

   Width  : constant := 240;
   Height : constant := 240;

   procedure Initialize;
   procedure Wait_VSync;

   --  Write one row of pixels at a time, double buffered.
   subtype Color is ST7789.RGB565;
   subtype Pixels is ST7789.Pixels;

   subtype Scanline is Pixels (1 .. Width);

   procedure Write
      (Line : not null access Scanline);

private

   DMA_Channel : constant RP.DMA.DMA_Channel_Id := 0;
   DMA_Trigger : constant RP.DMA.DMA_Request_Trigger := RP.DMA.SPI0_TX;

end Picosystem.Screen;
