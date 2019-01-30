module Koseino
  class Evaluater
    def initialize(io : IO = STDOUT)
      @io = io
      @syms = SymbolTable.new
    end

    def eval(ast : Node)
      ast.children.each do |child|
        eval_expr(child)
      end
    end

    def eval_expr(ast : Node)
      if ast.children[0].ast_type == ASTType::Assign
        return eval_assign(ast.children[0])
      elsif ast.children[0].ast_type == ASTType::AddExpr
        return eval_add_expr(ast.children[0])
      else
        abort("unknown node of #{ast.ast_type}: #{ast.token.literal}")
      end
    end

    def eval_assign(ast : Node)
      name  = ast.children[0].token.literal
      value = eval_expr(ast.children[1])
      @syms << Identifier.new(name, value)
      return value
    end

    def eval_add_expr(ast : Node)
      lhs = eval_mul_expr(ast.children[0]) # first argument
      return lhs if ast.children.size == 1

      pos = 1 # look operator
      while pos < ast.children.size
        if ast.children[pos].token.literal == "+"
          lhs += eval_mul_expr(ast.children[pos + 1])
        elsif ast.children[pos].token.literal == "-"
          lhs -= eval_mul_expr(ast.children[pos + 1])
        end
        pos += 2
      end
      return lhs
    end

    def eval_mul_expr(ast : Node)
      lhs = eval_factor(ast.children[0]) # first argument
      return lhs if ast.children.size == 1

      pos = 1 # look operator
      while pos < ast.children.size
        if ast.children[pos].token.literal == "*"
          lhs *= eval_factor(ast.children[pos + 1])
        elsif ast.children[pos].token.literal == "/"
          lhs /= eval_factor(ast.children[pos + 1])
        end
        pos += 2
      end
      return lhs
    end

    def eval_factor(ast : Node)
      if ast.children[0].ast_type == ASTType::Integer
        return ast.children[0].token.literal.to_i32
      elsif ast.children[0].ast_type == ASTType::Identifier
        if ast.children[0].token.literal == "print"
          str = eval_expr(ast.children[1]).to_s
          @io.puts str
          return str.size
        else
          id = @syms.get(ast.children[0].token.literal)
          return id.value
        end
      elsif ast.children[0].ast_type == ASTType::Expr
        return eval_expr(ast.children[0])
      else
        abort("unknown node of #{ast.ast_type}: #{ast.token.literal}")
      end
      return 0 # not retru nil
    end
  end
end
