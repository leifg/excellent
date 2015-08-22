defmodule ExcellentSpec do
  use ESpec

  describe "#worksheet_names" do
    it "returns worksheet names" do
      expect(Excellent.worksheet_names('./spec/fixtures/simple_example.xlsx')).to eq(['Bibelbund_Abfrage'])
    end
  end
end
