require "spec"
require "../src/lexeme.cr"

describe Lexeme::Lexer do
  describe "#parse" do
    it "1+1" do
      lexer = Lexeme::Lexer.new
      lexer.parse("1+1")
      lexer.tokens.size.should eq 4
    end

    it "1-1*1" do
      lexer = Lexeme::Lexer.new
      lexer.parse("1-1*1")
      lexer.tokens.size.should eq 6
    end

    it "1+1*(1+1)-1/1" do
      lexer = Lexeme::Lexer.new
      lexer.parse("1+1*(1+1)-1/1")
      lexer.tokens.size.should eq 14
    end
  end
end