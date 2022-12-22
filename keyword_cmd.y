         keyword_cmd: 'break'
                    | 'break' args
                    |
                    | 'next'
                    | 'next' args
                    |
                    | 'redo'
                    |
                    | 'retry'
                    |
                    | 'return'
                    | 'return' args
                    |
                    | 'yield' '(' args ')'
                    | 'yield' '(' ')'
                    | 'yield'
                    | 'yield' args
                    |
                    | 'super' args           maybe_command_block
                    | 'super' opt_paren_args maybe_brace_block
                    |
                    | 'defined?' '(' value ')' // value must be expression
