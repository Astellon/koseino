require "./token.cr"
require "./ast.cr"

module Parser

  class Parser

    def parse_factor(tokens, pos)
      if tokens[pos].kind == Token::TokenKind::Integer
        return AST::Leaf.new(AST::ASTType::Integer, tokens[pos]), pos
      elsif tokens[pos].literal == "("
        ast, pos = parse_expr(tokens, pos+1)
        pos += 1  # skip ")"
        return ast, pos
      else
        puts "unknown token in parse_factor"
        exit 1
      end
    end
    
    
    def parse_term(tokens, pos)
      if tokens[pos].kind == Token::TokenKind::Integer || tokens[pos].literal == "("
        lhs, pos = parse_factor(tokens, pos)
        while tokens[pos+1].kind != Token::TokenKind::EOL
          if tokens[pos+1].literal != "*" && tokens[pos+1].literal != "/"
            break
          end
          op  = AST::Leaf.new(AST::ASTType::Operator, tokens[pos+1])
          rhs, pos = parse_factor(tokens, pos+2)
          lhs = AST::Node.new(AST::ASTType::MulExpr, lhs, op, rhs)
        end
        return lhs, pos
      else
        puts "unkown token in parse_term"
        exit 1
      end
    end
     
    def parse_expr(tokens, pos)
      if tokens[pos].kind == Token::TokenKind::Integer || tokens[pos].literal == "("
        lhs, pos = parse_term(tokens, pos)
        while tokens[pos+1].kind != Token::TokenKind::EOL
          if tokens[pos+1].literal != "+" && tokens[pos+1].literal != "-"
            break
          end
          op  = AST::Leaf.new(AST::ASTType::Operator, tokens[pos+1])
          rhs, pos = parse_term(tokens, pos+2)
          lhs = AST::Node.new(AST::ASTType::AddExpr, lhs, op, rhs)
        end
        return lhs, pos
      else
        puts "unkown token in parse"
        puts "@#{pos} tokens:#{tokens[pos]}"
        exit 1
      end
    end
    
    def parse(tokens, pos)
      expr, pos = parse_expr(tokens, pos)
      return AST::Node.new(AST::ASTType::Expr, expr), pos
    end

    def dumpAST(ast, depth)
      puts "#{" "*depth}+- #{ast.try &.ast_type}"
      return if ast.nil?
      ast.children.each do |child|
        dumpAST(child, depth+1)
      end
    end
    
    def dumpAST(ast : AST::Leaf, depth)
      puts "#{" "*depth}+- #{ast.try &.ast_type} #{ast.try &.token.literal}"
    end

  end  # class Parser

end  # module Parser