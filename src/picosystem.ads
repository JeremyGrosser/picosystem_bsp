--
--  Copyright (C) 2021 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
--  References:
--  https://shop.pimoroni.com/products/picosystem
--  https://cdn.shopify.com/s/files/1/0174/1800/files/picosystem_schematic.pdf
with RP.GPIO; use RP.GPIO;
with RP.Device;
with RP.UART;
with RP.SPI;

package PicoSystem is
   UART_TX     : aliased GPIO_Point := (Pin => 0);
   UART_RX     : aliased GPIO_Point := (Pin => 1);
   VBUS_DETECT : aliased GPIO_Point := (Pin => 2);
   --  Pin 3 not connected
   LCD_RESET   : aliased GPIO_Point := (Pin => 4);
   LCD_CS      : aliased GPIO_Point := (Pin => 5);
   LCD_SCLK    : aliased GPIO_Point := (Pin => 6);
   LCD_MOSI    : aliased GPIO_Point := (Pin => 7);
   LCD_VSYNC   : aliased GPIO_Point := (Pin => 8);
   LCD_DC      : aliased GPIO_Point := (Pin => 9);
   --  Pin 10 not connected
   AUDIO       : aliased GPIO_Point := (Pin => 11);
   BACKLIGHT   : aliased GPIO_Point := (Pin => 12);
   LED_G       : aliased GPIO_Point := (Pin => 13);
   LED_R       : aliased GPIO_Point := (Pin => 14);
   LED_B       : aliased GPIO_Point := (Pin => 15);
   Y           : aliased GPIO_Point := (Pin => 16);
   X           : aliased GPIO_Point := (Pin => 17);
   A           : aliased GPIO_Point := (Pin => 18);
   B           : aliased GPIO_Point := (Pin => 19);
   DOWN        : aliased GPIO_Point := (Pin => 20);
   RIGHT       : aliased GPIO_Point := (Pin => 21);
   LEFT        : aliased GPIO_Point := (Pin => 22);
   UP          : aliased GPIO_Point := (Pin => 23);
   CHARGE_STAT : aliased GPIO_Point := (Pin => 24);
   --  Pin 25 not connected
   BAT_SENSE   : aliased GPIO_Point := (Pin => 26);
   --  Pin 27 not connected
   --  Pin 28 not connected
   --  Pin 29 not connected

   UART    : RP.UART.UART_Port renames RP.Device.UART_0;
   LCD_SPI : RP.SPI.SPI_Port   renames RP.Device.SPI_0;
end PicoSystem;
