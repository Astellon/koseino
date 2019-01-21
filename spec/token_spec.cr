require "spec"
require "../src/token.cr"

describe Koseino::Token do
  describe ".regs" do
    it "match Identifier" do
      "print".match(Koseino.regs[Koseino::TokenKind::Identifier]).nil?.should be_false
      "12345".match(Koseino.regs[Koseino::TokenKind::Identifier]).nil?.should be_true
    end

    it "match Integer" do
      "print".match(Koseino.regs[Koseino::TokenKind::Integer]).nil?.should be_true
      "12345".match(Koseino.regs[Koseino::TokenKind::Integer]).nil?.should be_false
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