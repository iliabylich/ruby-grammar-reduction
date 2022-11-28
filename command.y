         command_rhs: command_call maybe2<T1 = 'rescue', T2 = stmt>
                    |
                    | endless_method_def<Return = command>
                    |
                    | primary '=' command_rhs // primary must be assignable
                    |
                    | primary tOP_ASGN command_rhs // primary must be assignable

        command_call: command
                    | command do_block repeat1<T = _chain_block_call> maybe3<T1 = call_op2_t, T2 = operation2_t, T3 = args>

             command: operation_t args maybe1<T = brace_block>
                    | primary call_op_t operation2_t args maybe1<T = brace_block>
                    | primary '::' operation2_t args maybe1<T = brace_block>
                    |
                    | 'super'  args
                    | 'yield'  args
                    | 'return' args
                    | 'break'  args
                    | 'next'   args

   _chain_block_call: call_op2_t operation2_t opt_paren_args maybe1<T = block>
                    | call_op2_t operation2_t args do_block
