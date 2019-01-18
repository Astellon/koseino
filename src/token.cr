module Token

  enum TokenKind
    Integer
    Operator
    Symbols
    # other tokens ...
    EOL  # end of line
  end

  @@regs = {
    TokenKind::Integer  => /[1-9][0-9]*/,
    TokenKind::Operator => /[+|\-|*|\/]/,
    TokenKind::Symbols  => /[\(\)]/
    # other tokens ...
  }
  
  def self.regs()
    @@regs
  end
  
  class Token
    getter literal : String
    getter kind    : TokenKind
    def initialize(@literal, @kind) end
  end  # class Token

end  # module Token