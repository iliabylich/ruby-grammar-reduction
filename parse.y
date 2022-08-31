// A B means "A followed by B"
// A | B means "A or B"
// maybe(A) means "maybe A"
// (A B) means "A followed by B, together"
// repeat(A) means "A zero or more times"
// at_least_once(A) means "A one or more times"
// separated_by(item = A, sep = B) means "zero or more A separated by B"

             program: top_stmts opt_terms

           top_stmts: separated_by(item = stmt_or_begin, sep = terms)

            bodystmt: compstmt opt_rescue maybe('else' compstmt) opt_ensure

            compstmt: stmts opt_terms

               stmts: separated_by(item = stmt_or_begin, sep = terms)

       stmt_or_begin: stmt
                    | preexe

               preexe: 'BEGIN' '{' top_compstmt '}'
              postexe: 'END'   '{' compstmt     '}'

                stmt: alias
                    | undef
                    | postexe
                    |
                    | stmt 'if'     expr
                    | stmt 'unless' expr
                    | stmt 'while'  expr
                    | stmt 'until'  expr
                    | stmt 'rescue' stmt
                    |
                    | defn_head f_opt_paren_args '=' command maybe('rescue' arg)
                    | defs_head f_opt_paren_args '=' command maybe('rescue' arg)
                    |
                    | lhs '=' command_rhs
                    | lhs '=' mrhs
                    |
                    | var_lhs tOP_ASGN command_rhs
                    |
                    | primary '[' opt_call_args ']'   tOP_ASGN command_rhs
                    | primary call_op_t method_name_t tOP_ASGN command_rhs
                    | primary '::'      method_name_t tOP_ASGN command_rhs
                    | backref_t                       tOP_ASGN command_rhs
                    |
                    | mlhs '=' command_call
                    | mlhs '=' mrhs_arg 'rescue' stmt
                    | mlhs '=' mrhs_arg
                    | expr

               alias: 'alias' fitem fitem
                    | 'alias' tGVAR tGVAR
                    | 'alias' tGVAR tBACK_REF
                    | 'alias' tGVAR tNTH_REF

               undef: 'undef' fitem repeat(',' fitem)

         command_rhs: command_call maybe('rescue' stmt)
                    |
                    | defn_head f_opt_paren_args '=' command maybe('rescue' arg)
                    | defs_head f_opt_paren_args '=' command maybe('rescue' arg)
                    |
                    | lhs '=' command_rhs
                    |
                    | var_lhs tOP_ASGN command_rhs
                    |
                    | primary '[' opt_call_args ']'   tOP_ASGN command_rhs
                    | primary call_op_t method_name_t tOP_ASGN command_rhs
                    | primary '::'      method_name_t tOP_ASGN command_rhs
                    | backref_t                       tOP_ASGN command_rhs

                expr: command_call
                    | expr 'and' expr
                    | expr 'or'  expr
                    | 'not' expr
                    | '!' command_call
                    | arg '=>' p_top_expr_body
                    | arg 'in' p_top_expr_body
                    | arg

           defn_head: 'def' fname_t

           defs_head: 'def' singleton dot_or_colon_t fname_t

        command_call: command
                    | block_command

       block_command: block_call
                    | block_call call_op2_t operation2_t call_args

     cmd_brace_block: '{' opt_block_param compstmt '}'

             command: operation_t call_args maybe(cmd_brace_block)
                    | primary call_op_t operation2_t call_args maybe(cmd_brace_block)
                    | primary '::' operation2_t call_args maybe(cmd_brace_block)
                    |
                    | 'super'  call_args
                    | 'yield'  call_args
                    | 'return' call_args
                    | 'break'  call_args
                    | 'next'   call_args

                mlhs: mlhs_basic
                    | '(' mlhs_inner ')'

          mlhs_inner: mlhs_basic
                    | '(' mlhs_inner ')'

          mlhs_basic: mlhs_head
                    | mlhs_head mlhs_item
                    | mlhs_head '*' mlhs_node
                    | mlhs_head '*' mlhs_node ',' mlhs_post
                    | mlhs_head '*'
                    | mlhs_head '*' ',' mlhs_post
                    | '*' mlhs_node
                    | '*' mlhs_node ',' mlhs_post
                    | '*'
                    | '*' ',' mlhs_post

           mlhs_item: mlhs_node
                    | '(' mlhs_inner ')'

           mlhs_head: mlhs_item ','
                    | mlhs_head mlhs_item ','

           mlhs_post: mlhs_item
                    | mlhs_post ',' mlhs_item

           mlhs_node: user_variable
                    | keyword_variable_t
                    | primary '[' opt_call_args ']'
                    | primary call_op_t method_name_t
                    | primary '::' method_name_t
                    | '::' tCONSTANT
                    | backref_t

                 lhs: user_variable
                    | keyword_variable_t
                    | primary '[' opt_call_args ']'
                    | primary call_op_t method_name_t
                    | primary '::' method_name_t
                    | '::' tCONSTANT
                    | backref_t

               cname: tIDENTIFIER
                    | tCONSTANT

               cpath: '::' cname
                    | cname
                    | primary '::' cname

               fitem: fname_t
                    | symbol

                 arg: lhs '=' arg_rhs
                    | var_lhs tOP_ASGN arg_rhs
                    | primary '[' opt_call_args ']' tOP_ASGN arg_rhs
                    | primary call_op_t method_name_t tOP_ASGN arg_rhs
                    | primary '::' method_name_t tOP_ASGN arg_rhs
                    | '::' tCONSTANT tOP_ASGN arg_rhs
                    | backref_t tOP_ASGN arg_rhs
                    | arg '..' arg
                    | arg '...' arg
                    | arg '..'
                    | arg '...'
                    | '..' arg
                    | '...' arg
                    | arg '+' arg
                    | arg '-' arg
                    | arg '*' arg
                    | arg '/' arg
                    | arg '%' arg
                    | arg '**' arg
                    | '-' simple_numeric_t '**' arg
                    | '+' arg
                    | '-' arg
                    | arg '|' arg
                    | arg '^' arg
                    | arg '&' arg
                    | arg '<=>' arg
                    | rel_expr
                    | arg '=' arg
                    | arg '==' arg
                    | arg '!=' arg
                    | arg '=~' arg
                    | arg '!~' arg
                    | '!' arg
                    | '~' arg
                    | arg '<<' arg
                    | arg '>>' arg
                    | arg '&&' arg
                    | arg '||' arg
                    | 'defined?' arg
                    | arg '?' arg ':' arg
                    | defn_head f_opt_paren_args '=' arg
                    | defn_head f_opt_paren_args '=' arg 'rescue' arg
                    | defs_head f_opt_paren_args '=' arg
                    | defs_head f_opt_paren_args '=' arg 'rescue' arg
                    | primary

            rel_expr: arg at_least_once(relop_t arg)

           aref_args: maybe(separated_by(item = args, sep = ',') maybe(',')) maybe(separated_by(assocs ',') maybe(','))

             arg_rhs: arg repeat('rescue' arg)

          paren_args: '(' opt_call_args ')'
                    | '(' args ',' '...' ')'
                    | '(' '...' ')'

      opt_paren_args: maybe(paren_args)

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

           block_arg: '&' maybe(arg)

       opt_block_arg: maybe(',' block_arg)

                args: arg
                    | '*' maybe(arg)
                    | args ',' arg
                    | args ',' '*' maybe(arg)

            mrhs_arg: mrhs
                    | arg

                mrhs: args ',' arg
                    | args ',' '*' arg
                    | '*' arg

             primary: numeric
                    | symbol
                    | strings
                    | xstring
                    | regexp
                    | words
                    | qwords
                    | symbols
                    | qsymbols
                    | var_ref
                    | backref_t
                    | tFID
                    | 'begin' bodystmt 'end'
                    | '(' ')'
                    | '(' stmt ')'
                    | '(' compstmt ')'
                    | primary '::' tCONSTANT
                    | '::' tCONSTANT
                    | '[' aref_args ']'
                    | '{' assoc_list '}'
                    | 'return'
                    | 'yield' '(' call_args ')'
                    | 'yield' '(' ')'
                    | 'yield'
                    | 'defined?' '(' expr ')'
                    | 'not' '(' expr ')'
                    | 'not' '(' ')'
                    | operation_t brace_block
                    | method_call
                    | method_call brace_block
                    | lambda
                    |
                    | 'if'     expr then compstmt if_tail 'end'
                    | 'unless' expr then compstmt opt_else 'end'
                    | 'while'  expr do compstmt 'end'
                    | 'until'  expr do compstmt 'end'
                    |
                    | 'case' expr opt_terms case_body 'end'
                    | 'case' opt_terms case_body 'end'
                    | 'case' expr opt_terms p_case_body 'end'
                    |
                    | 'for' for_var 'in' expr do compstmt 'end'
                    |
                    | 'class' cpath superclass bodystmt 'end'
                    | 'class' '<<' expr term_t bodystmt 'end'
                    |
                    | 'module' cpath bodystmt 'end'
                    |
                    | defn_head f_arglist bodystmt 'end'
                    | defs_head f_arglist bodystmt 'end'
                    |
                    | 'break'
                    | 'next'
                    | 'redo'
                    | 'retry'

                then: maybe(term_t) maybe('then')

                  do: term_t
                    | 'do'

             if_tail: opt_else
                    | 'elsif' expr then compstmt if_tail

            opt_else: none
                    | 'else' compstmt

             for_var: lhs
                    | mlhs

              f_marg: tIDENTIFIER
                    | '(' f_margs ')'

         f_marg_list: f_marg
                    | f_marg_list ',' f_marg

             f_margs: f_marg_list
                    | f_marg_list ',' f_rest_marg
                    | f_marg_list ',' f_rest_marg ',' f_marg_list
                    | f_rest_marg
                    | f_rest_marg ',' f_marg_list

         f_rest_marg: '*' maybe(tIDENTIFIER)

        f_any_kwrest: '**' maybe(tIDENTIFIER)
                    | '**' 'nil'

     block_args_tail: f_block_kwarg ',' f_kwrest opt_f_block_arg
                    | f_block_kwarg opt_f_block_arg
                    | f_any_kwrest opt_f_block_arg
                    | f_block_arg

 opt_block_args_tail: maybe(',' block_args_tail)

         block_param: f_arg ',' f_block_optarg ',' f_rest_arg opt_block_args_tail
                    | f_arg ',' f_block_optarg ',' f_rest_arg ',' f_arg opt_block_args_tail
                    | f_arg ',' f_block_optarg opt_block_args_tail
                    | f_arg ',' f_block_optarg ',' f_arg opt_block_args_tail
                    | f_arg ',' f_rest_arg opt_block_args_tail
                    | f_arg ','
                    | f_arg ',' f_rest_arg ',' f_arg opt_block_args_tail
                    | f_arg opt_block_args_tail
                    | f_block_optarg ',' f_rest_arg opt_block_args_tail
                    | f_block_optarg ',' f_rest_arg ',' f_arg opt_block_args_tail
                    | f_block_optarg opt_block_args_tail
                    | f_block_optarg ',' f_arg opt_block_args_tail
                    | f_rest_arg opt_block_args_tail
                    | f_rest_arg ',' f_arg opt_block_args_tail
                    | block_args_tail

     opt_block_param: maybe(block_param_def)

     block_param_def: '|' opt_bv_decl '|'
                    | '|' block_param opt_bv_decl '|'

         opt_bv_decl: ';' bv_decls

            bv_decls: separated_by(item = tIDENTIFIER, sep = ',')

              lambda: tLAMBDA f_larglist lambda_body

          f_larglist: '(' f_args opt_bv_decl ')'
                    | f_args

         lambda_body: tLAMBEG compstmt '}'
                    | kDO_LAMBDA bodystmt 'end'

          block_call: command 'do' opt_block_param bodystmt 'end'
                    | block_call call_op2_t operation2_t opt_paren_args
                    | block_call call_op2_t operation2_t opt_paren_args brace_block
                    | block_call call_op2_t operation2_t call_args 'do' opt_block_param bodystmt 'end'

         method_call: operation_t paren_args
                    | primary call_op_t operation2_t opt_paren_args
                    | primary '::' operation2_t paren_args
                    | primary '::' operation3_t
                    | primary call_op_t paren_args
                    | primary '::' paren_args
                    | 'super' paren_args
                    | 'super'
                    | primary '[' opt_call_args ']'

         brace_block: '{'  opt_block_param compstmt '}'
                    | 'do' opt_block_param bodystmt 'end'

           case_args: separated_by(item = case_arg, sep = ',')

            case_arg: arg
                    | '*' arg

           case_body: 'when' case_args then compstmt cases

               cases: opt_else
                    | case_body

          opt_rescue: maybe('rescue' exc_list exc_var then compstmt opt_rescue)

            exc_list: arg
                    | mrhs
                    | none

             exc_var: maybe('=>' lhs)

          opt_ensure: maybe('ensure' compstmt)


             strings: tCHAR
                    | at_least_once(string1)

             string1: tSTRING_BEG string_contents tSTRING_END

             xstring: tXSTRING_BEG repeat(string_content) tSTRING_END

              regexp: tREGEXP_BEG repeat(string_content) tREGEXP_END

               words: tWORDS_BEG separated_by(item = word, sep = ' ') tSTRING_END

                word: at_least_once(string_content)

             symbols: tSYMBOLS_BEG separated_by(item = word, sep = ' ') tSTRING_END

              qwords: tQWORDS_BEG separated_by(item = tSTRING_CONTENT, item = ' ') tSTRING_END

            qsymbols: tQSYMBOLS_BEG ' ' separated_by(item = tSTRING_CONTENT, item = ' ') tSTRING_END

     string_contents: repeat(string_content)

      string_content: tSTRING_CONTENT
                    | tSTRING_DVAR string_dvar
                    | tSTRING_DBEG compstmt tSTRING_DEND

         string_dvar: tGVAR
                    | tIVAR
                    | tCVAR
                    | backref_t

              symbol: tSYMBEG sym
                    | tSYMBEG string_contents tSTRING_END

                 sym: fname_t
                    | nonlocal_var_t

             numeric: simple_numeric_t
                    | '-' simple_numeric_t

             var_ref: user_variable
                    | keyword_variable_t

             var_lhs: user_variable
                    | keyword_variable_t

          superclass: maybe('<' expr term_t)

    f_opt_paren_args: maybe('(' f_args ')')

           f_arglist: '(' f_args ')'
                    | f_args term_t

           args_tail: f_kwarg ',' f_kwrest opt_f_block_arg
                    | f_kwarg opt_f_block_arg
                    | f_any_kwrest opt_f_block_arg
                    | f_block_arg
                    | '...'

       opt_args_tail: maybe(',' args_tail)

              f_args: f_arg ',' f_optarg ',' f_rest_arg opt_args_tail
                    | f_arg ',' f_optarg ',' f_rest_arg ',' f_arg opt_args_tail
                    | f_arg ',' f_optarg opt_args_tail
                    | f_arg ',' f_optarg ',' f_arg opt_args_tail
                    | f_arg ',' f_rest_arg opt_args_tail
                    | f_arg ',' f_rest_arg ',' f_arg opt_args_tail
                    | f_arg opt_args_tail
                    | f_optarg ',' f_rest_arg opt_args_tail
                    | f_optarg ',' f_rest_arg ',' f_arg opt_args_tail
                    | f_optarg opt_args_tail
                    | f_optarg ',' f_arg opt_args_tail
                    | f_rest_arg opt_args_tail
                    | f_rest_arg ',' f_arg opt_args_tail
                    | args_tail
                    | /* none */

          f_arg_item: tIDENTIFIER
                    | '(' f_margs ')'

               f_arg: f_arg_item
                    | f_arg ',' f_arg_item

                f_kw: tLABEL maybe(arg)

          f_block_kw: tLABEL maybe(primary)

       f_block_kwarg: f_block_kw
                    | f_block_kwarg ',' f_block_kw

             f_kwarg: separated_by(item = f_kw, sep = ',')

            f_kwrest: '**' maybe(tIDENTIFIER)

               f_opt: tIDENTIFIER '=' arg

         f_block_opt: tIDENTIFIER '=' primary

      f_block_optarg: separated_by(item = f_block_opt, sep = ',')

            f_optarg: separated_by(item = f_opt, sep = ',')

          f_rest_arg: '*' maybe(tIDENTIFIER)

         f_block_arg: '&' tIDENTIFIER

     opt_f_block_arg: maybe(',' f_block_arg)

           singleton: var_ref
                    | '(' expr ')'

          assoc_list: separated_by(item = assoc, sep = ',')

               assoc: arg '=>' arg
                    | tLABEL maybe(arg)
                    | tSTRING_BEG string_contents tLABEL_END arg
                    | '**' arg
                    | '**'

           opt_terms: maybe(terms)

               terms: separated_by(item = term_t, sep = ';')

                none: /* none */
