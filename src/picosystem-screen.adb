with HAL.SPI; use HAL.SPI;
with RP.Device;
with RP.SPI;

package body Picosystem.Screen is

   --  9.1 System Function Command Table 1
   Port : RP.SPI.SPI_Port renames RP.Device.SPI_0;

   procedure Initialize is
      use RP.SPI;
      Config : constant SPI_Configuration :=
         (Baud     => 8_000_000,
          Blocking => True,
          others   => <>);
   begin
      --  Hold reset low while we get everything configured
      LCD_RESET.Configure (Output);
      LCD_RESET.Clear;

      LCD_CS.Configure (Output);
      LCD_CS.Clear;

      LCD_DC.Configure (Output);
      LCD_DC.Clear;

      LCD_VSYNC.Configure (Output);
      LCD_VSYNC.Clear;

      LCD_SCLK.Configure (Output, Floating, RP.GPIO.SPI);
      LCD_MOSI.Configure (Output, Floating, RP.GPIO.SPI);

      Port.Configure (Config);

      LCD_RESET.Set;
      --  Maybe need a delay here.

      LCD_CS.Set;
      --  Command (SWRESET);
   end Initialize;

   procedure Command
      (Cmd : UInt8)
   is
      C : constant SPI_Data_8b (1 .. 1) := (1 => Cmd);
      Status : SPI_Status;
   begin
      LCD_CS.Clear;
      LCD_DC.Clear;
      Port.Transmit (C, Status);
      LCD_CS.Set;
   end Command;

   procedure Command
      (Cmd  : UInt8;
       Data : UInt8_Array)
   is
      C : constant SPI_Data_8b (1 .. 1) := (1 => Cmd);
      Status : SPI_Status;
   begin
      LCD_CS.Clear;

      LCD_DC.Clear;
      Port.Transmit (C, Status);

      LCD_DC.Set;
      Port.Transmit (SPI_Data_8b (Data), Status);

      LCD_CS.Set;
   end Command;

end Picosystem.Screen;
