                    // Expression is an argument ALWAYS if it's not:
                    // 1. command (i.e. a method call with argument but without parentheses)
                    // 2. 'not expr'
                    // 3. '!' command
                    // 4. '=>' or 'in' one-line pattern-matching
                    // 5. binary operation 'and' / 'or'
                expr: command_call
                    | '!' command_call
                    |
                    | 'not' expr
                    |
                    | primary _expr_assignment_t '=' _expr_rhs // primary must be assignable
                    |
                    | expr '..' expr  // LHS and RHS must be arguments
                    | expr '...' expr // LHS and RHS must be arguments
                    | expr '+' expr   // LHS and RHS must be arguments
                    | expr '-' expr   // LHS and RHS must be arguments
                    | expr '*' expr   // LHS and RHS must be arguments
                    | expr '/' expr   // LHS and RHS must be arguments
                    | expr '%' expr   // LHS and RHS must be arguments
                    | expr '**' expr  // LHS and RHS must be arguments
                    | expr '|' expr   // LHS and RHS must be arguments
                    | expr '^' expr   // LHS and RHS must be arguments
                    | expr '&' expr   // LHS and RHS must be arguments
                    | expr '<=>' expr // LHS and RHS must be arguments
                    | expr '==' expr  // LHS and RHS must be arguments
                    | expr '===' expr // LHS and RHS must be arguments
                    | expr '!=' expr  // LHS and RHS must be arguments
                    | expr '=~' expr  // LHS and RHS must be arguments
                    | expr '!~' expr  // LHS and RHS must be arguments
                    | expr '<<' expr  // LHS and RHS must be arguments
                    | expr '>>' expr  // LHS and RHS must be arguments
                    | expr '&&' expr  // LHS and RHS must be arguments
                    | expr '||' expr  // LHS and RHS must be arguments
                    | expr '>' expr   // LHS and RHS must be arguments
                    | expr '<' expr   // LHS and RHS must be arguments
                    | expr '>=' expr  // LHS and RHS must be arguments
                    | expr '<=' expr  // LHS and RHS must be arguments
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
                    | '-' simple_numeric '**' expr // expr must be argument
                    |
                    | 'defined?' expr // expr must be argument
                    |
                    | expr '?' expr ':' expr // LHS, MHS and RHS must be arguments
                    |
                    | endless_method_def<Return = expr> // expr must be argument
                    |
                    | expr 'and' expr
                    | expr 'or'  expr
                    |
                    | expr '=>' p_top_expr_body // LHS must be argument
                    | expr 'in' p_top_expr_body // LHS must be argument
                    |
                    | primary

  _expr_assignment_t: '='
                    | tOP_ASGN

           _expr_rhs: expr repeat2<T1 = 'rescue', T2 = expr> // all expressions must be arguments
