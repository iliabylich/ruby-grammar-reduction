             command_keyword_cmd: 'super'  call_args
                                | 'yield'  call_args
                                | 'return' call_args
                                | 'break'  call_args
                                | 'next'   call_args

             primary_keyword_cmd: 'break' none
                                | 'next'  none
                                | 'redo'  none
                                | 'retry' none
                                | 'return' none
                                | 'yield' '(' call_args ')'
                                | 'yield' '(' ')'
                                | 'yield' None
                                | 'defined?' '(' expr ')'

                expr_keyword_cmd: 'defined?' arg

         method_call_keyword_cmd: 'super' paren_args
                                | 'super' none
