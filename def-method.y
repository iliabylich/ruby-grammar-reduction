                      method_def: _def_head _method_def_args bodystmt 'end'

        endless_method_def<Body>: _def_head maybe1<T = _endless_method_args> '=' Body maybe2<T1 = 'rescue', T2 = value> // value must be argument

                       _def_head: 'def' fname_t
                                | 'def' _singleton _dot_or_colon_t fname_t

                _method_def_args: _parenthesized_args
                                | _open_args

                      _open_args: maybe1<T = params> term_t

             _parenthesized_args: '(' maybe1<T = params> ')'

            _endless_method_args: _parenthesized_args

                      _singleton: var_ref
                                | '(' value ')' // value must be expression

                 _dot_or_colon_t: '.'
                                | '::'

