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

                stmt: stmt_head maybe<stmt_tail>

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
                    | mlhs '=' mrhs maybe<'rescue' stmt>
                    | mlhs '=' arg maybe<'rescue' stmt>
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


         command_rhs: command_call maybe<'rescue' stmt>
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

     cmd_brace_block: '{' opt_block_params compstmt '}'

             command: operation_t call_args maybe<cmd_brace_block>
                    | primary call_op_t operation2_t call_args maybe<cmd_brace_block>
                    | primary '::' operation2_t call_args maybe<cmd_brace_block>
                    |
                    | keyword_cmd<Token = 'super',  Args = call_args>
                    | keyword_cmd<Token = 'yield',  Args = call_args>
                    | keyword_cmd<Token = 'return', Args = call_args>
                    | keyword_cmd<Token = 'break',  Args = call_args>
                    | keyword_cmd<Token = 'next',   Args = call_args>

               cpath: '::' cname_t
                    | cname_t
                    | primary '::' cname_t

                 arg: lhs '=' arg_rhs
                    |
                    | lhs tOP_ASGN = arg_rhs
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
                    | keyword_cmd<Keyword = 'defined?', Args = arg>
                    |
                    | arg '?' arg ':' arg
                    |
                    | endless_method_def<Return = arg>
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

                mrhs: args ',' arg
                    | args ',' '*' arg
                    | '*' arg

             primary: literal
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
                    | keyword_cmd<Keyword = 'break', Args = none>
                    | keyword_cmd<Keyword = 'next',  Args = none>
                    | keyword_cmd<Keyword = 'redo',  Args = none>
                    | keyword_cmd<Keyword = 'retry', Args = none>
                    | keyword_cmd<Keyword = 'return', Args = none>
                    | keyword_cmd<Keyword = 'yield', Args = '(' call_args ')'>
                    | keyword_cmd<Keyword = 'yield', Args = '(' ')'>
                    | keyword_cmd<Keyword = 'yield', Args = None>
                    | keyword_cmd<Keyword = 'defined?', Args = '(' expr ')'>

                then: maybe<term_t> maybe<'then'>

             if_tail: opt_else
                    | 'elsif' expr then compstmt if_tail

            opt_else: none
                    | 'else' compstmt

             for_var: lhs
                    | mlhs

              lambda: tLAMBDA lambda_args lambda_body

         lambda_body: tLAMBEG compstmt '}'
                    | kDO_LAMBDA bodystmt 'end'

          block_call: command 'do' opt_block_params bodystmt 'end'
                    | block_call call_op2_t operation2_t opt_paren_args
                    | block_call call_op2_t operation2_t opt_paren_args brace_block
                    | block_call call_op2_t operation2_t call_args 'do' opt_block_params bodystmt 'end'

         method_call: operation_t paren_args
                    | primary call_op_t operation2_t opt_paren_args
                    | primary '::' operation2_t paren_args
                    | primary '::' operation3_t
                    | primary call_op_t paren_args
                    | primary '::' paren_args
                    | primary '[' opt_call_args ']'
                    |
                    | keyword_cmd<Keyword = 'super', Args = paren_args>
                    | keyword_cmd<Keyword = 'super', Args = none>

         brace_block: '{'  opt_block_params compstmt '}'
                    | 'do' opt_block_params bodystmt 'end'

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

          superclass: maybe<'<' expr term_t>

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
