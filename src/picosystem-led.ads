package Picosystem.LED is

   type Lights is (Backlight, Red, Green, Blue);
   type Brightness is range 0 .. 100;

   procedure Initialize;
   procedure Set
      (Light : Lights;
       Level : Brightness);

end Picosystem.LED;
