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
                    //
                    // Expression is primary if it is:
                    // 1. literal (numer/sym/str/array/hash)
                    // 2. variable
                    // 3. backref
                    // 4. tFID-based expression
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
                expr: _expr0
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
                    | 'not' expr
                    |
                    | 'defined?' expr // expr must be argument
                    |
                    | '-' simple_numeric '**' expr // expr must be argument
                    |
                    | expr '?' expr ':' expr // LHS, MHS and RHS must be arguments
                    |
                    | expr 'and' expr
                    | expr 'or'  expr
                    |
                    | expr '=>' p_top_expr_body // LHS must be argument
                    | expr 'in' p_top_expr_body // LHS must be argument

              _expr0: operation_t args           maybe_brace_block maybe_command_block
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
                    | expr repeat1<T = _expr_call_tail>
                    |
                    | expr _assignment_t _assignment_rhs // expr must be assignable
                    |
                    | endless_method_def<Return = expr> // expr must be argument

     _expr_call_tail: '::' tCONSTANT
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
                    |

                    // There must be runtime validations:
                    // 1. trailing ',' is allowed only if arglist is not empty
          _aref_args: '[' maybe1<T = args> maybe1<T = ','> ']'

    _assignment_rhs: expr repeat2<T1 = 'rescue', T2 = expr> // all expressions must be arguments

       _assignment_t: '='
                    | tOP_ASGN
