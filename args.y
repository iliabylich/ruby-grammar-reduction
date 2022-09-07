          paren_args: '(' opt_call_args ')'
                    | '(' _args ',' '...' ')'
                    | '(' '...' ')'

      opt_paren_args: maybe1<T = paren_args>

       opt_call_args: none
                    | call_args
                    | _args ','
                    | _args ',' assocs ','
                    | assocs ','

           call_args: command
                    | _args _opt_block_arg
                    | assocs _opt_block_arg
                    | _args ',' assocs _opt_block_arg
                    | _block_arg

                mrhs: separated_by<Item = _mrhs1, Sep = ','>

              _mrhs1: maybe1<T = '*'> arg

               _args: arg
                    | '*' maybe1<T = arg>
                    | _args ',' arg
                    | _args ',' '*' maybe1<T = arg>

          _block_arg: '&' maybe1<T = arg>

      _opt_block_arg: maybe2<T1 = ',', T2 = _block_arg>
