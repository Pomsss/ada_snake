package body Snake is

    procedure move(s : in out Snake) is
    begin
        Dequeue(s.Bod);
        Enqueue(s.Bod, s.Head);
        s.Head.X = s.Head.X + S.Dx;
        s.Head.Y = s.Head.Y + S.Dy;
    end;

    
    
end Snake;
