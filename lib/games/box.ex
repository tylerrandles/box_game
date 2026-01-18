defmodule BoxGame.Games.Box do
  @moduledoc"""
  Struct for state of boxes
  """

  @columns 5
  @target 8

  defstruct boxes: %{}, furthest: 0, rounds: 0, found?: false

  def init do
    boxes = 0..(@columns - 1)
    |> Enum.map(&{&1, 1})
    |> Map.new()

    %__MODULE__{boxes: boxes, furthest: 0, rounds: 0, found?: false}
  end

  def reset(%__MODULE__{rounds: rounds}) do
    reset = init()

    %__MODULE__{reset | rounds: rounds}
  end

  defp random, do: :rand.uniform(@columns) - 1

  def guess(%__MODULE__{found?: true} = state), do: reset(state) |> guess()
  def guess(%__MODULE__{furthest: f, rounds: r}) when f > @target, do: r
  def guess(%__MODULE__{boxes: b, furthest: f, rounds: r}) when f <= @target do
    choice = random()
    correct? = choice == random()
    next_box = random()
    distance = Map.get(b, choice)
    update = Map.update!(b, next_box, &Kernel.+(&1, distance))
    furthest = Map.get(update, next_box) |> Kernel.max(f)

    %__MODULE__{
      boxes: update,
      furthest: furthest,
      rounds: r + 1,
      found?: correct?
    } |> guess()
  end

end
