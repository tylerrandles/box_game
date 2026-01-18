defmodule BoxGame.Runner do
  @moduledoc"""
  Module for running Monte Carlo simulations
  """
  alias BoxGame.Seeds

  @doc """
  Function entry for simulations
  The purpose of these executions is for evidence, not proof

    ## Example
    iex> alias BoxGame.Runner
    iex> alias BoxGame.Games.Ladybug
    iex> alias BoxGame.Game.Box
    iex> boxes = Runner.simulate_many(100_000, {Box, :guess}, max_concurrency: 32)
    iex> bugs = Runner.simulate_many(100_000, {Ladybug, :move}, max_concurrency: 32)
  """
  def simulate_many(n, {module, fx}, options \\ []) when is_integer(n) and n > 0 and is_atom(module) and is_atom(fx) do
    max_concurrency = Keyword.get(options, :max_concurrency, System.schedulers_online() * 2)
    base_seed = Keyword.get(options, :base_seed, Seeds.default_base_seed())
    timeout = Keyword.get(options, :timeout, :infinity)
    ordered = Keyword.get(options, :ordered, false)
    init_fx = Keyword.get(options, :init, :init)

    n
    |> Seeds.stream(base_seed)
    |> Task.async_stream(
      &seeded_game(&1, {module, fx}, init_fx),
      max_concurrency: max_concurrency,
      timeout: timeout,
      ordered: ordered
    )
    |> Enum.flat_map(&unwrap_result/1)
  end

  defp seeded_game(seed, {module, fx}, init_fx) do
    :rand.seed(:exsss, seed)
    run_game({module, fx}, seed, init_fx)
  end


  defp run_game({module, fx}, _seed, init_fun) when is_atom(module) and is_atom(fx) do
    state = Kernel.apply(module, init_fun, [])
    Kernel.apply(module, fx, [state])
  end

  defp unwrap_result({:ok, result}), do: [result]
  # modify to fail
  defp unwrap_result(_error), do: []

end
