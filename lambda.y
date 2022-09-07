              lambda: tLAMBDA lambda_args lambda_body

         lambda_body: tLAMBEG compstmt '}'
                    | kDO_LAMBDA bodystmt 'end'

         lambda_args: '(' def_args maybe2<T1 = ';', T2 = _block_params2> ')'
                    | def_args
