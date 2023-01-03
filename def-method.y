                      method_def: _def_head _method_def_args bodystmt 'end'

                                // body must be argument or command, rescue value must argument
              endless_method_def: _def_head maybe1<T = _parenthesized_args> '=' value maybe2<T1 = 'rescue', T2 = value>

                       _def_head: 'def' fname_t
                                | 'def' _singleton _dot_or_colon_t fname_t

                _method_def_args: _parenthesized_args
                                | _open_args

                      _open_args: maybe1<T = params> term_t

             _parenthesized_args: '(' maybe1<T = params> ')'

                      _singleton: var_ref
                                | '(' value ')' // value must be expression

                 _dot_or_colon_t: '.'
                                | '::'

