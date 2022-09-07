                    // There must be runtime validations:
                    // 1. trailing ',' is allowed only if arglist is not empty
          paren_args: '(' maybe1<T = call_args> maybe1<T = ','> ')'
                    | '(' _args ',' '...' ')'
                    | '(' '...' ')'

      opt_paren_args: maybe1<T = paren_args>

           call_args: command
                    | _call_args1

         _call_args1: _args _opt_block_arg
                    | assocs _opt_block_arg
                    | _args ',' assocs _opt_block_arg
                    | _block_arg

                mrhs: separated_by<Item = _mrhs1, Sep = ','>

              _mrhs1: maybe1<T = '*'> arg

               _args: separated_by<Item = _arg, Sep = ','>

                _arg: arg
                    | '*' maybe1<T = arg>

          _block_arg: '&' maybe1<T = arg>

      _opt_block_arg: maybe2<T1 = ',', T2 = _block_arg>
