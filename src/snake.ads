package Snake is

    type Coord is record
        X : Natural;
        Y : Natural;

    type Snake_Len is new Integer range 3 .. 100;

    type Delt is new Integer range -1 .. 1;

    type Snake_Body is array (Positive) of Coord;

    type Snake is record
        Head  : Coord := (5, 5);
        Bod   : Snake_Body;
        Len   : Snake_Len := 3;
        Dx    : Delt := -1;
        Dy    : Delt :=  0;
        Speed : Positive := 0;
    end record;

    procedure move(s : in out Snake)

end Snake;
