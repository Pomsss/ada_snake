package body Snakes is

    function Create_Snake return Snake is
        S : Snake;
    begin
        Enqueue(S.Bod, (20, 160));
        Enqueue(S.Bod, (10, 160));
        return S;
    end Create_Snake;

    function Get_Head_Coord(S: Snake) return Coord is
    begin
       return (GetHead(S.Bod).Pos.X, GetHead(S.Bod).Pos.Y);
    end Get_Head_Coord;

    procedure Move(S : in out Snake; Ate : Boolean; Width : Integer; Height : Integer) is
       New_Coord : Coord := (Get_Head_Coord(S).X + S.Dx * 20, Get_Head_Coord(S).Y + S.Dy * 20);
    begin
       if not Ate then
          Dequeue(S.Bod);
       end if;
       if New_Coord.X > Width then
          New_Coord.X := 0;
       end if;
       if New_Coord.Y > Height then
          New_Coord.Y := 0;
       end if;
       if New_Coord.Y < 0 then
          New_Coord.Y := Height;
       end if;
       if New_Coord.X < 0 then
          New_Coord.X := Width;
       end if;
       Enqueue(S.Bod, New_Coord);
    end Move;

    function Is_Alive(S : in Snake) return Boolean is
    begin
       return not Is_In_Queue(S.Bod, Get_Head_Coord(S));
    end Is_Alive;


end Snakes;
