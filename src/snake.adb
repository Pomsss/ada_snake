package body Snake is

    procedure move(s : in out Snake) is
        dequeue(s.Bod)
        s.Head.X = s.Head.X + S.Dx;
        s.Head.Y = s.Head.Y + S.Dy;
    begin
        
end Snake;
