defmodule Type do
  @true_value "1"

  @seconds_in_day 24 * 60 * 60
  @base_date :calendar.datetime_to_gregorian_seconds({{1899, 12, 30}, {0,0,0}})

  def from_string(@true_value, %{type: "boolean"}), do: true
  def from_string(_, %{type: "boolean"}), do: false
  def from_string(input, %{type: "string"}), do: input

  def from_string(input, %{type: "number"}) do
    case Integer.parse(input) do
      { int, "" } ->
        int
      { float_number, float_decimals } ->
        {float, _} = Float.parse("#{float_number}#{float_decimals}")
        float
    end
  end

  def from_string(input, %{type: "date"}) when is_float(input) do
    datetime = @base_date + input * @seconds_in_day |> round |> :calendar.gregorian_seconds_to_datetime
  end

  def from_string(input, %{type: "date"}) when is_bitstring(input) do
    {to_float, _} = Float.parse(input)
    from_string(to_float, %{type: "date"})
  end

  def from_string(input, %{type: "shared_string", lookup: lookup}) when is_number(input) do
    elem(lookup, input)
  end

  def from_string(input, options) when is_bitstring(input) do
    from_string(input, %{type: "number"}) |> from_string(options)
  end
end
