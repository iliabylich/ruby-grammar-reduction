                    // Expression is an argument ALWAYS if it's not:
                    // 1. command (i.e. a method call with argument but without parentheses)
                    // 2. 'not expr'
                    // 3. '!' command
                    // 4. '=>' or 'in' one-line pattern-matching
                    // 5. binary operation 'and' / 'or'
                    // 6. super/yield/return/break/next in command mode
                expr: command_call
                    | '!' command_call
                    |
                    | primary
                    | primary _expr_assignment_t expr repeat2<T1 = 'rescue', T2 = expr> // primary must be assignable, all expressions must be arguments
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

  _expr_assignment_t: '='
                    | tOP_ASGN
