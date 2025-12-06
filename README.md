# Task Master Box Game

This repo is a basic simulation for Taskmaster AU, Series 4 Episode 2 [Box Game](https://youtu.be/ZT4ncprMoz8?si=31Lg0YdgxauE0Uw2&t=1878)

See the results in a [chart](https://tylerrandles.github.io/box_game/) 

## What you see 

- A chart made with [VegaLite](https://hexdocs.pm/vega_lite/VegaLite.html) where
- 100,000 games were played
- Each bar represents how many games finish within a range (0-9, 10-19, ..., etc)

## From the Task

- 5 boxes are arranged in columns
- Each round
  - Player hides behind a box
  - If Lesser Tom finds you, all boxes reset
  - Otherwise promote 1 box equal to the distance you hid behind
  - Once a box passes the target (8 spaces forward), deceive Tom one more time
- Repeat until the player passes the target and record the total rounds
- **The algorithm has no strategy and the requirements may differ from the actual task**
  - Please be kind 

