         p_case_body: 'in' p_top_expr then compstmt p_cases

             p_cases: opt_else
                    | p_case_body

          p_top_expr: p_top_expr_body
                    | p_top_expr_body 'if' expr
                    | p_top_expr_body 'unless' expr

     p_top_expr_body: p_expr
                    | p_expr ','
                    | p_expr ',' p_args
                    | p_find
                    | p_args_tail
                    | p_kwargs

              p_expr: p_expr '=>' tIDENTIFIER
                    | p_alt

               p_alt: p_alt '|' p_expr_basic
                    | p_expr_basic

        p_expr_basic: p_value
                    | tIDENTIFIER
                    | p_const '(' p_args ')'
                    | p_const '(' p_find ')'
                    | p_const '(' p_kwargs ')'
                    | p_const '(' ')'
                    | p_const '[' p_args ']'
                    | p_const '[' p_find ']'
                    | p_const '[' p_kwargs ']'
                    | p_const '[' ']'
                    | '[' p_args ']'
                    | '[' p_find ']'
                    | '[' ']'
                    | '{' p_kwargs '}'
                    | '{' '}'
                    | '(' p_expr ')'

              p_args: p_expr
                    | p_args_head
                    | p_args_head p_expr
                    | p_args_head p_rest
                    | p_args_head p_rest ',' p_args_post
                    | p_args_tail

         p_args_head: p_expr ','
                    | p_args_head p_expr ','

         p_args_tail: p_rest
                    | p_rest ',' p_args_post

              p_find: p_rest ',' p_args_post ',' p_rest

              p_rest: '*' tIDENTIFIER
                    | '*'

         p_args_post: p_expr
                    | p_args_post ',' p_expr

            p_kwargs: p_kwarg ',' p_any_kwrest
                    | p_kwarg
                    | p_kwarg ','
                    | p_any_kwrest

             p_kwarg: p_kw
                    | p_kwarg ',' p_kw

                p_kw: p_kw_label p_expr
                    | p_kw_label

          p_kw_label: tLABEL
                    | tSTRING_BEG string_contents tLABEL_END

            p_kwrest: '**' tIDENTIFIER
                    | '**'

        p_any_kwrest: p_kwrest
                    | '**' 'nil'

             p_value: p_primitive
                    | p_primitive '..' p_primitive
                    | p_primitive '...' p_primitive
                    | p_primitive '..'
                    | p_primitive '...'
                    | p_var_ref
                    | p_expr_ref
                    | p_const
                    | '..' p_primitive
                    | '...' p_primitive

         p_primitive: numeric
                    | symbol
                    | strings
                    | xstring
                    | regexp
                    | words
                    | qwords
                    | symbols
                    | qsymbols
                    | keyword_variable
                    | lambda

           p_var_ref: '^' tIDENTIFIER
                    | '^' nonlocal_var

          p_expr_ref: '^' '(' expr ')'

             p_const: '::' cname
                    | p_const '::' cname
                    | tCONSTANT
