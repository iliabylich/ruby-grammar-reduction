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
                    | 'yield' call_args
                    |
                    | 'super' call_args maybe_block
                    |
                    | 'defined?' '(' value ')' // value must be expression
