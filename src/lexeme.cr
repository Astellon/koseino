module Koseino
  class Lexer
    getter tokens

    def initialize
      @tokens = Array(Token).new
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
      abort("Unknow Token #{str}")
    end

    def parse(line)
      # remove indent
      line = skipwhitespace(line)

      while !line.empty?
        key, token = match(line, Koseino.regs)

        @tokens.push(Token.new(token, key))

        line = line[token.size...line.size]
        line = skipwhitespace(line)
      end

      # end of line token
      @tokens.push(Token.new("$", TokenKind::EOL))
      return self
    end

    def dumpTokens
      i = 0
      @tokens.each do |tk|
        puts "#{i}: #{tk.kind}: #{tk.literal}"
        i += 1
      end
    end
  end # class Lexer

end # module Lexeme
