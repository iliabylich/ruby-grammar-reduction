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
                    | method_call
                    | method_call brace_block
                    | lambda
                    |
                    | 'if'     expr then compstmt if_tail 'end'
                    | 'unless' expr then compstmt opt_else 'end'
                    | 'while'  expr do_t compstmt 'end'
                    | 'until'  expr do_t compstmt 'end'
                    |
                    | case
                    |
                    | for_loop
                    |
                    | 'class' cpath superclass bodystmt 'end'
                    | 'class' '<<' expr term_t bodystmt 'end'
                    |
                    | 'module' cpath bodystmt 'end'
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
