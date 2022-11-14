             primary: literal
                    | array
                    | hash
                    | var_ref_t
                    | backref_t
                    | tFID
                    | 'begin' bodystmt 'end'
                    | '(' ')'
                    | '(' stmt ')'
                    | '(' compstmt ')'
                    | primary '::' tCONSTANT
                    | '::' tCONSTANT
                    | 'not' '(' expr ')'
                    | 'not' '(' ')'
                    | operation_t brace_block
                    |
                    | operation_t paren_args maybe1<T = brace_block>
                    | primary call_op_t operation2_t opt_paren_args maybe1<T = brace_block>
                    | primary call_op_t paren_args maybe1<T = brace_block>
                    | primary '::' operation2_t paren_args maybe1<T = brace_block>
                    | primary '::' operation3_t maybe1<T = brace_block>
                    | primary '::' paren_args maybe1<T = brace_block>
                    // There must be runtime validations:
                    // 1. trailing ',' is allowed only if arglist is not empty
                    | primary '[' maybe1<T = args> maybe1<T = ','> ']' maybe1<T = brace_block>
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

        _keyword_cmd: 'break'
                    | 'next'
                    | 'redo'
                    | 'retry'
                    | 'return'
                    | 'yield' '(' args ')'
                    | 'yield' '(' ')'
                    | 'yield'
                    | 'defined?' '(' expr ')'
