with HAL; use HAL;

package Picosystem.Screen is

   procedure Initialize;

   procedure Command
      (Cmd : UInt8);

   procedure Command
      (Cmd  : UInt8;
       Data : UInt8_Array);

end Picosystem.Screen;
