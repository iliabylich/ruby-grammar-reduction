                       defn_head: 'def' fname_t

                       defs_head: 'def' singleton dot_or_colon_t fname_t

                        def_head: defn_head
                                | defs_head

                      method_def: def_head f_arglist bodystmt 'end'

        endless_method_def<Body>: def_head f_opt_paren_args '=' Body maybe('rescue' arg)
