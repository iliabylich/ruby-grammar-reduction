 maybe_command_block: maybe1<T = do_block> repeat1<T = _chain_command_block_call>

             command: _value0 // must be a call with open args
                    //| operation_t args maybe_brace_block
                    //| value call_op_t operation2_t args maybe_brace_block // value must be primary
                    //| value '::' operation2_t args maybe_brace_block // value must be primary
                    //|
                    //| 'super'  args
                    //| 'yield'  args
                    //| 'return' args
                    //| 'break'  args
                    //| 'next'   args

     _chain_command_block_call: call_op2_t operation2_t opt_paren_args maybe1<T = block>
                              | call_op2_t operation2_t args do_block
                              | call_op2_t operation2_t args // cannot be changed because of args
