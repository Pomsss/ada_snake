package body Snakes is

    function Create_Snake return Snake is
        S : Snake;
    begin
        Enqueue(S.Bod, (7, 5));
        Enqueue(S.Bod, (6, 5));
        return S;
    end Create_Snake;


    function Move(S : in out Snake; Apple : Coord) return Boolean is
        Ate : Boolean := False;
    begin
        if S.Head /= Apple then
            Dequeue(S.Bod);
            Ate := True;
        end if;
        Enqueue(S.Bod, S.Head);
        S.Head.X := S.Head.X + S.Dx;
        S.Head.Y := S.Head.Y + S.Dy;
        return Ate;
    end Move;

    function Is_Alive(S : in Snake) return Boolean is
    begin
        return not Is_In_Queue(S.Bod, S.Head);
    end Is_Alive;
    
end Snakes;
