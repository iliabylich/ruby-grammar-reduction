             primary: _primary_head repeat1<T = _primary_tail>

       _primary_head: literal
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

       _primary_tail: '::' tCONSTANT
                    | call_op_t operation2_t opt_paren_args maybe1<T = brace_block>
                    | call_op_t paren_args maybe1<T = brace_block>
                    | '::' operation2_t paren_args maybe1<T = brace_block>
                    | '::' operation3_t maybe1<T = brace_block>
                    | '::' paren_args maybe1<T = brace_block>
                    | aref_args maybe1<T = brace_block>

        _keyword_cmd: 'break'
                    | 'next'
                    | 'redo'
                    | 'retry'
                    | 'return'
                    | 'yield' '(' args ')'
                    | 'yield' '(' ')'
                    | 'yield'
                    | 'defined?' '(' expr ')'
