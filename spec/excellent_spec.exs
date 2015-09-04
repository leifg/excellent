defmodule ExcellentSpec do
  use ESpec

  describe "#parse" do
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
        expect(Excellent.parse('./spec/fixtures/test_spreadsheet.xlsx', 0)).to eq(expected_output)
      end
    end

    context "mixed types" do
      let :expected_output do
        [
          ["2.A1", "2.B1", "2.C1", "2.D1"],
          ["Text", 123, {{2011, 8, 24}, {10, 35, 17}}, true],
          ["Text with Encodingßäôé", 123.456, {{2008, 2, 29}, {0, 0, 0}}, false],
          ["Text with Number 123", 17.23, {{2106, 2, 10}, {23, 19, 17}}, true],
          ["Text with Newline\n\n\nAnd so on", 53.19, {{1965, 11, 10}, {0, 0, 0}}, false],
        ]
      end

      it "returns contents as stream" do
        expect(Excellent.parse('./spec/fixtures/test_spreadsheet.xlsx', 1)).to eq(expected_output)
      end
    end
  end

  describe "#worksheet_names" do
    it "returns worksheet names" do
      expect(Excellent.worksheet_names('./spec/fixtures/test_spreadsheet.xlsx')).to eq({"Text Only", "Mixed Types"})
    end
  end
end
