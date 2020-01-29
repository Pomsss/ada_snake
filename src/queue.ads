package Queue is

   type Cell;
   type Link is access Cell;

   type Coord is record
      X : Natural;
      Y : Natural;
   end record;

   function IsEmpty(Q: Queue) return Boolean is (Size(Q) = 0);

   function Size(Q: Queue) return Natural;

   function GetHead(Q: Queue) return Cell with
     Pre => not IsEmpty(Q);

   function GetTail(Q: Queue) return Cell with
     Pre => not IsEmpty(Q);

   procedure Reset(Q: out Queue) with
     Pre => not IsEmpty(Q);

   procedure EnQueue(Q: in out Queue, C: Cell) with
     Pre => not IsFull(Q),
     Post => Size(Q) = Size(Q)'Old + 1;

   procedure DeQueue(Q: in out Queue) return Cell with
     Pre => not IsEmpty(Q),
     Post => Size(Q) = Size(Q)'Old - 1;

private
   Max_Length : constant Natural := 200;

   type Cell is record
      Pos : Coord;
      Next : Link;
   end record;

   type Queue is record
      Head : Link;
      Tail : Link;
      Length : Natural := 0;
   end record;
end Queue;
