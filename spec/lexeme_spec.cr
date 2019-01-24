require "spec"
require "../src/lexeme.cr"

describe Koseino::Lexer do
  describe "#parse" do
    it "1+1" do
      lexer = Koseino::Lexer.new
      lexer.parse("1+1")
      lexer.tokens.size.should eq 4
    end

    it "1-1*1" do
      lexer = Koseino::Lexer.new
      lexer.parse("1-1*1")
      lexer.tokens.size.should eq 6
    end

    it "1+1*(1+1)-1/1" do
      lexer = Koseino::Lexer.new
      lexer.parse("1+1*(1+1)-1/1")
      lexer.tokens.size.should eq 14
    end

    it "print 1+1*(1+1)-1/1" do
      lexer = Koseino::Lexer.new
      lexer.parse("print 1+1*(1+1)-1/1")
      lexer.tokens.size.should eq 15
    end
  end
end
