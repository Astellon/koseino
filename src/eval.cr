require "./ast.cr"

module Koseino
  class Evaluater
    @io : IO

    def initialize(@io) end

    def eval(ast : Node)
      return eval_expr(ast.children[0])
    end

    def eval_expr(ast : Node)
      return eval_add_expr(ast.children[0])
    end

    def eval_add_expr(ast : Node)
      lhs = eval_mul_expr(ast.children[0])  # first argument
      return lhs if ast.children.size == 1
      
      pos = 1  # look operator
      while pos < ast.children.size
        if ast.children[pos].token.literal == "+"
          lhs += eval_mul_expr(ast.children[pos+1])
        elsif ast.children[pos].token.literal == "-"
          lhs -= eval_mul_expr(ast.children[pos+1])
        end
        pos += 2
      end
      return lhs
    end

    def eval_mul_expr(ast : Node)
      lhs = eval_factor(ast.children[0])  # first argument
      return lhs if ast.children.size == 1
      
      pos = 1  # look operator
      while pos < ast.children.size
        if ast.children[pos].token.literal == "*"
          lhs *= eval_factor(ast.children[pos+1])
        elsif ast.children[pos].token.literal == "/"
          lhs /= eval_factor(ast.children[pos+1])
        end
        pos += 2
      end
      return lhs
    end

    def eval_factor(ast : Node)
      if ast.children[0].ast_type == ASTType::Integer
        return ast.children[0].token.literal.to_i64
      elsif ast.children[0].ast_type == ASTType::Identifier
        if ast.children[0].token.literal == "print"
          str = eval_expr(ast.children[1]).to_s
          @io.puts str
          return str.size
        end
      elsif ast.children[0].ast_type == ASTType::Expr
        return eval_expr(ast.children[0])
      else
        puts "unknown ast #{ast.children[0].ast_type}"
        exit 1
      end
      return 0  # not retru nil
    end
  end
end