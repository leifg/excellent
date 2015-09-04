defmodule ParserSpec do
  use ESpec


  describe "#parse_shared_strings" do
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
          <t>Text with Newline&#10;&#10;&#10;And so on</t>
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
      expect(Excellent.Parser.parse_shared_strings(shared_strings)).to eq(expected_tuple)
    end
  end

  describe "#styles_to_tuple" do
    let :styles do
      """
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
        <numFmts count="4">
          <numFmt formatCode="GENERAL" numFmtId="164"/>
          <numFmt formatCode="YYYY\-MM\-DD" numFmtId="165"/>
          <numFmt formatCode="[$USD]0.00" numFmtId="166"/>
          <numFmt formatCode="[$€-2]0.00" numFmtId="167"/>
        </numFmts>
        <fonts count="6">
          <font>
            <sz val="10"/>
            <name val="Arial"/>
            <family val="2"/>
          </font>
          <font>
            <sz val="10"/>
            <name val="Arial"/>
            <family val="0"/>
          </font>
          <font>
            <sz val="10"/>
            <name val="Arial"/>
            <family val="0"/>
          </font>
          <font>
            <sz val="10"/>
            <name val="Arial"/>
            <family val="0"/>
          </font>
          <font>
            <sz val="10"/>
            <color rgb="FF000000"/>
            <name val="Arial"/>
            <family val="2"/>
            <charset val="1"/>
          </font>
          <font>
            <sz val="10"/>
            <name val="Arial"/>
            <family val="2"/>
            <charset val="1"/>
          </font>
        </fonts>
        <fills count="2">
          <fill>
            <patternFill patternType="none"/>
          </fill>
          <fill>
            <patternFill patternType="gray125"/>
          </fill>
        </fills>
        <borders count="1">
          <border diagonalDown="false" diagonalUp="false">
            <left/>
            <right/>
            <top/>
            <bottom/>
            <diagonal/>
          </border>
        </borders>
        <cellStyleXfs count="20">
          <xf applyAlignment="true" applyBorder="true" applyFont="true" applyProtection="true" borderId="0" fillId="0" fontId="0" numFmtId="164">
            <alignment horizontal="general" indent="0" shrinkToFit="false" textRotation="0" vertical="bottom" wrapText="false"/>
            <protection hidden="false" locked="true"/>
          </xf>
          <xf applyAlignment="false" applyBorder="false" applyFont="true" applyProtection="false" borderId="0" fillId="0" fontId="1" numFmtId="0"/>
          <xf applyAlignment="false" applyBorder="false" applyFont="true" applyProtection="false" borderId="0" fillId="0" fontId="1" numFmtId="0"/>
          <xf applyAlignment="false" applyBorder="false" applyFont="true" applyProtection="false" borderId="0" fillId="0" fontId="2" numFmtId="0"/>
          <xf applyAlignment="false" applyBorder="false" applyFont="true" applyProtection="false" borderId="0" fillId="0" fontId="2" numFmtId="0"/>
          <xf applyAlignment="false" applyBorder="false" applyFont="true" applyProtection="false" borderId="0" fillId="0" fontId="0" numFmtId="0"/>
          <xf applyAlignment="false" applyBorder="false" applyFont="true" applyProtection="false" borderId="0" fillId="0" fontId="0" numFmtId="0"/>
          <xf applyAlignment="false" applyBorder="false" applyFont="true" applyProtection="false" borderId="0" fillId="0" fontId="0" numFmtId="0"/>
          <xf applyAlignment="false" applyBorder="false" applyFont="true" applyProtection="false" borderId="0" fillId="0" fontId="0" numFmtId="0"/>
          <xf applyAlignment="false" applyBorder="false" applyFont="true" applyProtection="false" borderId="0" fillId="0" fontId="0" numFmtId="0"/>
          <xf applyAlignment="false" applyBorder="false" applyFont="true" applyProtection="false" borderId="0" fillId="0" fontId="0" numFmtId="0"/>
          <xf applyAlignment="false" applyBorder="false" applyFont="true" applyProtection="false" borderId="0" fillId="0" fontId="0" numFmtId="0"/>
          <xf applyAlignment="false" applyBorder="false" applyFont="true" applyProtection="false" borderId="0" fillId="0" fontId="0" numFmtId="0"/>
          <xf applyAlignment="false" applyBorder="false" applyFont="true" applyProtection="false" borderId="0" fillId="0" fontId="0" numFmtId="0"/>
          <xf applyAlignment="false" applyBorder="false" applyFont="true" applyProtection="false" borderId="0" fillId="0" fontId="0" numFmtId="0"/>
          <xf applyAlignment="false" applyBorder="false" applyFont="true" applyProtection="false" borderId="0" fillId="0" fontId="1" numFmtId="43"/>
          <xf applyAlignment="false" applyBorder="false" applyFont="true" applyProtection="false" borderId="0" fillId="0" fontId="1" numFmtId="41"/>
          <xf applyAlignment="false" applyBorder="false" applyFont="true" applyProtection="false" borderId="0" fillId="0" fontId="1" numFmtId="44"/>
          <xf applyAlignment="false" applyBorder="false" applyFont="true" applyProtection="false" borderId="0" fillId="0" fontId="1" numFmtId="42"/>
          <xf applyAlignment="false" applyBorder="false" applyFont="true" applyProtection="false" borderId="0" fillId="0" fontId="1" numFmtId="9"/>
        </cellStyleXfs>
        <cellXfs count="6">
          <xf applyAlignment="false" applyBorder="false" applyFont="false" applyProtection="false" borderId="0" fillId="0" fontId="0" numFmtId="164" xfId="0">
            <alignment horizontal="general" indent="0" shrinkToFit="false" textRotation="0" vertical="bottom" wrapText="false"/>
            <protection hidden="false" locked="true"/>
          </xf>
          <xf applyAlignment="false" applyBorder="true" applyFont="true" applyProtection="false" borderId="0" fillId="0" fontId="4" numFmtId="164" xfId="0">
            <alignment horizontal="general" indent="0" shrinkToFit="false" textRotation="0" vertical="bottom" wrapText="false"/>
            <protection hidden="false" locked="true"/>
          </xf>
          <xf applyAlignment="true" applyBorder="true" applyFont="true" applyProtection="false" borderId="0" fillId="0" fontId="5" numFmtId="164" xfId="0">
            <alignment horizontal="general" indent="0" shrinkToFit="false" textRotation="0" vertical="top" wrapText="true"/>
            <protection hidden="false" locked="true"/>
          </xf>
          <xf applyAlignment="true" applyBorder="true" applyFont="true" applyProtection="false" borderId="0" fillId="0" fontId="5" numFmtId="165" xfId="0">
            <alignment horizontal="general" indent="0" shrinkToFit="false" textRotation="0" vertical="top" wrapText="true"/>
            <protection hidden="false" locked="true"/>
          </xf>
          <xf applyAlignment="true" applyBorder="true" applyFont="true" applyProtection="false" borderId="0" fillId="0" fontId="5" numFmtId="166" xfId="0">
            <alignment horizontal="general" indent="0" shrinkToFit="false" textRotation="0" vertical="top" wrapText="true"/>
            <protection hidden="false" locked="true"/>
          </xf>
          <xf applyAlignment="true" applyBorder="true" applyFont="true" applyProtection="false" borderId="0" fillId="0" fontId="5" numFmtId="167" xfId="0">
            <alignment horizontal="general" indent="0" shrinkToFit="false" textRotation="0" vertical="top" wrapText="true"/>
            <protection hidden="false" locked="true"/>
          </xf>
        </cellXfs>
        <cellStyles count="6">
          <cellStyle builtinId="0" customBuiltin="false" name="Normal" xfId="0"/>
          <cellStyle builtinId="3" customBuiltin="false" name="Comma" xfId="15"/>
          <cellStyle builtinId="6" customBuiltin="false" name="Comma [0]" xfId="16"/>
          <cellStyle builtinId="4" customBuiltin="false" name="Currency" xfId="17"/>
          <cellStyle builtinId="7" customBuiltin="false" name="Currency [0]" xfId="18"/>
          <cellStyle builtinId="5" customBuiltin="false" name="Percent" xfId="19"/>
        </cellStyles>
      </styleSheet>
      """
    end

    let :expected_tuple do
      { "GENERAL", "GENERAL", "GENERAL", "YYYY\-MM\-DD", "[$USD]0.00", "[$€-2]0.00"}
    end

    it "returns expected tuple" do
      expect(Excellent.Parser.parse_styles(styles)).to eq(expected_tuple)
    end
  end
end
