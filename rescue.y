          opt_rescue: maybe<'rescue' exc_list exc_var then compstmt opt_rescue>

            exc_list: arg
                    | mrhs
                    | none

             exc_var: maybe<'=>' lhs>
