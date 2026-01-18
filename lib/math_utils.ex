defmodule BoxGame.MathUtils do
  @moduledoc """
  Utility functions
  """

  defstruct [:count, :min, :max, :mean, :median, :p90, :p99]

  def stats(samples) when is_list(samples) and samples != [] do
    count = length(samples)
    {min, max} = Enum.min_max(samples)
    sorted = Enum.sort(samples)
    mean = Enum.sum(samples) / count

    %__MODULE__{
      count: count,
      min: min,
      max: max,
      mean: mean,
      median: percentile(sorted, 50.0),
      p90: percentile(sorted, 90.0),
      p99: percentile(sorted, 99.0)
    }
  end

  defp percentile(sorted, p) when is_number(p) do
    max_index = length(sorted) - 1
    rank = max_index * (p / 100.0)

    lower_index = floor(rank)
    upper_index = min(lower_index + 1, max_index)
    weight = rank - lower_index

    lower_value = Enum.at(sorted, lower_index)
    upper_value = Enum.at(sorted, upper_index)

    1.0 * lower_value + weight * (upper_value - lower_value)
  end

  def histogram(samples, width \\ 5) do
    samples
    |> Enum.map(&Kernel.div(&1, width))
    |> Enum.frequencies()
    |> Enum.map(fn {range, count} ->
      {range * width..(range * width + width - 1), count}
    end)
    |> Enum.sort_by(fn {r.._h//_, _} -> r end)
  end

  defimpl String.Chars, for: BoxGame.MathUtils do
    alias BoxGame.MathUtils

    defp format(x) when is_float(x),
      do: :io_lib.format("~.2f", [x]) |> IO.iodata_to_binary()

    def to_string(%MathUtils{} = stats) do
      """
      n=#{stats.count}
      min=#{stats.min} max=#{stats.max}
      mean=#{format(stats.mean)} median=#{format(stats.median)}
      p90=#{format(stats.p90)} p99=#{format(stats.p99)}
      """
    end

  end

end
