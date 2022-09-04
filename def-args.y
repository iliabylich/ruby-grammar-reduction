    opt_block_params: maybe<block_params>

        block_params: '|' maybe(block_params1) maybe<';' block_params2> '|'

      // There must be a runtime check that ',' goes after a sole required argument
       block_params1: def_args maybe<','>

         lambda_args: '(' def_args maybe<';' block_params2> ')'
                    | def_args

       block_params2: separated_by<Item = tIDENTIFIER, Sep = ','>

            // There must be a runtime check that params are ordered
            // req -> opt -> rest -> post -> kw[req/opt/rest] -> block
            def_args: separated_by<Item = def_arg, Sep = ','>

             def_arg: required_arg
                    | optional_arg
                    | rest_arg
                    | required_arg
                    | required_kwarg
                    | optional_kwarg
                    | kwrest_arg
                    | block_arg

        required_arg: tIDENTIFIER
                    | '(' f_margs ')'

        optional_arg: tIDENTIFIER '=' primary

            rest_arg: '*' maybe<tIDENTIFIER>

      required_kwarg: tLABEL

      optional_kwarg: tLABEL maybe<primary>

          kwrest_arg: '**' maybe<tIDENTIFIER>

           block_arg: '&' tIDENTIFIER
