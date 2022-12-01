 maybe_command_block: maybe1<T = do_block> repeat1<T = _chain_command_block_call>

     _chain_command_block_call: call_op2_t operation2_t opt_paren_args maybe1<T = block>
                              | call_op2_t operation2_t args do_block
                              | call_op2_t operation2_t args // cannot be changed because of args
