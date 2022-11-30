          opt_rescue: maybe1<T = _rescue>

             _rescue: 'rescue' _exc_list maybe1<T = _exc_var> then compstmt opt_rescue

           _exc_list: arg
                    | mrhs
                    | none

            _exc_var: '=>' primary  // primary must be assignable
