    opt_block_params: maybe1<T = block_params>

        block_params: '|' maybe1<T = block_params1> maybe2<T1 = ';', T2 = block_params2> '|'

        // There must be runtime validations:
        // 1. ',' is allowed after a sole required argument
       block_params1: def_args maybe1<T = ','>

         lambda_args: '(' def_args maybe2<T1 = ';', T2 = block_params2> ')'
                    | def_args

       block_params2: separated_by<Item = tIDENTIFIER, Sep = ','>

            // There must be runtime validations:
            // 1. params are ordered
            //    req -> opt -> (single) rest -> post -> kw[req/opt/rest] -> block
            def_args: separated_by<Item = def_arg, Sep = ','>

             def_arg: _arg
                    | _optarg
                    | _rest
                    | _arg
                    | _kwarg
                    | _kwoptarg
                    | _kwrest
                    | _blockarg

                _arg: tIDENTIFIER
                    | '(' multi_args ')'

             _optarg: tIDENTIFIER '=' primary

               _rest: '*' maybe1<T = tIDENTIFIER>

              _kwarg: tLABEL

           _kwoptarg: tLABEL maybe1<T = primary>

             _kwrest: '**' maybe1<T = tIDENTIFIER>

           _blockarg: '&' tIDENTIFIER

          // There must be runtime validations:
          // 1. restarg appears only once
          multi_args: separated_by<Item = multi_arg, Sep = ','>

           multi_arg: _arg
                    | _rest
