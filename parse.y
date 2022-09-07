             program: top_stmts opt_terms

           top_stmts: separated_by<Item = stmt_or_begin, Sep = terms>

        top_compstmt: top_stmts opt_terms

               stmts: separated_by<Item = stmt_or_begin, Sep = terms>

            compstmt: stmts opt_terms

            bodystmt: compstmt opt_rescue maybe2<T1 = 'else', T2 = compstmt> maybe2<T1 = 'ensure', T2 = compstmt>

       stmt_or_begin: stmt
                    | preexe

               preexe: 'BEGIN' '{' top_compstmt '}'

              postexe: 'END'   '{' compstmt     '}'

                stmt: stmt_head maybe1<T = stmt_tail>

           stmt_head: alias
                    | undef
                    | postexe
                    |
                    | endless_method_def<Return = command>
                    |
                    | lhs '=' command_rhs
                    | lhs '=' mrhs
                    | lhs tOP_ASGN command_rhs
                    |
                    | mlhs '=' command_call
                    | mlhs '=' mrhs maybe2<T1 = 'rescue', T2 = stmt>
                    | mlhs '=' arg maybe2<T1 = 'rescue', T2 = stmt>
                    | expr

            // %nonassoc 'if' 'unless' 'while' 'until'
            // %left 'rescue'
           stmt_tail: 'if'     expr
                    | 'unless' expr
                    | 'while'  expr
                    | 'until'  expr
                    | 'rescue' stmt

                 lhs: user_variable_t
                    | keyword_variable_t
                    | primary '[' opt_call_args ']'
                    | primary call_op_t method_name_t
                    | primary '::' method_name_t
                    | '::' tCONSTANT
                    | backref_t


         command_rhs: command_call maybe2<T1 = 'rescue', T2 = stmt>
                    |
                    | endless_method_def<Return = command>
                    |
                    | lhs '=' command_rhs
                    |
                    | lhs tOP_ASGN command_rhs

                expr: command_call
                    | expr 'and' expr
                    | expr 'or'  expr
                    | 'not' expr
                    | '!' command_call
                    | arg '=>' p_top_expr_body
                    | arg 'in' p_top_expr_body
                    | arg

        command_call: command
                    | block_command

       block_command: block_call
                    | block_call call_op2_t operation2_t call_args

             command: operation_t call_args maybe1<T = brace_block>
                    | primary call_op_t operation2_t call_args maybe1<T = brace_block>
                    | primary '::' operation2_t call_args maybe1<T = brace_block>
                    |
                    | 'super'  call_args
                    | 'yield'  call_args
                    | 'return' call_args
                    | 'break'  call_args
                    | 'next'   call_args

               cpath: maybe2<T1 = maybe1<T = primary>, T2 = '::'> cname_t

                 arg: lhs '=' arg_rhs
                    |
                    | lhs tOP_ASGN '=' arg_rhs
                    |
                    | arg '..' arg
                    | arg '...' arg
                    | arg '..'
                    | arg '...'
                    | arg '+' arg
                    | arg '-' arg
                    | arg '*' arg
                    | arg '/' arg
                    | arg '%' arg
                    | arg '**' arg
                    | arg '|' arg
                    | arg '^' arg
                    | arg '&' arg
                    | arg '<=>' arg
                    | arg '=' arg
                    | arg '==' arg
                    | arg '!=' arg
                    | arg '=~' arg
                    | arg '!~' arg
                    | arg '<<' arg
                    | arg '>>' arg
                    | arg '&&' arg
                    | arg '||' arg
                    | arg '>' arg
                    | arg '<' arg
                    | arg '>=' arg
                    | arg '<=' arg
                    |
                    | '..' arg
                    | '...' arg
                    | '-' simple_numeric_t '**' arg
                    | '+' arg
                    | '-' arg
                    | '!' arg
                    | '~' arg
                    |
                    | 'defined?' arg
                    |
                    | arg '?' arg ':' arg
                    |
                    | endless_method_def<Return = arg>
                    |
                    | primary

             arg_rhs: arg repeat2<T1 = 'rescue', T2 = arg>

          paren_args: '(' opt_call_args ')'
                    | '(' args ',' '...' ')'
                    | '(' '...' ')'

      opt_paren_args: maybe1<T = paren_args>

       opt_call_args: none
                    | call_args
                    | args ','
                    | args ',' assocs ','
                    | assocs ','

           call_args: command
                    | args opt_block_arg
                    | assocs opt_block_arg
                    | args ',' assocs opt_block_arg
                    | block_arg

           block_arg: '&' maybe1<T = arg>

       opt_block_arg: maybe2<T1 = ',', T2 = block_arg>

                args: arg
                    | '*' maybe1<T = arg>
                    | args ',' arg
                    | args ',' '*' maybe1<T = arg>

                mrhs: args ',' arg
                    | args ',' '*' arg
                    | '*' arg

                then: maybe1<T = term_t> maybe1<T = 'then'>

             if_tail: opt_else
                    | 'elsif' expr then compstmt if_tail

            opt_else: maybe2<T1 = 'else', T2 = compstmt>

            do_block: 'do' opt_block_params bodystmt 'end'

         brace_block: '{' opt_block_params compstmt '}'

          block_call: command do_block
                    | block_call call_op2_t operation2_t opt_paren_args maybe1<T = block>
                    | block_call call_op2_t operation2_t call_args do_block

         method_call: operation_t paren_args
                    | primary call_op_t operation2_t opt_paren_args
                    | primary call_op_t paren_args
                    | primary '::' operation2_t paren_args
                    | primary '::' operation3_t
                    | primary '::' paren_args
                    | primary '[' opt_call_args ']'
                    |
                    | 'super' maybe1<T = paren_args>

               block: brace_block
                    | do_block

           case_args: separated_by<Item = case_arg, Sep = ','>

            case_arg: maybe1<T = '*'> arg

           case_body: 'when' case_args then compstmt cases

               cases: opt_else
                    | case_body

          superclass: maybe3<T1 = '<', T2 = expr, T3 = term_t>

           opt_terms: maybe1<T = terms>

               terms: separated_by<Item = term_t, Sep = ';'>
