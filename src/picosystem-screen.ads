--
--  Copyright (C) 2021 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HAL; use HAL;
with RP.DMA;

package Picosystem.Screen is

   Width  : constant := 240;
   Height : constant := 240;

   procedure Initialize;
   procedure Wait_VSync;

   type Color is record
      R : UInt5;
      G : UInt6;
      B : UInt5;
   end record
      with Pack, Size => 16;

   --  Write one row of pixels at a time, double buffered.
   type Pixels is array (1 .. Width) of Color;
   procedure Write
      (P : Pixels);

private

   DMA_Channel : constant RP.DMA.DMA_Channel_Id := 0;
   DMA_Trigger : constant RP.DMA.DMA_Request_Trigger := RP.DMA.SPI0_TX;

   type Buffer_Index is range 1 .. 2;
   Buffers : array (Buffer_Index) of Pixels;
   Reading : Buffer_Index := 1;
   Writing : Buffer_Index := 2;

   procedure Swap_Buffers;

end Picosystem.Screen;
