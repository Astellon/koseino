module Koseino
  class Parser
    def parse_factor(tokens, pos)
      if tokens[pos].kind == TokenKind::Integer
        return Node.new(ASTType::Factor, Leaf.new(ASTType::Integer, tokens[pos])), pos + 1
      elsif tokens[pos].literal == "("
        ast, pos = parse_expr(tokens, pos + 1)
        return Node.new(ASTType::Factor, ast), pos + 1 # skip ")"
      elsif tokens[pos].kind == TokenKind::Identifier
        id = Leaf.new(ASTType::Identifier, tokens[pos])
        if tokens[pos+1].literal == "("
          arg, pos = parse_expr(tokens, pos + 2)
          return Node.new(ASTType::Factor, id, arg), pos + 1
        end
        return Node.new(ASTType::Factor, id), pos + 1
      else
        abort("unkown token @#{pos} token:#{tokens[pos].literal}")
      end
    end

    def parse_mul_expr(tokens, pos)
      if tokens[pos].kind == TokenKind::Integer || tokens[pos].literal == "(" || tokens[pos].kind == TokenKind::Identifier
        lhs, pos = parse_factor(tokens, pos)
        ast = Node.new(ASTType::MulExpr, lhs)
        while tokens[pos].kind != TokenKind::EOL
          if tokens[pos].literal != "*" && tokens[pos].literal != "/"
            break
          end
          op = Leaf.new(ASTType::Operator, tokens[pos])
          rhs, pos = parse_factor(tokens, pos + 1)
          ast.add(op, rhs)
        end
        return ast, pos
      else
        abort("unkown token @#{pos} token:#{tokens[pos].literal}")
      end
    end

    def parse_add_expr(tokens, pos)
      if tokens[pos].kind == TokenKind::Integer || tokens[pos].literal == "(" || tokens[pos].kind == TokenKind::Identifier
        lhs, pos = parse_mul_expr(tokens, pos)
        ast = Node.new(ASTType::AddExpr, lhs)
        while tokens[pos].kind != TokenKind::EOL
          if tokens[pos].literal != "+" && tokens[pos].literal != "-"
            break
          end
          op = Leaf.new(ASTType::Operator, tokens[pos])
          rhs, pos = parse_mul_expr(tokens, pos + 1)
          ast.add(op, rhs)
        end
        return ast, pos
      else
        abort("unkown token @#{pos} token:#{tokens[pos].literal}")
      end
    end

    def parse_expr(tokens, pos)
      if tokens[pos].kind == TokenKind::Identifier && tokens[pos+1].kind == TokenKind::Assign
        id = Leaf.new(ASTType::Identifier, tokens[pos])
        value, pos = parse_expr(tokens, pos+2)
        assign = Node.new(ASTType::Assign, id, value)
        return Node.new(ASTType::Expr, assign), pos
      elsif tokens[pos].kind == TokenKind::Identifier  || tokens[pos].kind == TokenKind::Integer
        add_expr, pos = parse_add_expr(tokens, pos)
        return Node.new(ASTType::Expr, add_expr), pos
      else
        abort("unkown token @#{pos} token:#{tokens[pos].literal}")
      end
    end

    def parse(tokens, pos)
      root = Node.new(ASTType::Root)
      while pos < tokens.size
        expr, pos = parse_expr(tokens, pos)
        root.add(expr)
        pos += 1 # skip $
      end
      return root, pos
    end

    def dumpAST(ast, depth)
      puts "#{" "*depth}+- #{ast.try &.ast_type}"
      return if ast.nil?
      ast.children.each do |child|
        dumpAST(child, depth + 1)
      end
    end

    def dumpAST(ast : Leaf, depth)
      puts "#{" "*depth}+- #{ast.try &.ast_type} #{ast.try &.token.literal}"
    end
  end # class Parser

end # module Parser
