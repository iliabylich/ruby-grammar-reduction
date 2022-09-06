         p_case_body: 'in' _p_top_expr then compstmt _p_cases

            _p_cases: opt_else
                    | p_case_body

         _p_top_expr: p_top_expr_body
                    | p_top_expr_body 'if' expr
                    | p_top_expr_body 'unless' expr

     p_top_expr_body: _p_expr
                    | _p_expr ','
                    | _p_expr ',' _p_args
                    | _p_find
                    | _p_args_tail
                    | _p_kwargs

             _p_expr: _p_expr '=>' tIDENTIFIER
                    | _p_alt

              _p_alt: _p_alt '|' _p_expr_basic
                    | _p_expr_basic

       _p_expr_basic: _p_value
                    | tIDENTIFIER
                    | _p_const '(' _p_args ')'
                    | _p_const '(' _p_find ')'
                    | _p_const '(' _p_kwargs ')'
                    | _p_const '(' ')'
                    | _p_const '[' _p_args ']'
                    | _p_const '[' _p_find ']'
                    | _p_const '[' _p_kwargs ']'
                    | _p_const '[' ']'
                    | '[' _p_args ']'
                    | '[' _p_find ']'
                    | '[' ']'
                    | '{' _p_kwargs '}'
                    | '{' '}'
                    | '(' _p_expr ')'

             _p_args: _p_expr
                    | _p_args_head
                    | _p_args_head _p_expr
                    | _p_args_head _p_rest
                    | _p_args_head _p_rest ',' _p_args_post
                    | _p_args_tail

        _p_args_head: _p_expr ','
                    | _p_args_head _p_expr ','

        _p_args_tail: _p_rest
                    | _p_rest ',' _p_args_post

              _p_find: _p_rest ',' _p_args_post ',' _p_rest

             _p_rest: '*' tIDENTIFIER
                    | '*'

        _p_args_post: _p_expr
                    | _p_args_post ',' _p_expr

           _p_kwargs: _p_kwarg ',' _p_any_kwrest
                    | _p_kwarg
                    | _p_kwarg ','
                    | _p_any_kwrest

            _p_kwarg: _p_kw
                    | _p_kwarg ',' _p_kw

               _p_kw: _p_kw_label _p_expr
                    | _p_kw_label

         _p_kw_label: tLABEL
                    | tSTRING_BEG string_contents tLABEL_END

           _p_kwrest: '**' tIDENTIFIER
                    | '**'

       _p_any_kwrest: _p_kwrest
                    | '**' 'nil'

            _p_value: _p_primitive
                    | _p_primitive '..' _p_primitive
                    | _p_primitive '...' _p_primitive
                    | _p_primitive '..'
                    | _p_primitive '...'
                    | _p_var_ref
                    | _p_expr_ref
                    | _p_const
                    | '..' _p_primitive
                    | '...' _p_primitive

        _p_primitive: literal
                    | keyword_variable_t
                    | lambda

          _p_var_ref: '^' tIDENTIFIER
                    | '^' tIVAR
                    | '^' tGVAR
                    | '^' tCVAR

         _p_expr_ref: '^' '(' expr ')'

            _p_const: '::' cname_t
                    | _p_const '::' cname_t
                    | tCONSTANT
