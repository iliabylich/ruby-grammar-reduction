                      method_def: _def_head _method_def_args bodystmt 'end'

        endless_method_def<Body>: _def_head _endless_method_args '=' Body maybe2<T1 = 'rescue', T2 = value> // value must be argument

                      _defn_head: 'def' fname_t

                      _defs_head: 'def' _singleton _dot_or_colon_t fname_t

                       _def_head: _defn_head
                                | _defs_head

                _method_def_args: '(' maybe1<T = params> ')'
                                | maybe1<T = params> term_t

            _endless_method_args: maybe3<T1 = '(', T2 = maybe1<T = params>, T3 = ')'>

                      _singleton: var_ref
                                | '(' value ')' // value must be expression

                 _dot_or_colon_t: '.'
                                | '::'

