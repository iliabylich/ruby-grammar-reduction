          opt_rescue: maybe1<T = _rescue>

             _rescue: 'rescue' exc_list exc_var then compstmt opt_rescue

            exc_list: arg
                    | mrhs
                    | none

             exc_var: maybe2<T1 = '=>', T2 = lhs>
