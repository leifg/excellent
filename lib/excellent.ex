defmodule Excellent do
  @shared_strings 'xl/sharedStrings.xml'
  @styles 'xl/styles.xml'
  @workbook 'xl/workbook.xml'

  def parse filename, num_of_worksheet do
    file_content(filename, worksheet(num_of_worksheet))
      |> Excellent.Parser.sax_parse_worksheet(shared_strings(filename), styles(filename))
  end

  def worksheet_names filename do
    file_content(filename, @workbook)
      |> Excellent.Parser.parse_worksheet_names
  end

  defp shared_strings(spreadsheet_filename) do
    file_content(spreadsheet_filename, @shared_strings)
      |> Excellent.Parser.parse_shared_strings
  end

  defp styles(spreadsheet_filename) do
    file_content(spreadsheet_filename, @styles)
      |> Excellent.Parser.parse_styles
  end

  defp file_content(spreadsheet_filename, inner_filename) do
    {:ok, [{_filename, file_content}]} = :zip.extract spreadsheet_filename, [:memory, {:file_filter, fn(file) -> elem(file, 1) == inner_filename end }]
    file_content
  end

  defp worksheet(num) do
    'xl/worksheets/sheet#{num + 1}.xml'
  end
end
