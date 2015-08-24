defmodule ExcellentSpec do
  use ESpec

  describe "#worksheet_names" do
    it "returns worksheet names" do
      expect(Excellent.worksheet_names('./spec/fixtures/simple_example.xlsx')).to eq(['Bibelbund_Abfrage'])
    end
  end

  describe "#shared_strings_to_tuple" do
    let :shared_strings do
      """
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <sst count="10" uniqueCount="8" xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
        <si>
          <t>TITEL</t>
        </si>
        <si>
          <t>VERFASSER</t>
        </si>
        <si>
          <t>OBJEKT</t>
        </si>
        <si>
          <t>NUMMER</t>
        </si>
        <si>
          <t>SEITE</t>
        </si>
        <si>
          <t>INTERNET</t>
        </si>
        <si>
          <t>PC</t>
        </si>
        <si>
          <t>KENNUNG</t>
        </si>
      </sst>
      """
    end

    let :expected_tuple do
      {"TITEL", "VERFASSER", "OBJEKT", "NUMMER", "SEITE", "INTERNET", "PC", "KENNUNG"}
    end

    it "returns expected tuple" do
      expect(Excellent.shared_strings_to_tuple(shared_strings)).to eq(expected_tuple)
    end
  end
end
