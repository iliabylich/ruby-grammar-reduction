         keyword_cmd: 'break' maybe1<T = args>
                    |
                    | 'next' maybe1<T = args>
                    |
                    | 'redo'
                    |
                    | 'retry'
                    |
                    | 'return' maybe1<T = args>
                    |
                    | // For some reason trailing comman in yield(a, b,) is not allowed. why?? we ignore it
                    | 'yield' call_args
                    |
                    | 'super' call_args maybe_block
                    |
                    | 'defined?' '(' value ')' // value must be expression
