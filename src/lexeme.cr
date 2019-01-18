require "./token.cr"

module Lexeme

  class Lexer
    
    getter tokens
    
    def initialize()
      @tokens = Array(Token::Token).new
    end

    private def skipwhitespace(str)
      str.sub(/^[\s|\t]*/, "")
    end

    private def match(str, regs)
      regs.each do |key, value|
        m = str.match(/^#{value}/)
        next if m.nil?
        return key, m[0]
      end
      puts "Unknow Token #{str}"
      exit 1
    end

    def parse(line)
      # remove indent
      line = skipwhitespace(line)

      while !line.empty?
        key, token = match(line, Token.regs)
      
        @tokens.push(Token::Token.new(token, key))
        
        line = line[token.size...line.size]
        line = skipwhitespace(line)  
      end

      # end of line token
      @tokens.push(Token::Token.new("$", Token::TokenKind::EOL))
    end

    def dumpTokens()
      @tokens.each do |tk|
        puts "#{tk.kind}: #{tk.literal}"
      end
    end
  
  end  # class Lexer

end  # module Lexeme