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
                    | // For some reason trailing comman in yield(a, b,) is not allowed. why?? we ignore it
                    | 'yield' opt_paren_args
                    | 'yield' args
                    |
                    | 'super' args           maybe_command_block
                    | 'super' opt_paren_args maybe_brace_block
                    |
                    | 'defined?' '(' value ')' // value must be expression
