// A B means "A followed by B"
// A | B means "A or B"
// maybe<A> means "maybe A"
// (A B) means "A followed by B, together"
// repeat<A> means "A zero or more times"
// at_least_once<A> means "A one or more times"
// separated_by<Item = A, Sep = B> means "zero or more A separated by B"
//
// foo<T>: T '=' T means that rule 'foo' is parameterized over T
// foo: bar<T> means that foo has a derivation bar applied with rule T

             program: top_stmts opt_terms

           top_stmts: separated_by<Item = stmt_or_begin, Sep = terms>

            bodystmt: compstmt opt_rescue maybe<'else' compstmt> maybe<'ensure' compstmt>

            compstmt: stmts opt_terms

               stmts: separated_by<Item = stmt_or_begin, Sep = terms>

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
                    | endless_method_def_stmt
                    |
                    | lhs '=' command_rhs
                    | lhs '=' mrhs
                    |
                    | op_asgn<RHS = command_rhs>
                    |
                    | mlhs '=' command_call
                    | mlhs '=' mrhs_arg 'rescue' stmt
                    | mlhs '=' mrhs_arg
                    | expr

        op_asgn<RHS>: var_lhs_t                       tOP_ASGN RHS
                    | primary '[' opt_call_args ']'   tOP_ASGN RHS
                    | primary call_op_t method_name_t tOP_ASGN RHS
                    | primary '::'      method_name_t tOP_ASGN RHS
                    | backref_t                       tOP_ASGN RHS
                    | '::' tCONSTANT                  tOP_ASGN RHS

               alias: 'alias' fitem fitem
                    | 'alias' tGVAR tGVAR
                    | 'alias' tGVAR tBACK_REF
                    | 'alias' tGVAR tNTH_REF

               undef: 'undef' fitem repeat<',' fitem>

         command_rhs: command_call maybe<'rescue' stmt>
                    |
                    | endless_method_def_stmt
                    |
                    | lhs '=' command_rhs
                    |
                    | op_asgn<RHS = command_rhs>

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

     cmd_brace_block: '{' opt_block_param compstmt '}'

             command: operation_t call_args maybe<cmd_brace_block>
                    | primary call_op_t operation2_t call_args maybe<cmd_brace_block>
                    | primary '::' operation2_t call_args maybe<cmd_brace_block>
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
                    | mlhs_head '*' lhs
                    | mlhs_head '*' lhs ',' mlhs_post
                    | mlhs_head '*'
                    | mlhs_head '*' ',' mlhs_post
                    | '*' lhs
                    | '*' lhs ',' mlhs_post
                    | '*'
                    | '*' ',' mlhs_post

           mlhs_item: lhs
                    | '(' mlhs_inner ')'

           mlhs_head: mlhs_item ','
                    | mlhs_head mlhs_item ','

           mlhs_post: mlhs_item
                    | mlhs_post ',' mlhs_item

                 lhs: user_variable_t
                    | keyword_variable_t
                    | primary '[' opt_call_args ']'
                    | primary call_op_t method_name_t
                    | primary '::' method_name_t
                    | '::' tCONSTANT
                    | backref_t

               cpath: '::' cname_t
                    | cname_t
                    | primary '::' cname_t

               fitem: fname_t
                    | symbol

                 arg: lhs '=' arg_rhs
                    |
                    | op_asgn<RHS = arg_rhs>
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
                    | endless_method_def_arg
                    |
                    | primary

           aref_args: maybe<
                        separated_by<Item = args, Sep = ','>
                        maybe<','>>
                      maybe<
                        separated_by<Item = assocs, Item = ','> maybe<','>>

             arg_rhs: arg repeat<'rescue' arg>

          paren_args: '(' opt_call_args ')'
                    | '(' args ',' '...' ')'
                    | '(' '...' ')'

      opt_paren_args: maybe<paren_args>

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

           block_arg: '&' maybe<arg>

       opt_block_arg: maybe<',' block_arg>

                args: arg
                    | '*' maybe<arg>
                    | args ',' arg
                    | args ',' '*' maybe<arg>

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
                    | var_ref_t
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
                    | 'while'  expr do_t compstmt 'end'
                    | 'until'  expr do_t compstmt 'end'
                    |
                    | 'case' expr opt_terms case_body 'end'
                    | 'case' opt_terms case_body 'end'
                    | 'case' expr opt_terms p_case_body 'end'
                    |
                    | 'for' for_var 'in' expr do_t compstmt 'end'
                    |
                    | 'class' cpath superclass bodystmt 'end'
                    | 'class' '<<' expr term_t bodystmt 'end'
                    |
                    | 'module' cpath bodystmt 'end'
                    |
                    | method_def
                    |
                    | 'break'
                    | 'next'
                    | 'redo'
                    | 'retry'

                then: maybe<term_t> maybe<'then'>

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

         f_rest_marg: '*' maybe<tIDENTIFIER>

        f_any_kwrest: '**' maybe<tIDENTIFIER>
                    | '**' 'nil'

     block_args_tail: f_block_kwarg ',' f_kwrest opt_f_block_arg
                    | f_block_kwarg opt_f_block_arg
                    | f_any_kwrest opt_f_block_arg
                    | f_block_arg

 opt_block_args_tail: maybe<',' block_args_tail>

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

     opt_block_param: maybe<block_param_def>

     block_param_def: '|' opt_bv_decl '|'
                    | '|' block_param opt_bv_decl '|'

         opt_bv_decl: ';' bv_decls

            bv_decls: separated_by<Item = tIDENTIFIER, Sep = ','>

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

           case_args: separated_by<Item = case_arg, Sep = ','>

            case_arg: maybe<'*'> arg

           case_body: 'when' case_args then compstmt cases

               cases: opt_else
                    | case_body

          opt_rescue: maybe<'rescue' exc_list exc_var then compstmt opt_rescue>

            exc_list: arg
                    | mrhs
                    | none

             exc_var: maybe<'=>' lhs>

             strings: tCHAR
                    | at_least_once<string1>

             string1: tSTRING_BEG string_contents tSTRING_END

             xstring: tXSTRING_BEG repeat<string_content> tSTRING_END

              regexp: tREGEXP_BEG repeat<string_content> tREGEXP_END

               words: tWORDS_BEG separated_by<Item = word, Sep = ' '> tSTRING_END

                word: at_least_once<string_content>

             symbols: tSYMBOLS_BEG separated_by<Item = word, Sep = ' '> tSTRING_END

              qwords: tQWORDS_BEG separated_by<Item = tSTRING_CONTENT, item = ' ') tSTRING_END

            qsymbols: tQSYMBOLS_BEG ' ' separated_by<Item = tSTRING_CONTENT, item = ' ') tSTRING_END

     string_contents: repeat<string_content>

      string_content: tSTRING_CONTENT
                    | tSTRING_DVAR string_dvar_t
                    | tSTRING_DBEG compstmt tSTRING_DEND

              symbol: tSYMBEG sym_t
                    | tSYMBEG string_contents tSTRING_END

             numeric: maybe<'-'> simple_numeric_t

          superclass: maybe<'<' expr term_t>

    f_opt_paren_args: maybe<'(' f_args ')'>

           f_arglist: '(' f_args ')'
                    | f_args term_t

           args_tail: f_kwarg ',' f_kwrest opt_f_block_arg
                    | f_kwarg opt_f_block_arg
                    | f_any_kwrest opt_f_block_arg
                    | f_block_arg
                    | '...'

       opt_args_tail: maybe<',' args_tail>

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

               f_arg: separated_by<Item = f_arg_item, Sep = ','>

                f_kw: tLABEL maybe<arg>

          f_block_kw: tLABEL maybe<primary>

       f_block_kwarg: separated_by<Item = f_block_kw, Sep = ','>

             f_kwarg: separated_by<Item = f_kw, Sep = ','>

            f_kwrest: '**' maybe<tIDENTIFIER>

               f_opt: tIDENTIFIER '=' arg

         f_block_opt: tIDENTIFIER '=' primary

      f_block_optarg: separated_by<Item = f_block_opt, Sep = ','>

            f_optarg: separated_by<Item = f_opt, Sep = ','>

          f_rest_arg: '*' maybe<tIDENTIFIER>

         f_block_arg: '&' tIDENTIFIER

     opt_f_block_arg: maybe<',' f_block_arg>

           singleton: var_ref_t
                    | '(' expr ')'

          assoc_list: separated_by<Item = assoc, Sep = ','>

               assoc: arg '=>' arg
                    | tLABEL maybe<arg>
                    | tSTRING_BEG string_contents tLABEL_END arg
                    | '**' arg
                    | '**'

           opt_terms: maybe<terms>

               terms: separated_by<Item = term_t, Sep = ';'>

                none: /* none */
