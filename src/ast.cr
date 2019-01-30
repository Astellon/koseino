module Koseino
  enum ASTType
    Root
    Expr
    AddExpr
    MulExpr
    Factor
    Operator
    Call
    Integer
    Identifier
  end

  class Node
    getter ast_type : ASTType
    getter token = Token.new("", TokenKind::None)
    getter children = Array(Node).new

    def initialize(ast_type, *children)
      @ast_type = ast_type
      children.each do |child|
        next if child.nil?
        @children.push(child)
      end
    end

    def add(*ast)
      ast.each do |child|
        next if child.nil?
        @children.push(child)
      end
    end
  end

  class Leaf < Node
    getter token : Token

    def initialize(@ast_type, @token)
    end
  end
end
