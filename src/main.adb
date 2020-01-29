with STM32.Board;         use STM32.Board;
with Ada.Real_Time;       use Ada.Real_Time;
with Ada.Numerics.Discrete_Random;

with STM32.DMA2D_Bitmap;  use STM32.DMA2D_Bitmap;
with HAL.Bitmap;          use HAL.Bitmap;
with HAL.Touch_Panel;     use HAL.Touch_Panel;

with Snakes; use Snakes;


Procedure Main is
    S : Snake := Create_Snake;
    B : Boolean := True;
begin
    while not Move(S, (3, 7)) and B loop
        B := Is_Alive(S);
    end loop;
end Main;
