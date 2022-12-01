         keyword_cmd: 'break'
                    | 'break' args maybe_command_block
                    |
                    | 'next'
                    | 'next' args maybe_command_block
                    |
                    | 'redo'
                    |
                    | 'retry'
                    |
                    | 'return'
                    | 'return' args maybe_command_block
                    |
                    | 'yield' '(' args ')'
                    | 'yield' '(' ')'
                    | 'yield'
                    | 'yield' args maybe_command_block
                    |
                    | 'super' args           maybe_command_block
                    | 'super' opt_paren_args maybe_brace_block
                    |
                    | 'defined?' '(' expr ')'
