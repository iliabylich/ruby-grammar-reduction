                      _defn_head: 'def' fname_t

                      _defs_head: 'def' singleton dot_or_colon_t fname_t

                       _def_head: _defn_head
                                | _defs_head

                      method_def: _def_head _method_def_args bodystmt 'end'

                _method_def_args: '(' maybe1<T = def_args> ')'
                                | maybe1<T = def_args> term_t

        endless_method_def<Body>: _def_head _endless_method_args '=' Body maybe2<T1 = 'rescue', T2 = arg>

            _endless_method_args: maybe3<T1 = '(', T2 = maybe1<T = def_args>, T3 = ')'>
