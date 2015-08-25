defmodule ExcellentSpec do
  use ESpec

  describe "#read" do
    context "text only" do
      let :expected_output do
        [
          ["1.A1", "1.B1", "1.C1", "1.D1"],
          ["1.A2", "1.B2", "1.C2", "1.D2"],
          ["1.A3", "1.B3", "1.C3", "1.D3"],
          ["1.A4", "1.B4", "1.C4", "1.D4"],
          ["1.A5", "1.B5", "1.C5", "1.D5"],
        ]
      end

      it "returns contents as stream" do
        expect(Excellent.read('./spec/fixtures/test_spreadsheet.xlsx', 0)).to eq(expected_output)
      end
    end
  end

  describe "#worksheet_names" do
    it "returns worksheet names" do
      expect(Excellent.worksheet_names('./spec/fixtures/test_spreadsheet.xlsx')).to eq({"Text Only", "Mixed Types"})
    end
  end

  describe "#shared_strings_to_tuple" do
    let :shared_strings do
      """
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <sst count="28" uniqueCount="28" xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
        <si>
          <t>1.A1</t>
        </si>
        <si>
          <t>1.B1</t>
        </si>
        <si>
          <t>1.C1</t>
        </si>
        <si>
          <t>1.D1</t>
        </si>
        <si>
          <t>1.A2</t>
        </si>
        <si>
          <t>1.B2</t>
        </si>
        <si>
          <t>1.C2</t>
        </si>
        <si>
          <t>1.D2</t>
        </si>
        <si>
          <t>1.A3</t>
        </si>
        <si>
          <t>1.B3</t>
        </si>
        <si>
          <t>1.C3</t>
        </si>
        <si>
          <t>1.D3</t>
        </si>
        <si>
          <t>1.A4</t>
        </si>
        <si>
          <t>1.B4</t>
        </si>
        <si>
          <t>1.C4</t>
        </si>
        <si>
          <t>1.D4</t>
        </si>
        <si>
          <t>1.A5</t>
        </si>
        <si>
          <t>1.B5</t>
        </si>
        <si>
          <t>1.C5</t>
        </si>
        <si>
          <t>1.D5</t>
        </si>
        <si>
          <t>2.A1</t>
        </si>
        <si>
          <t>2.B1</t>
        </si>
        <si>
          <t>2.C1</t>
        </si>
        <si>
          <t>2.D1</t>
        </si>
        <si>
          <t>Text</t>
        </si>
        <si>
          <t>Text with Encodingßäôé</t>
        </si>
        <si>
          <t>Text with Number 123</t>
        </si>
        <si>
          <t>Text with Newline


      And so on</t>
        </si>
      </sst>
      """
    end

    let :expected_tuple do
      {
        "1.A1", "1.B1", "1.C1", "1.D1",
        "1.A2", "1.B2", "1.C2", "1.D2",
        "1.A3", "1.B3", "1.C3", "1.D3",
        "1.A4", "1.B4", "1.C4", "1.D4",
        "1.A5", "1.B5", "1.C5", "1.D5",
        "2.A1", "2.B1", "2.C1", "2.D1",
        "Text",
        "Text with Encodingßäôé",
        "Text with Number 123",
        "Text with Newline\n\n\nAnd so on"
      }
    end

    it "returns expected tuple" do
      expect(Excellent.shared_strings_to_tuple(shared_strings)).to eq(expected_tuple)
    end
  end
end
