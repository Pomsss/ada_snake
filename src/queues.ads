with Coords; use Coords;

package Queues is

   type Cell;
   Max_Length : constant Natural := 200;

   type Link is access Cell;

   type Cell is record
      Pos : Coord;
      Next : Link;
   end record;


   type Queue is record
      Head : Link;
      Tail : Link;
      Length : Natural := 0;
   end record;


   function Is_Empty(Q: Queue) return Boolean;

   function Is_Full(Q: Queue) return Boolean;

   function Size(Q: Queue) return Natural;

   function GetHead(Q: Queue) return Cell with
     Pre => not Is_Empty(Q);

   function GetTail(Q: Queue) return Cell with
     Pre => not Is_Empty(Q);

   procedure Reset(Q: in out Queue) with
     Pre => not Is_Empty(Q),
     Post => Is_Empty(Q);

   procedure Enqueue(Q: in out Queue; C: Coord) with
     Pre => not Is_Full(Q),
     Post => Size(Q) = Size(Q)'Old + 1;

   procedure Dequeue(Q: in out Queue) with
     Pre => not Is_Empty(Q),
     Post => Size(Q) = Size(Q)'Old - 1;

   function Is_In_Queue(Q: Queue; Elt: Coord) return Boolean with
     Pre => not Is_Empty(Q);

--private
end Queues;
