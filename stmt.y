           top_stmts: separated_by<Item = _stmt_or_begin, Sep = _terms>

              _stmts: separated_by<Item = _stmt_or_begin, Sep = _terms>

            compstmt: _stmts opt_terms

            bodystmt: compstmt opt_rescue maybe2<T1 = 'else', T2 = compstmt> maybe2<T1 = 'ensure', T2 = compstmt>

      _stmt_or_begin: stmt
                    | preexe

                    // Statement is assignable if it is:
                    // 1. backref
                    // 2. local/instance/class/global variable
                    // 3. constant (with **any** scope)
                    // 4. indexasgn
                    // 5. fcall
                    //
                    // Statement is primary if it is:
                    // 1. literal (numer/sym/str/array/hash)
                    // 2. local/instance/class/global variable
                    // 3. backref
                    // 4. tFID-based method call
                    // 5. begin..end
                    // 6. (stmt/compstmt/nothing)
                    // 7. global constant or const defined on a primary
                    // 8. not (expr?)
                    // 9. fcall maybe with brace block if receiver is also primry
                    // 10. super/yield in fcall mode
                    // 11. break/next/redo/retry with no arguments
                    // 12. lambda
                    // 13. if/unless statement
                    // 14. for loop
                    // 15. while/until statements
                    // 16. class/module definition
                    // 17. standard method definition statement
                    // 18. indexasgn if receiver is also primary
                    //
                    // Statement is an argument ALWAYS if it's not:
                    // 1. command (i.e. a method call with argument but without parentheses)
                    // 2. 'not expr'
                    // 3. '!' command
                    // 4. '=>' or 'in' one-line pattern-matching
                    // 5. binary operation 'and' / 'or'
                    // 6. super/yield/return/break/next in command mode
                    //
                    // Statement is an expression ALWAYS if it's not:
                    // 1. mass-assignment
                    // 2. alias/undef/postexe
                stmt: _stmt_head maybe1<T = _stmt_tail>

                expr: stmt // statement must be expression

          _stmt_head: alias
                    | undef
                    | postexe
                    |
                    | endless_method_def<Return = command>
                    |
                    | expr '=' command_rhs // expr must be assignable
                    | expr '=' mrhs // expr must be assignable
                    | expr tOP_ASGN command_rhs // expr must be assignable
                    |
                    | mlhs '=' command_call
                    | mlhs '=' mrhs maybe2<T1 = 'rescue', T2 = stmt>
                    | mlhs '=' expr maybe2<T1 = 'rescue', T2 = stmt> // expr must be argument
                    |
                    | _stmt0
                    |
                    | expr '..'  expr // LHS and RHS must be arguments
                    | expr '...' expr // LHS and RHS must be arguments
                    | expr '+'   expr // LHS and RHS must be arguments
                    | expr '-'   expr // LHS and RHS must be arguments
                    | expr '*'   expr // LHS and RHS must be arguments
                    | expr '/'   expr // LHS and RHS must be arguments
                    | expr '%'   expr // LHS and RHS must be arguments
                    | expr '**'  expr // LHS and RHS must be arguments
                    | expr '|'   expr // LHS and RHS must be arguments
                    | expr '^'   expr // LHS and RHS must be arguments
                    | expr '&'   expr // LHS and RHS must be arguments
                    | expr '<=>' expr // LHS and RHS must be arguments
                    | expr '=='  expr // LHS and RHS must be arguments
                    | expr '===' expr // LHS and RHS must be arguments
                    | expr '!='  expr // LHS and RHS must be arguments
                    | expr '=~'  expr // LHS and RHS must be arguments
                    | expr '!~'  expr // LHS and RHS must be arguments
                    | expr '<<'  expr // LHS and RHS must be arguments
                    | expr '>>'  expr // LHS and RHS must be arguments
                    | expr '&&'  expr // LHS and RHS must be arguments
                    | expr '||'  expr // LHS and RHS must be arguments
                    | expr '>'   expr // LHS and RHS must be arguments
                    | expr '<'   expr // LHS and RHS must be arguments
                    | expr '>='  expr // LHS and RHS must be arguments
                    | expr '<='  expr // LHS and RHS must be arguments
                    |
                    | expr '..'       // expr must be argument
                    | expr '...'      // expr must be argument
                    |
                    | '..'  expr     // expr must be argument
                    | '...' expr     // expr must be argument
                    | '+'   expr     // expr must be argument
                    | '-'   expr     // expr must be argument
                    | '!'   expr     // expr must be argument or command
                    | '~'   expr     // expr must be argument
                    |
                    | 'not' expr     // expr must be expression
                    |
                    | 'defined?' expr // expr must be argument
                    |
                    | '-' simple_numeric '**' expr // expr must be argument
                    |
                    | expr '?' expr ':' expr // LHS, MHS and RHS must be arguments
                    |
                    | expr 'and' expr // both must be expressions
                    | expr 'or'  expr // both must be expressions
                    |
                    | expr '=>' p_top_expr_body // LHS must be argument
                    | expr 'in' p_top_expr_body // LHS must be argument

              _stmt0: operation_t args           maybe_brace_block maybe_command_block
                    | operation_t opt_paren_args maybe_brace_block
                    |
                    | literal
                    | array
                    | hash
                    | var_ref
                    | backref
                    | tFID
                    | 'begin' bodystmt 'end'
                    | '(' ')'
                    | '(' stmt ')'
                    | '(' compstmt ')'
                    | '::' tCONSTANT
                    | 'not' '(' expr ')'
                    | 'not' '(' ')'
                    |
                    | lambda
                    |
                    | if_stmt
                    | unless_stmt
                    |
                    | 'while'  expr do_t compstmt 'end'
                    | 'until'  expr do_t compstmt 'end'
                    |
                    | case
                    |
                    | for_loop
                    |
                    | class
                    | module
                    |
                    | method_def
                    |
                    | keyword_cmd
                    |
                    | expr repeat1<T = _stmt_call_tail>
                    |
                    | expr _assignment_t _assignment_rhs // expr must be assignable
                    |
                    | endless_method_def<Return = expr> // expr must be argument

     _stmt_call_tail: '::' tCONSTANT
                    |
                    | '::' operation2_t paren_args maybe_brace_block
                    | '::' operation2_t       args maybe_brace_block maybe_command_block // cannot be chained because of open args
                    |
                    | '::' operation3_t            maybe_brace_block
                    |
                    | '::'              paren_args maybe_brace_block
                    |
                    | call_op_t operation2_t opt_paren_args maybe_brace_block
                    | call_op_t operation2_t           args maybe_brace_block maybe_command_block // cannot be chained because of open args
                    | call_op_t                  paren_args maybe_brace_block
                    |
                    | _aref_args maybe_brace_block

                    // There must be runtime validations:
                    // 1. trailing ',' is allowed only if arglist is not empty
          _aref_args: '[' maybe1<T = args> maybe1<T = ','> ']'

    _assignment_rhs: expr repeat2<T1 = 'rescue', T2 = expr> // all expressions must be arguments

       _assignment_t: '='
                    | tOP_ASGN

          _stmt_tail: 'if'     expr
                    | 'unless' expr
                    | 'while'  expr
                    | 'until'  expr
                    | 'rescue' stmt

           opt_terms: maybe1<T = _terms>

              _terms: separated_by<Item = term_t, Sep = ';'>
