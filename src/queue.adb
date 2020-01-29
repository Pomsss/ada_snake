package body Queue is
   function Size(Q: Queue) return Natural is
   begin
      return Q.Length;
   end Size;

   function GetHead(Q: Queue) return Cell is
   begin
      return Q.Head;
   end GetHead;

   function GetTail(Q: Queue) return Cell is
   begin
      return Q.Tail;
   end GetTail;

   procedure Reset(Q: out Queue) is
   begin
      Q.Length := 0;
   end Reset;

   procedure EnQueue(Q: out Queue, C: Coord) is
   begin
      if Q.Head = null then
         Q.Head := new Cell(C, null);
         Q.Tail := Q.Head;
      else
         Q.Head.Next := new Cell(C, null);
         Q.Head := Q.Head.Next;
      end if;

      Q.Length := Q.Length + 1;
   end AddTail;

   procedure DeQueue(Q: out Queue) is
   begin
      Q.Tail.Next := Q.Tail;
      Q.Length := Q.Length + 1;
   end DeQueue;
end body;
