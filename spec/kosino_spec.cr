require "spec"
# avoid executing top level programm
# require "../src/koseino.cr"

# equiv

require "../src/token.cr"
require "../src/lexeme.cr"
require "../src/ast.cr"
require "../src/parser.cr"
require "../src/eval.cr"

describe Koseino do
  describe "evaluate" do
    it "print(1+1+1+1)" do
      io = IO::Memory.new
      t = Koseino::Lexer.new.parse("print(1+1+1+1)").tokens
      root, pos = Koseino::Parser.new.parse(t, 0)
      Koseino::Evaluater.new(io).eval(root)
      io.to_s.should eq "4\n"
    end

    it "print(10*2-(5+5)*2+10)" do
      io = IO::Memory.new
      t = Koseino::Lexer.new.parse("print(10*2-(5+5)*2+10)").tokens
      root, pos = Koseino::Parser.new.parse(t, 0)
      Koseino::Evaluater.new(io).eval(root)
      io.to_s.should eq "10\n"
    end
  end
end
