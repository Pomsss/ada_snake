package body Queues is

   function Is_Empty(Q: Queue) return Boolean is
   begin
      return Size(Q) = 0;
   end Is_Empty;

   function Is_Full(Q: Queue) return Boolean is
   begin
      return Size(Q) = Max_Length;
   end Is_Full;

   function Size(Q: Queue) return Natural is
   begin
      return Q.Length;
   end Size;

   function GetHead(Q: Queue) return Cell is
   begin
      return Q.Head.all;
   end GetHead;

   function GetTail(Q: Queue) return Cell is
   begin
      return Q.Tail.all;
   end GetTail;

   procedure Reset(Q: in out Queue) is
   begin
      Q.Length := 0;
   end Reset;

   procedure Enqueue(Q: in out Queue; C: Coord) is
   begin
      if Q.Head = null then
         Q.Head := new Cell'(C, null);
         Q.Tail := Q.Head;
      else
         Q.Head.Next := new Cell'(C, null);
         Q.Head := Q.Head.Next;
      end if;

      Q.Length := Q.Length + 1;
   end Enqueue;

   procedure Dequeue(Q: in out Queue) is
   begin
      Q.Tail.Next := Q.Tail;
      Q.Length := Q.Length - 1;
   end Dequeue;

   function Is_In_Queue(Q: Queue; Elt: Coord) return Boolean is
      C : Cell := Q.Tail.all;
   begin
      while C.Next /= null loop
         if C.Pos = Elt then
             return True;
         end if;
         C := C.Next.all;
     end loop;
     return False;
   end Is_In_Queue;

end Queues;
