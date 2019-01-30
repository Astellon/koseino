module Koseino
  enum TokenKind
    None
    Integer
    Operator
    Symbols
    Assign
    Identifier
    # other tokens ...
    EOL # end of line
  end

  @@regs = {
    TokenKind::Integer    => /[1-9][0-9]*/,
    TokenKind::Operator   => /[+|\-|*|\/]/,
    TokenKind::Symbols    => /[\(|\)]/, 
    TokenKind::Assign     => /[=]/,
    TokenKind::Identifier => /[A-Z|a-z]+/,
    # other tokens ...
  }

  def self.regs
    @@regs
  end

  class Token
    getter literal : String
    getter kind : TokenKind

    def initialize(@literal, @kind)
    end
  end # class Token

end # module Token
