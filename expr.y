                    // Expression is an argument ALWAYS if it's not:
                    // 1. command (i.e. a method call with argument but without parentheses)
                    // 2. 'not expr'
                    // 3. '!' command
                    // 4. '=>' or 'in' one-line pattern-matching
                    // 5. binary operation 'and' / 'or'
                    // 6. super/yield/return/break/next in command mode
                    //
                    // Expression is assignable if it is:
                    // 1. backref
                    // 2. local variable
                    // 3. constant (with **any** scope)
                    // 4. instance variable
                    // 5. class variable
                    // 6. global variable
                    // 7. indexasgn
                    // 8. method call without arguments
                expr: operation_t args maybe1<T = brace_block> _command_block_tail
                    | 'super'  args _command_block_tail
                    | 'yield'  args _command_block_tail
                    | 'return' args _command_block_tail
                    | 'break'  args _command_block_tail
                    | 'next'   args _command_block_tail
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
                    | operation_t maybe1<T = paren_args> maybe1<T = brace_block>
                    |
                    | 'super' maybe1<T = paren_args> maybe1<T = brace_block>
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
                    | _keyword_cmd
                    |
                    | expr repeat1<T = _expr_call_tail>
                    |
                    | expr call_op_t operation2_t args maybe1<T = brace_block> _command_block_tail
                    | expr '::' operation2_t args maybe1<T = brace_block> _command_block_tail
                    | expr maybe1<T = _expr_assignment_tail> // expr must be assignable
                    |
                    | endless_method_def<Return = expr> // expr must be argument
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
                    | '!'   expr     // expr must be argument
                    | '~'   expr     // expr must be argument
                    |
                    | 'not' expr
                    |
                    | '-' simple_numeric '**' expr // expr must be argument
                    |
                    | 'defined?' expr // expr must be argument
                    |
                    | expr '?' expr ':' expr // LHS, MHS and RHS must be arguments
                    |
                    | expr 'and' expr
                    | expr 'or'  expr
                    |
                    | expr '=>' p_top_expr_body // LHS must be argument
                    | expr 'in' p_top_expr_body // LHS must be argument

     _expr_call_tail: '::' tCONSTANT
                    | '::' operation2_t paren_args maybe1<T = brace_block>
                    | '::' operation3_t            maybe1<T = brace_block>
                    | '::'              paren_args maybe1<T = brace_block>
                    | call_op_t operation2_t opt_paren_args maybe1<T = brace_block>
                    | call_op_t                  paren_args maybe1<T = brace_block>
                    | _aref_args maybe1<T = brace_block>

                    // There must be runtime validations:
                    // 1. trailing ',' is allowed only if arglist is not empty
          _aref_args: '[' maybe1<T = args> maybe1<T = ','> ']'

        _keyword_cmd: 'break'
                    | 'next'
                    | 'redo'
                    | 'retry'
                    | 'return'
                    | 'yield' '(' args ')'
                    | 'yield' '(' ')'
                    | 'yield'
                    | 'defined?' '(' expr ')'

 _command_block_tail: maybe1<T = _command_block>

 _expr_assignment_tail: _expr_assignment_t expr repeat2<T1 = 'rescue', T2 = expr> // all expressions must be arguments

  _expr_assignment_t: '='
                    | tOP_ASGN
