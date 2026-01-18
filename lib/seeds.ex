defmodule BoxGame.Seeds do
  @moduledoc """
  Utility for random seeds
  """

  def default_base_seed, do: {303, 202, 101}

  defp triplet(i, {a, b, c}), do: {a + i, b + i * 17, c + i * 31}

  def stream(n, triple), do: Stream.map(0..(n - 1), &triplet(&1, triple))

  def get(n, triple), do: Enum.map(0..(n - 1), &triplet(&1, triple))

end
