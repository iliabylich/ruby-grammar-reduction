                    // There must be runtime validations:
                    // 1. trailing ',' is allowed only after non-empty _args
                    // 2. '...' can be used only with elements
                    // 3. args are ordered:
                    //    [elements] -> [pairs] -> [block] -> ['...']
          paren_args: '(' maybe1<T = call_args> maybe1<T = ','> ')'
                    | '(' _args ',' '...' ')'
                    | '(' '...' ')'

      opt_paren_args: maybe1<T = paren_args>

           call_args: command
                    | _args

                mrhs: separated_by<Item = _mrhs1, Sep = ','>

              _mrhs1: maybe1<T = '*'> arg

               _args: separated_by<Item = _arg, Sep = ','>

                _arg: arg
                    | '*' maybe1<T = arg>
                    | '&' maybe1<T = arg>
                    | assoc
