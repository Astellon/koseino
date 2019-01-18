require "./token.cr"

module AST
  enum ASTType
    Expr
    AddExpr
    MulExpr
    Operator
    Integer
  end

  class Node
    
    getter ast_type : ASTType
    getter children = Array(Node).new
    
    def initialize(ast_type, *children)
      @ast_type = ast_type
      children.each do |child|
        next if child.nil?
        @children.push(child)
      end
    end
  end

  class Leaf < Node
    getter token : Token::Token
    def initialize(ast_type, token)
      @ast_type = ast_type
      @token = token
    end
  end

end