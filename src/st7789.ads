with HAL.Time;
with HAL.GPIO;
with HAL.SPI;
with HAL;

package ST7789 is
   type ST7789_Screen
      (CS   : not null HAL.GPIO.Any_GPIO_Point;
       DC   : not null HAL.GPIO.Any_GPIO_Point;
       RST  : not null HAL.GPIO.Any_GPIO_Point;
       Port : not null HAL.SPI.Any_SPI_Port;
       Time : not null HAL.Time.Any_Delays)
   is tagged null record;

   --  These register names come from the ST7735S datasheet, just for extra confusion.
   type Register is
      (SWRESET,
       TEON,
       MADCTL,
       COLMOD,
       GCTRL,
       VCOMS,
       LCMCTRL,
       VDVVRHEN,
       VRHS,
       VDVS,
       FRCTRL2,
       PWRCTRL1,
       FRMCTR1,
       FRMCTR2,
       GMCTRP1,
       GMCTRN1,
       INVOFF,
       SLPOUT,
       DISPON,
       GAMSET,
       DISPOFF,
       RAMWR,
       INVON,
       CASET,
       RASET)
   with Size => 8;

   procedure Initialize
      (This : in out ST7789_Screen);

   procedure Write
      (This : in out ST7789_Screen;
       Reg  : Register);

   procedure Write
      (This : in out ST7789_Screen;
       Reg  : Register;
       Data : HAL.UInt8);

   procedure Write
      (This : in out ST7789_Screen;
       Reg  : Register;
       Data : HAL.UInt8_Array);

end ST7789;
