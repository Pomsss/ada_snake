with Coords; use Coords;
with Queues; use Queues;

package Snakes is

    type Snake is record
        Head  : Coord := (5, 5);
        Bod   : Queue;
        Dx    : Integer := -1;
        Dy    : Integer :=  0;
        Speed : Integer := 1;
    end record;

    function Create_Snake return Snake;
    function Move(S : in out Snake; Apple : Coord) return Boolean;
    function Is_Alive(S : in Snake) return Boolean;

end Snakes;
