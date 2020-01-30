package body Snakes is

    function Create_Snake return Snake is
        S : Snake;
    begin
        Enqueue(S.Bod, (7, 5));
        Enqueue(S.Bod, (6, 5));
        return S;
    end Create_Snake;


    procedure Move(S : in out Snake; Ate : Boolean; Width : Integer; Height : Integer) is
    begin
        if not Ate then
            Dequeue(S.Bod);
        end if;
        Enqueue(S.Bod, S.Head);
        S.Head.X := S.Head.X + S.Dx;
        S.Head.Y := S.Head.Y + S.Dy;
        if S.Head.X > Width then
            S.Head.X := 0;
        end if;
        if S.Head.Y > Height then
            S.Head.Y := 0;
        end if;
    end Move;

    function Is_Alive(S : in Snake) return Boolean is
    begin
        return not Is_In_Queue(S.Bod, S.Head);
    end Is_Alive;
    
end Snakes;
