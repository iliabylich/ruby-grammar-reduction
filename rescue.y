          opt_rescue: repeat1<T = _rescue>

             _rescue: 'rescue' _exc_list maybe1<T = _exc_var> then compstmt

           _exc_list: mrhs // items must be arguments
                    | none

            _exc_var: '=>' value  // value must be assignable
