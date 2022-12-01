         command_rhs: command_call maybe2<T1 = 'rescue', T2 = stmt>
                    |
                    | endless_method_def<Return = command>
                    |
                    | expr '=' command_rhs // expr must be assignable
                    |
                    | expr tOP_ASGN command_rhs // expr must be assignable

        command_call: command maybe_command_block

 maybe_command_block: maybe1<T = do_block> repeat1<T = _chain_command_block_call>

             command: operation_t args maybe_brace_block
                    | expr call_op_t operation2_t args maybe_brace_block // expr must be primary
                    | expr '::' operation2_t args maybe_brace_block // expr must be primary
                    |
                    | 'super'  args
                    | 'yield'  args
                    | 'return' args
                    | 'break'  args
                    | 'next'   args

     _chain_command_block_call: call_op2_t operation2_t opt_paren_args maybe1<T = block>
                              | call_op2_t operation2_t args do_block
                              | call_op2_t operation2_t args // cannot be changed because of args
