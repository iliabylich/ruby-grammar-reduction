          opt_rescue: maybe1<T = _rescue>

             _rescue: 'rescue' _exc_list _exc_var then compstmt opt_rescue

           _exc_list: arg
                    | mrhs
                    | none

            _exc_var: maybe2<T1 = '=>', T2 = lhs>
