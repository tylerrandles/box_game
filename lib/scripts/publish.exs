
Code.require_file("game.ex", "lib")
Code.require_file("runner.ex", "lib")

Mix.install([
  {:vega_lite, "~> 0.1.11"},
  {:jason, "~> 1.4"}
])

raw = Runner.simulate_many(100_000, max_concurrency: 32)

raw |> Runner.summarize() |> IO.inspect(label: "summary")

data = Enum.map(raw, &%{rounds: &1})

chart = VegaLite.new(width: 800, height: 400)
|> VegaLite.data_from_values(data)
|> VegaLite.mark(:bar)
|> VegaLite.encode_field(:x, "rounds", type: :quantitative, bin: [maxbins: 40])
|> VegaLite.encode_field(:y, "count", type: :quantitative, aggregate: :count)
|> VegaLite.config(view: [stroke: nil])
|> VegaLite.to_spec()

html = """
<!doctype html>
<html><head><meta charset="utf-8">
<title>Taskmaster Box Move — Histogram</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>body{font-family:system-ui,Segoe UI,Roboto,Helvetica,Arial,sans-serif;margin:20px}</style>
<script src="https://cdn.jsdelivr.net/npm/vega@5"></script>
<script src="https://cdn.jsdelivr.net/npm/vega-lite@5"></script>
<script src="https://cdn.jsdelivr.net/npm/vega-embed@6"></script>
</head><body>
<h1>Taskmaster Box Move — Rounds to Win</h1>
<div id="vis"></div>
<script>
  const spec = #{Jason.encode!(chart)};
  vegaEmbed("#vis", spec, {actions: false});
</script>
</body></html>
"""

File.mkdir_p!("docs")
File.write!("docs/index.html", html)
IO.puts("wrote to docs/index.html")
