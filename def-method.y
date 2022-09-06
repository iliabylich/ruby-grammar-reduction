                       defn_head: 'def' fname_t

                       defs_head: 'def' singleton dot_or_colon_t fname_t

                        def_head: defn_head
                                | defs_head

                      method_def: def_head method_def_args bodystmt 'end'

                 method_def_args: '(' maybe1<T = def_args> ')'
                                | maybe1<T = def_args> term_t

        endless_method_def<Body>: def_head endless_method_args '=' Body maybe2<T1 = 'rescue', T2 = arg>

             endless_method_args: maybe3<T1 = '(', T2 = maybe1<T = def_args>, T3 = ')'>
