          opt_rescue: maybe1<T = _rescue>

             _rescue: 'rescue' _exc_list maybe1<T = _exc_var> then compstmt opt_rescue

           _exc_list: mrhs // items must be arguments
                    | none

            _exc_var: '=>' value  // value must be assignable
