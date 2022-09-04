    opt_block_params: maybe<block_params>

        block_params: '|' maybe(block_params1) maybe<';' block_params2> '|'

       // There must be a runtime check that ',' goes after a sole required argument
       block_params1: def_args maybe<','>

         lambda_args: '(' def_args maybe<';' block_params2> ')'
                    | def_args

       block_params2: separated_by<Item = tIDENTIFIER, Sep = ','>

            // There must be a runtime check that params are ordered
            // req -> opt -> (single) rest -> post -> kw[req/opt/rest] -> block
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

               _rest: '*' maybe<tIDENTIFIER>

              _kwarg: tLABEL

           _kwoptarg: tLABEL maybe<primary>

             _kwrest: '**' maybe<tIDENTIFIER>

           _blockarg: '&' tIDENTIFIER

          // There must must be a runtime check that restarg appears only once
          multi_args: separated_by<Item = multi_arg, Sep = ','>

           multi_arg: _arg
                    | _rest
