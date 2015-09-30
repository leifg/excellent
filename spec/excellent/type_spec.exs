defmodule TypeSpec do
  use ESpec

  describe "#from_string" do
    context "string" do
      let :type, do: "string"
      let :input, do: "a string"
      let :expected_output, do: "a string"

      it "returns the same string" do
        expect(Excellent.Type.from_string(input, %{type: type})).to eq(expected_output)
      end
    end

    context "boolean" do
      let :type, do: "boolean"

      context "true" do
        let :input, do: "1"
        let :expected_output, do: true

        it "returns true" do
          expect(Excellent.Type.from_string(input, %{type: type})).to eq(expected_output)
        end
      end

      context "false" do
        let :input, do: "0"
        let :expected_output, do: false

        it "returns false" do
          expect(Excellent.Type.from_string(input, %{type: type})).to eq(expected_output)
        end
      end
    end

    context "number" do
      let :type, do: "number"

      context "int" do
        let :expected_output, do: 1
        let :input, do: "1"

        it "returns the expected output" do
          expect(Excellent.Type.from_string(input, %{type: type})).to eq(expected_output)
        end
      end

      context "float" do
        let :input, do: "123.456"
        let :expected_output, do: 123.456

        it "returns the expected output" do
          expect(Excellent.Type.from_string(input, %{type: type})).to eq(expected_output)
        end
      end
    end

    context "date" do
      let :expected_output, do: {{2011, 8, 24}, {10, 35, 17}}
      let :type, do: "date"

      context "float" do
        let :input, do: 40779.4411689815

        it "returns the expected output" do
          expect(Excellent.Type.from_string(input, %{type: type})).to eq(expected_output)
        end
      end

      context "string" do
        let :input, do: "40779.4411689815"

        it "returns the expected output" do
          expect(Excellent.Type.from_string(input, %{type: type})).to eq(expected_output)
        end
      end
    end

    context "shared_string" do
      let :type, do: "shared_string"
      let :lookup, do: {"zero", "one", "two"}
      let :expected_output, do: "two"

      context "input is int" do
        let :input, do: 2

        it "returns the expected output" do
          expect(Excellent.Type.from_string(input, %{type: type, lookup: lookup})).to eq(expected_output)
        end
      end

      context "input is string" do
        let :input, do: "2"

        it "returns the expected output" do
          expect(Excellent.Type.from_string(input, %{type: type, lookup: lookup})).to eq(expected_output)
        end
      end
    end
  end
end
