defmodule Runner do
  @moduledoc"""
  Module for running many Games
  """

  @default_base_seed {303, 202, 101}

  def run_one(seed3) do
    :rand.seed(:exsss, seed3)

    Game.init()
    |> Game.guess()
  end

  @doc"""
  Run many games.

    ## Example
    iex> [non_empty_list | _] = Runner.simulate_many(100_000, max_concurrency: 32)
  """
  def simulate_many(n, options \\ []) when is_integer(n) and n > 0 do
    concurrency = Keyword.get(options, :max_concurrency, System.schedulers_online() * 2)
    base_seed = Keyword.get(options, :base_seed, @default_base_seed)

    seeds(n, base_seed)
    |> Task.async_stream(&run_one/1, max_concurrency: concurrency, timeout: :infinity)
    |> Enum.flat_map(fn
      {:ok, rounds} when is_integer(rounds) ->
        [rounds]

      _other ->
        []
    end)
  end

  def summarize(samples) when is_list(samples) and samples != [] do
    stats = stats(samples)

    """
    n=#{stats.count}
    min=#{stats.min}  max=#{stats.max}
    mean=#{format(stats.mean)}  median=#{format(stats.median)}
    p90=#{format(stats.p90)}  p99=#{format(stats.p99)}
    """
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

  defp seeds(n, {a, b, c}) do
    for i <- 0..(n - 1) do
      {a + i, b + i * 17, c + i * 31}
    end
  end

  defp stats(samples) do
    count = length(samples)
    {min, max} = Enum.min_max(samples)
    sorted = Enum.sort(samples)

    %{
      count: count,
      min: min,
      max: max,
      mean: Enum.sum(samples) / count,
      median: percentile(sorted, 50.0),
      p90: percentile(sorted, 90.0),
      p99: percentile(sorted, 99.0)
    }
  end

  defp percentile(sorted, p) do
    n = length(sorted) - 1
    kf = n * (p / 100.0)
    i = floor(kf)
    f = kf - i

    left = Enum.at(sorted, i)
    right = Enum.at(sorted, min(i + 1, n))

    left + f * (right - left)
  end

  defp format(x) when is_float(x), do: :io_lib.format("~.2f", [x]) |> IO.iodata_to_binary()

end
