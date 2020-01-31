with Coords; use Coords;
with Queues; use Queues;

package Snakes is

    type Snake is record
        Bod   : Queue;
        Dx    : Integer := -1;
        Dy    : Integer := 0;
        Speed : Integer := 1;
    end record;

    function Get_Head_Coord(S: Snake) return Coord;
    function Create_Snake return Snake with
      Post => not Is_Empty(Create_Snake'Result.Bod) and Size(Create_Snake'Result.Bod) >= 2;

    procedure Move(S: in out Snake; Ate: Boolean; Width : Integer; Height : Integer) with
      Post => Get_Head_Coord(S).X /= Get_Head_Coord(S).X'Old
      and Get_Head_Coord(S).Y /= Get_Head_Coord(S).Y'Old;

    function Is_Alive(S: in Snake) return Boolean;

end Snakes;
