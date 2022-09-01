               defn_head: 'def' fname_t

               defs_head: 'def' singleton dot_or_colon_t fname_t

              method_def: defn_head f_arglist bodystmt 'end'
                        | defs_head f_arglist bodystmt 'end'

 endless_method_def_stmt: defn_head f_opt_paren_args '=' command maybe('rescue' arg)
                        | defs_head f_opt_paren_args '=' command maybe('rescue' arg)

  endless_method_def_arg: defn_head f_opt_paren_args '=' arg
                        | defn_head f_opt_paren_args '=' arg 'rescue' arg
                        | defs_head f_opt_paren_args '=' arg
                        | defs_head f_opt_paren_args '=' arg 'rescue' arg

