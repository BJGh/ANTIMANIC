using System;
using System.Collections.Generic;

class Snake
{
    private Point head;
    private LinkedList<Point> body;

    public Snake(int x, int y, int length)
    {
        head = new Point(x, y);
        body = new LinkedList<Point>();
        for (int i = 0; i < length; i++)
        {
            body.AddLast(new Point(x, y + i + 1));
        }
    }

    public void Move(Direction direction)
    {
        Point newHead = new Point(head.X, head.Y);
        switch (direction)
        {
            case Direction.Up:
                newHead.Y -= 1;
                break;
            case Direction.Down:
                newHead.Y += 1;
                break;
            case Direction.Left:
                newHead.X -= 1;
                break;
            case Direction.Right:
                newHead.X += 1;
                break;
        }

        if (newHead.X < 0 || newHead.Y < 0 || newHead.X >= Console.WindowWidth || newHead.Y >= Console.WindowHeight)
        {
            throw new CollisionException("Hit the wall!");
        }

        if (body.Contains(newHead))
        {
            throw new CollisionException("Hit yourself!");
        }

        body.AddFirst(head);
        head = newHead;
        if (body.Count > 10)
        {
            body.RemoveLast();
        }
    }

    public void Draw()
    {
        Console.SetCursorPosition(head.X, head.Y);
        Console.Write("O");
        foreach (Point p in body)
        {
            Console.SetCursorPosition(p.X, p.Y);
            Console.Write("o");
        }
    }
}

enum Direction
{
    Up,
    Down,
    Left,
    Right
}

class Point
{
    public int X { get; set; }
    public int Y { get; set; }

    public Point(int x, int y)
    {
        X = x;
        Y = y;
    }
}

class CollisionException : Exception
{
    public CollisionException(string message) : base(message)
    {
    }
}
class Food
{
    private Point position;
    private Random random;

    public Food()
    {
        random = new Random();
        position = new Point(random.Next(Console.WindowWidth), random.Next(Console.WindowHeight));
    }

    public bool IsEatenBy(Snake snake)
    {
        return snake.Head.X == position.X && snake.Head.Y == position.Y;
    }

    public void Draw()
    {
        Console.SetCursorPosition(position.X, position.Y);
        Console.Write("*");
    }
}


class Program
{
    static void Main()
    {
        Console.CursorVisible = false;
        Snake snake = new Snake(Console.WindowWidth / 2, Console.WindowHeight / 2, 3);
        Direction currentDirection = Direction.Down;
        Food food = new Food();
        while (true)
        {
            if (Console.KeyAvailable)
            {
                ConsoleKeyInfo key = Console.ReadKey(true);
                switch (key.Key)
                {
                    case ConsoleKey.UpArrow:
                        currentDirection = Direction.Up;
                        break;
                    case ConsoleKey.DownArrow:
                        currentDirection = Direction.Down;
                        break;
                    case ConsoleKey.LeftArrow:
                        currentDirection = Direction.Left;
                        break;
                    case ConsoleKey.RightArrow:
                        currentDirection = Direction.Right;
                        break;
                }
            }

            Console.Clear();
            snake.Move(currentDirection);
            snake.Draw();

            // Add some delay to slow down the game
            Thread.Sleep(100);
        }
    }

}
