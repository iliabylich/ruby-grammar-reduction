          opt_rescue: maybe1<T = _rescue>

             _rescue: 'rescue' _exc_list maybe1<T = _exc_var> then compstmt opt_rescue

           _exc_list: value // must be argument
                    | mrhs
                    | none

            _exc_var: '=>' value  // value must be assignable
