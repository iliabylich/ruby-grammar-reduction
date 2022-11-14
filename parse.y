             program: top_stmts opt_terms

                 lhs: user_variable
                    | keyword_variable
                    // There must be runtime validations:
                    // 1. trailing ',' is allowed only if arglist is not empty
                    | primary '[' maybe1<T = args> maybe1<T = ','> ']'
                    | primary call_op_t method_name_t
                    | primary '::' method_name_t
                    | '::' tCONSTANT
                    | backref


         command_rhs: command_call maybe2<T1 = 'rescue', T2 = stmt>
                    |
                    | endless_method_def<Return = command>
                    |
                    | lhs '=' command_rhs
                    |
                    | lhs tOP_ASGN command_rhs

        command_call: command
                    | block_command

       block_command: block_call maybe3<T1 = call_op2_t, T2 = operation2_t, T3 = args>

             command: operation_t args maybe1<T = brace_block>
                    | primary call_op_t operation2_t args maybe1<T = brace_block>
                    | primary '::' operation2_t args maybe1<T = brace_block>
                    |
                    | 'super'  args
                    | 'yield'  args
                    | 'return' args
                    | 'break'  args
                    | 'next'   args

               cpath: maybe2<T1 = maybe1<T = primary>, T2 = '::'> cname_t

             arg_rhs: arg repeat2<T1 = 'rescue', T2 = arg>

                then: maybe1<T = term_t> maybe1<T = 'then'>

            opt_else: maybe2<T1 = 'else', T2 = compstmt>

          block_call: command do_block repeat1<T = chain_block_call>

    chain_block_call: call_op2_t operation2_t opt_paren_args maybe1<T = block>
                    | call_op2_t operation2_t args do_block

           opt_terms: maybe1<T = terms>

               terms: separated_by<Item = term_t, Sep = ';'>
