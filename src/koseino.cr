require "./lexeme.cr"
require "./ast.cr"
require "./parser.cr"

module Koseino
  VERSION = "0.1.0"
  
  lexer = Lexer.new
  filename = ARGV[0]
  
  # read file
  File.open(filename) do |io|
    io.each_line do |line|
      lexer.parse(line)
    end
  end
  
  ## ===== debug =====
  lexer.dumpTokens()
  ## =================
  
  parser = Parser.new
  
  root, pos = parser.parse(lexer.tokens, 0)
  
  parser.dumpAST(root, 0)
end