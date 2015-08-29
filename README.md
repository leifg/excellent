# Excellent

**DISCLAIMER:** Under heavy development.

This is a library for parsing `.xlsx` files (Open XML format). It is targeted for reading Excel 2000 files into a list of lists.

Sample output:

```elixir
[
  ["A1", "B1", "C1", "D1"],
  ["A2", "B2", "C2", "D2"],
  ["A3", "B3", "C3", "D3"],
  ["A4", "B4", "C4", "D4"],
  ["A5", "B5", "C5", "D5"],
]
```

## Installation

You can add Excellent as a dependency in your `mix.exs` file. Since it only requires Elixir and Erlang there are no other dependencies.

```elixir
def deps do
  [ { :excellent, "~> 1.5.0" } ]
end
```

If you aren't using hex, add the a reference to the github repo.

``` elixir
def deps do
  [ { :excellent, github: "leifg/excellent" } ]
end
```

Then run `mix deps.get` in the shell to fetch and compile the dependencies

## Usage

The top level funtion takes 2 arguments: the filename and the number of the worksheet you want to parse (zero based).

```elixir
Excellent.parse('spreadsheet.xlsx', 0)

=> [
  ["A1", "B1", "C1", "D1"],
  ["A2", "B2", "C2", "D2"],
  ["A3", "B3", "C3", "D3"],
  ["A4", "B4", "C4", "D4"],
  ["A5", "B5", "C5", "D5"],
]
```

There is also a function to return the names of the worksheets as a tuple:

```elixir
Excellent.worksheet_names('spreadsheet.xlsx')

=> {"Worksheet 1", "Worksheet 2"}
```

## TODO

  - Read worksheets as stream from ZIP archive
  - Implement different data types (curently only strings and numbers are supported)
