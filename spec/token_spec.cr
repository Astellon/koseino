require "spec"
require "../src/token.cr"

describe Koseino::Token do
  describe ".regs" do
    it "match Integer" do
      "1234".match(Koseino.regs[Koseino::TokenKind::Integer]).nil?.should be_false
    end

    it "match Operator" do
      ["+", "-", "*", "\/"].each do |op| 
        op.match(Koseino.regs[Koseino::TokenKind::Operator]).nil?.should be_false
      end     
    end

    it "match Symbel" do
      ["(", ")"].each do |sym|
        sym.match(Koseino.regs[Koseino::TokenKind::Symbols]).nil?.should be_false
      end
    end
  end
end