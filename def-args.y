    opt_block_params: maybe<block_params>

        block_params: '|' maybe(block_params1) maybe<';' block_params2> '|'

       block_params1: f_arg ',' f_block_optarg ',' f_rest_arg opt_block_args_tail
                    | f_arg ',' f_block_optarg ',' f_rest_arg ',' f_arg opt_block_args_tail
                    | f_arg ',' f_block_optarg opt_block_args_tail
                    | f_arg ',' f_block_optarg ',' f_arg opt_block_args_tail
                    | f_arg ',' f_rest_arg opt_block_args_tail
                    | f_arg ','
                    | f_arg ',' f_rest_arg ',' f_arg opt_block_args_tail
                    | f_arg opt_block_args_tail
                    | f_block_optarg ',' f_rest_arg opt_block_args_tail
                    | f_block_optarg ',' f_rest_arg ',' f_arg opt_block_args_tail
                    | f_block_optarg opt_block_args_tail
                    | f_block_optarg ',' f_arg opt_block_args_tail
                    | f_rest_arg opt_block_args_tail
                    | f_rest_arg ',' f_arg opt_block_args_tail
                    | block_args_tail

 opt_block_args_tail: maybe<',' block_args_tail>

     block_args_tail: f_block_kwarg ',' f_kwrest opt_f_block_arg
                    | f_block_kwarg opt_f_block_arg
                    | f_any_kwrest opt_f_block_arg
                    | f_block_arg

         lambda_args: '(' def_args maybe<';' block_params2> ')'
                    | def_args

       block_params2: separated_by<Item = tIDENTIFIER, Sep = ','>

           args_tail: f_kwarg ',' f_kwrest opt_f_block_arg
                    | f_kwarg opt_f_block_arg
                    | f_any_kwrest opt_f_block_arg
                    | f_block_arg
                    | '...'

       opt_args_tail: maybe<',' args_tail>

            def_args: f_arg ',' f_optarg ',' f_rest_arg opt_args_tail
                    | f_arg ',' f_optarg ',' f_rest_arg ',' f_arg opt_args_tail
                    | f_arg ',' f_optarg opt_args_tail
                    | f_arg ',' f_optarg ',' f_arg opt_args_tail
                    | f_arg ',' f_rest_arg opt_args_tail
                    | f_arg ',' f_rest_arg ',' f_arg opt_args_tail
                    | f_arg opt_args_tail
                    | f_optarg ',' f_rest_arg opt_args_tail
                    | f_optarg ',' f_rest_arg ',' f_arg opt_args_tail
                    | f_optarg opt_args_tail
                    | f_optarg ',' f_arg opt_args_tail
                    | f_rest_arg opt_args_tail
                    | f_rest_arg ',' f_arg opt_args_tail
                    | args_tail

          f_arg_item: tIDENTIFIER
                    | '(' f_margs ')'

               f_arg: separated_by<Item = f_arg_item, Sep = ','>

                f_kw: tLABEL maybe<arg>

          f_block_kw: tLABEL maybe<primary>

       f_block_kwarg: separated_by<Item = f_block_kw, Sep = ','>

             f_kwarg: separated_by<Item = f_kw, Sep = ','>

            f_kwrest: '**' maybe<tIDENTIFIER>

               f_opt: tIDENTIFIER '=' arg

         f_block_opt: tIDENTIFIER '=' primary

      f_block_optarg: separated_by<Item = f_block_opt, Sep = ','>

            f_optarg: separated_by<Item = f_opt, Sep = ','>

          f_rest_arg: '*' maybe<tIDENTIFIER>

         f_block_arg: '&' tIDENTIFIER

     opt_f_block_arg: maybe<',' f_block_arg>
