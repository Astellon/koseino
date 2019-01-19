require "spec"
require "../src/token.cr"

describe Token do
  describe ".regs" do
    it "match Integer" do
      "1234".match(Token.regs[Token::TokenKind::Integer]).nil?.should be_false
    end

    it "match Operator" do
      ["+", "-", "*", "\/"].each do |op| 
        op.match(Token.regs[Token::TokenKind::Operator]).nil?.should be_false
      end     
    end

    it "match Symbel" do
      ["(", ")"].each do |sym|
        sym.match(Token.regs[Token::TokenKind::Symbols]).nil?.should be_false
      end
    end
  end
end