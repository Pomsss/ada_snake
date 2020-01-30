with STM32.Board;         use STM32.Board;
with Ada.Real_Time;       use Ada.Real_Time;
with Ada.Numerics.Discrete_Random;

with STM32.DMA2D_Bitmap;  use STM32.DMA2D_Bitmap;
with HAL.Bitmap;          use HAL.Bitmap;
with HAL.Touch_Panel;     use HAL.Touch_Panel;

with Snakes; use Snakes;
with Coords; use Coords;
with Queues; use Queues;

Procedure Main is
    
    -- 480x272   15x15 blocks with one pixel offset
    SQUARE_SIDE : Natural := 15;
    WIDTH       : Natural := 17; -- 17
    HEIGHT      : Natural := 30;-- 30

    Screen_Width      : Natural; -- 17
    Screen_Height     : Natural;-- 30

    Apple   : Coord;
    Player  : Snake := Create_Snake;
    Touched : Coord;

    subtype RNG is Integer range 0 .. (HEIGHT * WIDTH);

    package Random_Pos is new Ada.Numerics.Discrete_Random (RNG); use Random_Pos;
    G : Generator;

    Period       : constant Time_Span := Milliseconds (500);
    Next_Release : Time := Clock;

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
        Bitmap_Buffer.Set_Source(Color);
        Bitmap_Buffer.Fill_Rect(( Position => (X * WIDTH + X, Y * HEIGHT + Y),
                                  Width    => SQUARE_SIDE,
                                  Height   => SQUARE_SIDE));

    end Draw_Square;


    procedure Draw(S : Snake; Apple : Coord) is
        C : Cell := S.Bod.Tail.all;
    begin
        Draw_Square(Apple, HAL.Bitmap.Red);
        Draw_Square(S.Head, HAL.Bitmap.Green);

        while C.Next /= null loop
           Draw_Square(C.Pos, HAL.Bitmap.Green);
           C := C.Next.all;
        end loop;
        
    end Draw;
    
    
    function Ate(S : Snake; Apple : in out Coord) return Boolean is
    begin
        if S.Head = Apple then
            Apple := (Random(G) / Height, Random(G) / Width); 
            return True;
        end if;
        return False;
    end Ate;

    -- Screen split in 4 by 2 diagonals 
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

begin
    Reset(G);
    --  Initialize LCD
    Display.Initialize;
    Display.Initialize_Layer (1, HAL.Bitmap.ARGB_8888);

    Touch_Panel.Initialize;


    Screen_Width  := Bitmap_Buffer.Width;
    Screen_Height := Bitmap_Buffer.Height;

    loop
        declare
            State : constant TP_State := Touch_Panel.Get_All_Touch_Points;
        begin
            if State'Length > 0 then
               Touched := (State (State'First).X, State (State'First).Y);
               Set_Dir(Player, Touched, Screen_Width, Screen_Height);           
            end if;
        end;       
        Bitmap_Buffer.Set_Source (HAL.Bitmap.Black);
        Bitmap_Buffer.Fill;

        Move(Player, Ate(Player, Apple), WIDTH, HEIGHT);
        
        Draw(Player, Apple);
        
        Display.Update_Layers;

        if not Is_Alive(Player) then
            return;
        end if;
            
        Next_Release := Next_Release + Period;
        delay until Next_Release;
    end loop;
end Main;
