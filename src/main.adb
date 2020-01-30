with Last_Chance_Handler;  pragma Unreferenced (Last_Chance_Handler);
--  The "last chance handler" is the user-defined routine that is called when
--  an exception is propagated. We need it in the executable, therefore it
--  must be somewhere in the closure of the context clauses.

with STM32.Board;           use STM32.Board;
with STM32.DMA2D_Bitmap;  use STM32.DMA2D_Bitmap;
with HAL.Bitmap;            use HAL.Bitmap;

pragma Warnings (Off, "referenced");
with HAL.Touch_Panel;       use HAL.Touch_Panel;
with STM32.User_Button;     use STM32;
with BMP_Fonts;
with LCD_Std_Out;
with Ada.Real_Time; use Ada.Real_Time;
with Ada.Numerics.Discrete_Random;

with Snakes; use Snakes;
with Coords; use Coords;
with Queues; use Queues;

procedure Main
is
   BG : Bitmap_Color := (Alpha => 255, others => 64);
   Ball_Pos   : Point := (20, 280);

   SQUARE_SIDE : Natural := 6;
   --  WIDTH  : Natural := 17;
   --  HEIGHT : Natural := 30;
   Player : Snake := Create_Snake;
   Screen_Width : Natural;
   Screen_Height : Natural;

   Period       : constant Time_Span := Milliseconds (50);
   Next_Release : Time := Clock;

   subtype RNG is Integer range 0 .. Integer'Last;
   package Random_Pos is new Ada.Numerics.Discrete_Random (RNG); use Random_Pos;
   G: Generator;

   Apple : Coord := (60, 160);--(Random(G) mod HEIGHT, Random(G) mod WIDTH);
   Touched : Coord;

   function Bitmap_Buffer return not null Any_Bitmap_Buffer is
   begin
      if Display.Hidden_Buffer (1).all not in DMA2D_Bitmap_Buffer then
         raise Program_Error with "We expect a DM2D buffer here";
      end if;
      return Display.Hidden_Buffer(1);
   end Bitmap_Buffer;

   procedure Draw_Square(Pos : Coord; Color: Bitmap_Color) is
      X : Integer := Pos.X;
      Y : Integer := Pos.Y;
   begin
      Bitmap_Buffer.Set_Source (Color);
      Bitmap_Buffer.Fill_Circle ((X mod Screen_Width, Y mod Screen_Height), 10);

      --  Bitmap_Buffer.Set_Source(Color);
      --  Bitmap_Buffer.Fill_Rect(( Position => (X, Y),
      --                            Width    => SQUARE_SIDE,
      --                            Height   => SQUARE_SIDE));
   end Draw_Square;


   procedure Set_Dir(S : in out Snake; Pos : Coord; W : Integer; H : Integer) is
      X : Integer := Pos.X;
      Y : Integer := Pos.Y;
      In_Right_Triangle : Boolean;
      In_Left_Triangle : Boolean;
   begin
      In_Left_Triangle := H * (X - W) < (-Y) * W;
      In_Right_Triangle := H * X > W * Y;
      if In_Right_Triangle and In_Left_Triangle then              -- up
         S.Dx := 0;
         S.Dy := -1;
      elsif In_Right_Triangle and not In_Left_Triangle then       -- right
         S.Dx := 1;
         S.Dy := 0;
      elsif not In_Right_Triangle and In_Left_Triangle then       -- left
         S.Dx := -1;
         S.Dy := 0;
      elsif not In_Right_Triangle and not In_Left_Triangle then   -- down
         S.Dx := 0;
         S.Dy := 1;
      end if;
   end Set_Dir;

   function Ate(S : Snake; Apple : in out Coord) return Boolean is
      Head_Coord : Coord := Get_Head_Coord(S);
   begin
      if Head_Coord.X > Apple.X - 20 and Head_Coord.X < Apple.X + 20 and
        Head_Coord.Y > Apple.Y - 10 and Head_Coord.Y < Apple.Y + 20 then
         Apple := (Random(G) mod Screen_Width, Random(G) mod Screen_Height);
         return True;
      end if;
      return False;
   end Ate;

   procedure Draw(S : Snake; Apple : Coord) is
      C : Cell := S.Bod.Tail.all;
   begin
      Draw_Square(Apple, HAL.Bitmap.Red);
      Draw_Square(Get_Head_Coord(S), HAL.Bitmap.Green);

      while C.Next /= null loop
         Draw_Square(C.Pos, HAL.Bitmap.Green);
         C := C.Next.all;
      end loop;

   end Draw;
begin
   Reset(G);

   --  Initialize LCD
   Display.Initialize;
   Display.Initialize_Layer (1, ARGB_8888);

   --  Initialize touch panel
   Touch_Panel.Initialize;

   --  Initialize button
   User_Button.Initialize;

   LCD_Std_Out.Set_Font (BMP_Fonts.Font8x8);
   LCD_Std_Out.Current_Background_Color := BG;

   --  Clear LCD (set background)
   Display.Hidden_Buffer (1).Set_Source (BG);
   Display.Hidden_Buffer (1).Fill;

   LCD_Std_Out.Clear_Screen;
   Display.Update_Layer (1, Copy_Back => True);

   Screen_Width  := Bitmap_Buffer.Width;
   Screen_Height := Bitmap_Buffer.Height;

   LCD_Std_Out.Put_Line(Screen_Height'Image);
   loop
      if User_Button.Has_Been_Pressed then
         BG := HAL.Bitmap.Dark_Orange;
      end if;

      Display.Hidden_Buffer (1).Set_Source (BG);
      Display.Hidden_Buffer (1).Fill;

      Display.Hidden_Buffer (1).Set_Source (HAL.Bitmap.Blue);
      Display.Hidden_Buffer (1).Fill_Circle (Ball_Pos, 10);


      declare
         State : constant TP_State := Touch_Panel.Get_All_Touch_Points;
      begin
         if State'Length = 1 then
            Touched := (State (State'First).X, State (State'First).Y);
            Set_Dir(Player, Touched, Screen_Width, Screen_Height);
            Ball_Pos := (State (State'First).X, State (State'First).Y);
--            Move(Player, Ate(Player, Apple), Screen_Width, Screen_Height);
         else
            null;
         end if;
      end;

      Move(Player, Ate(Player, Apple), Screen_Width, Screen_Height);
      Draw(Player, Apple);
      Display.Update_Layers;

      if not Is_Alive(Player) then
         return;
      end if;

      --  Update screen
      Display.Update_Layer (1, Copy_Back => True);
      Next_Release := Next_Release + Period;
--      delay until Next_Release;


   end loop;
end Main;
