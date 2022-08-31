// A B means "A followed by B"
// A | B means "A or B"
// maybe(A) means "maybe A"
// (A B) means "A followed by B, together"
// repeat(A) means "A zero or more times"
// at_least_once(A) means "A one or more times"
// separated_by(item = A, sep = B) means "zero or more A separated by B"

             program: top_stmts opt_terms

           top_stmts: separated_by(item = top_stmt, sep = terms)

            top_stmt: stmt
                    | 'BEGIN' '{' top_compstmt '}'

            bodystmt: compstmt opt_rescue maybe('else' compstmt) opt_ensure

            compstmt: stmts opt_terms

               stmts: separated_by(item = stmt_or_begin, sep = terms)

       stmt_or_begin: stmt
                    | 'BEGIN' '{' top_compstmt '}'

                stmt: 'alias' fitem fitem
                    | 'alias' tGVAR tGVAR
                    | 'alias' tGVAR tBACK_REF
                    | 'alias' tGVAR tNTH_REF
                    |
                    | 'undef' fitem repeat(',' fitem)
                    |
                    | stmt 'if'     expr
                    | stmt 'unless' expr
                    | stmt 'while'  expr
                    | stmt 'until'  expr
                    |
                    | stmt 'rescue' stmt
                    |
                    | 'END' '{' compstmt '}'
                    |
                    | command_asgn
                    | mlhs '=' command_call
                    | lhs '=' mrhs
                    | mlhs '=' mrhs_arg 'rescue' stmt
                    | mlhs '=' mrhs_arg
                    | expr

        command_asgn: lhs '=' command_rhs
                    | var_lhs tOP_ASGN command_rhs
                    | primary '[' opt_call_args ']' tOP_ASGN command_rhs
                    | primary call_op tIDENTIFIER tOP_ASGN command_rhs
                    | primary call_op tCONSTANT tOP_ASGN command_rhs
                    | primary '::' tCONSTANT tOP_ASGN command_rhs
                    | primary '::' tIDENTIFIER tOP_ASGN command_rhs
                    | defn_head f_opt_paren_args '=' command
                    | defn_head f_opt_paren_args '=' command 'rescue' arg
                    | defs_head f_opt_paren_args '=' command
                    | defs_head f_opt_paren_args '=' command 'rescue' arg
                    | backref tOP_ASGN command_rhs

         command_rhs: command_call
                    | command_call 'rescue' stmt
                    | command_asgn

                expr: command_call
                    | expr 'and' expr
                    | expr 'or'  expr
                    | 'not' expr
                    | '!' command_call
                    | arg '=>' p_top_expr_body
                    | arg 'in' p_top_expr_body
                    | arg

           defn_head: 'def' fname

           defs_head: 'def' singleton dot_or_colon fname

        command_call: command
                    | block_command

       block_command: block_call
                    | block_call call_op2 operation2 call_args

     cmd_brace_block: '{' opt_block_param compstmt '}'

             command: operation call_args
                    | operation call_args cmd_brace_block
                    | primary call_op operation2 call_args
                    | primary call_op operation2 call_args cmd_brace_block
                    | primary '::' operation2 call_args
                    | primary '::' operation2 call_args cmd_brace_block
                    | 'super' call_args
                    | 'yield' call_args
                    | 'return' call_args
                    | 'break' call_args
                    | 'next' call_args

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
                    | keyword_variable
                    | primary '[' opt_call_args ']'
                    | primary call_op tIDENTIFIER
                    | primary call_op tCONSTANT
                    | primary '::' tIDENTIFIER
                    | primary '::' tCONSTANT
                    | '::' tCONSTANT
                    | backref

                 lhs: user_variable
                    | keyword_variable
                    | primary '[' opt_call_args ']'
                    | primary call_op tIDENTIFIER
                    | primary call_op tCONSTANT
                    | primary '::' tIDENTIFIER
                    | primary '::' tCONSTANT
                    | '::' tCONSTANT
                    | backref

               cname: tIDENTIFIER
                    | tCONSTANT

               cpath: '::' cname
                    | cname
                    | primary '::' cname

               fitem: fname
                    | symbol

                 arg: lhs '=' arg_rhs
                    | var_lhs tOP_ASGN arg_rhs
                    | primary '[' opt_call_args ']' tOP_ASGN arg_rhs
                    | primary call_op tIDENTIFIER tOP_ASGN arg_rhs
                    | primary call_op tCONSTANT tOP_ASGN arg_rhs
                    | primary '::' tIDENTIFIER tOP_ASGN arg_rhs
                    | primary '::' tCONSTANT tOP_ASGN arg_rhs
                    | '::' tCONSTANT tOP_ASGN arg_rhs
                    | backref tOP_ASGN arg_rhs
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
                    | '-' simple_numeric '**' arg
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

            rel_expr: arg relop arg
                    | rel_expr relop arg

           aref_args: maybe(separated_by(item = args, sep = ',') maybe(',')) maybe(separated_by(assocs ',') maybe(','))

             arg_rhs: arg
                    | arg 'rescue' arg

          paren_args: '(' opt_call_args ')'
                    | '(' args ',' '...' ')'
                    | '(' '...' ')'

      opt_paren_args: none
                    | paren_args

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

           block_arg: '&' arg
                    | '&'

       opt_block_arg: ',' block_arg
                    | none

                args: arg
                    | '*' arg
                    | '*'
                    | args ',' arg
                    | args ',' '*' arg
                    | args ',' '*'

            mrhs_arg: mrhs
                    | arg

                mrhs: args ',' arg
                    | args ',' '*' arg
                    | '*' arg

             primary: literal
                    | strings
                    | xstring
                    | regexp
                    | words
                    | qwords
                    | symbols
                    | qsymbols
                    | var_ref
                    | backref
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
                    | operation brace_block
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
                    | 'class' '<<' expr term bodystmt 'end'
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

                then: maybe(term) maybe('then')

                  do: term
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
                    | block_call call_op2 operation2 opt_paren_args
                    | block_call call_op2 operation2 opt_paren_args brace_block
                    | block_call call_op2 operation2 call_args 'do' opt_block_param bodystmt 'end'

         method_call: operation paren_args
                    | primary call_op operation2 opt_paren_args
                    | primary '::' operation2 paren_args
                    | primary '::' operation3
                    | primary call_op paren_args
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

             literal: numeric
                    | symbol

             strings: tCHAR
                    | at_least_once(string1)

             string1: tSTRING_BEG string_contents tSTRING_END

             xstring: tXSTRING_BEG xstring_contents tSTRING_END

              regexp: tREGEXP_BEG regexp_contents tREGEXP_END

               words: tWORDS_BEG ' ' word_list tSTRING_END

           word_list: separated_by(item = word, sep = ' ')

                word: at_least_once(string_content)

             symbols: tSYMBOLS_BEG ' ' symbol_list tSTRING_END

         symbol_list: separated_by(item = word, sep = ' ')

              qwords: tQWORDS_BEG ' ' qword_list tSTRING_END

            qsymbols: tQSYMBOLS_BEG ' ' qsym_list tSTRING_END

          qword_list: separated_by(item = tSTRING_CONTENT, item = ' ')

           qsym_list: separated_by(item = tSTRING_CONTENT, item = ' ')

     string_contents: repeat(string_content)

    xstring_contents: repeat(string_content)

     regexp_contents: repeat(string_content)

      string_content: tSTRING_CONTENT
                    | tSTRING_DVAR string_dvar
                    | tSTRING_DBEG compstmt tSTRING_DEND

         string_dvar: tGVAR
                    | tIVAR
                    | tCVAR
                    | backref

              symbol: tSYMBEG sym
                    | tSYMBEG string_contents tSTRING_END

                 sym: fname
                    | nonlocal_var

             numeric: simple_numeric
                    | '-' simple_numeric

             var_ref: user_variable
                    | keyword_variable

             var_lhs: user_variable
                    | keyword_variable

          superclass: maybe('<' expr term)

    f_opt_paren_args: maybe('(' f_args ')')

           f_arglist: '(' f_args ')'
                    | f_args term

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

               terms: separated_by(item = term, sep = ';')

                none: /* none */
