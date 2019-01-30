require "option_parser"

require "./token.cr"
require "./lexeme.cr"
require "./ast.cr"
require "./parser.cr"
require "./eval.cr"

module Koseino
  VERSION = "0.1.0"

  debug = false

  # main program

  # parse flag
  OptionParser.parse! do |parser|
    parser.banner = "usege: koseino filename [ -flag ]"
    parser.on("-d", "--debug", "show debug log") { debug = true }
  end

  # get file name
  fn = ""
  ext = ".ksn"

  ARGV.each do |arg|
    if arg.ends_with?(ext)
      if fn == ""
        fn = arg
      else
        abort("get 2 and more files")
      end
    end
  end

  abort("no target file") if fn == ""

  # instances
  lexer = Lexer.new
  parser = Parser.new
  evaluater = Evaluater.new

  # read file and lexeme analysis
  File.open(fn) do |io|
    io.each_line do |line|
      lexer.parse(line)
    end
  end

  # ===== debug =====
  lexer.dumpTokens if debug
  # =================

  # parse tokens
  root, pos = parser.parse(lexer.tokens, 0)

  # ===== debug =====
  parser.dumpAST(root, 0) if debug
  # =================

  # eval ast
  evaluater.eval(root)
end
