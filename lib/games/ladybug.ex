defmodule BoxGame.Games.Ladybug do
  @moduledoc """
  Ladybug struct

  https://momath.org/wp-content/uploads/2026/01/Monthly-Mindbenders-January-2026.pdf

  Monthly Mindbenders
  January, 2026
  Problem
  A ladybug alights on the 12 of a cuckoo clock. Whenever the clock strikes, she moves randomly to a
  neighboring number (so the first time, she moves to the 1 or the 11 with equal probability). Suppose the
  ladybug continues this process until she has been to all of the numbers at least once.
  What is the probability that the last new number she visits is 6?
  Suggested by Richard Stanley.
  Comment
  """

  defstruct [:pos, :prev, :steps, :unvisited]

  defp next(curr) do
    [-1, 1]
    |> Enum.random()
    |> Kernel.+(curr)
    |> Integer.mod(12)
  end

  def init do
    %__MODULE__{
      pos: 11,
      prev: :none,
      steps: 0,
      unvisited: Range.to_list(0..10)
    }
  end

  def move(%__MODULE__{prev: prev, unvisited: []}), do: prev
  def move(%__MODULE__{pos: pos, steps: steps, unvisited: unvisited}) do
    %__MODULE__{
      pos: next(pos),
      prev: pos,
      steps: steps + 1,
      unvisited: List.delete(unvisited, pos)
    } |> move()
  end

end
