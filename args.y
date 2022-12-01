                    // There must be runtime validations:
                    // 1. trailing ',' is allowed only after non-empty _arglist
                    // 2. '...' can be used only with elements
                    // 3. args are ordered:
                    //    [elements] -> [pairs] -> [block] -> ['...']
          paren_args: '(' maybe1<T = args> maybe1<T = ','> ')'
                    | '(' _arglist ',' '...' ')'
                    | '(' '...' ')'

      opt_paren_args: maybe1<T = paren_args>

                args: value // must be command
                    | _arglist

                    // Must have at least one element
                mrhs: separated_by<Item = _mrhs1, Sep = ','>

              _mrhs1: maybe1<T = '*'> value // value must be argument

            _arglist: separated_by<Item = _arg, Sep = ','>

                _arg: value // value must be argument
                    | '*' maybe1<T = value> // value must be argument
                    | '&' maybe1<T = value> // value must be argument
                    | assoc
