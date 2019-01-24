require "./token.cr"
require "./ast.cr"

module Koseino
  class Parser
    def parse_factor(tokens, pos)
      if tokens[pos].kind == TokenKind::Integer
        return Node.new(ASTType::Factor, Leaf.new(ASTType::Integer, tokens[pos])), pos
      elsif tokens[pos].literal == "("
        ast, pos = parse_expr(tokens, pos + 1)
        pos += 1 # skip ")"
        return Node.new(ASTType::Factor, ast), pos
      elsif tokens[pos].kind == TokenKind::Identifier
        id = Leaf.new(ASTType::Identifier, tokens[pos])
        arg, pos = parse_expr(tokens, pos + 2)
        return Node.new(ASTType::Factor, id, arg), pos + 1
      else
        puts "unknown token in parse_factor"
        exit 1
      end
    end

    def parse_mul_expr(tokens, pos)
      if tokens[pos].kind == TokenKind::Integer || tokens[pos].literal == "(" || tokens[pos].kind == TokenKind::Identifier
        lhs, pos = parse_factor(tokens, pos)
        ast = Node.new(ASTType::MulExpr, lhs)
        while tokens[pos + 1].kind != TokenKind::EOL
          if tokens[pos + 1].literal != "*" && tokens[pos + 1].literal != "/"
            break
          end
          op = Leaf.new(ASTType::Operator, tokens[pos + 1])
          rhs, pos = parse_factor(tokens, pos + 2)
          ast.add(op, rhs)
        end
        return ast, pos
      else
        puts "unkown token in parse_term"
        exit 1
      end
    end

    def parse_add_expr(tokens, pos)
      if tokens[pos].kind == TokenKind::Integer || tokens[pos].literal == "(" || tokens[pos].kind == TokenKind::Identifier
        lhs, pos = parse_mul_expr(tokens, pos)
        ast = Node.new(ASTType::AddExpr, lhs)
        while tokens[pos + 1].kind != TokenKind::EOL
          if tokens[pos + 1].literal != "+" && tokens[pos + 1].literal != "-"
            break
          end
          op = Leaf.new(ASTType::Operator, tokens[pos + 1])
          rhs, pos = parse_mul_expr(tokens, pos + 2)
          ast.add(op, rhs)
        end
        return ast, pos
      else
        puts "unkown token in parse"
        puts "@#{pos} tokens:#{tokens[pos]}"
        exit 1
      end
    end

    def parse_expr(token, pos)
      add_expr, pos = parse_add_expr(token, pos)
      return Node.new(ASTType::Expr, add_expr), pos
    end

    def parse(tokens, pos)
      expr, pos = parse_expr(tokens, pos)
      return Node.new(ASTType::Root, expr), pos
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
