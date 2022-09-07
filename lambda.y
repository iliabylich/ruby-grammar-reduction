              lambda: tLAMBDA _lambda_args _lambda_body

        _lambda_body: tLAMBEG compstmt '}'
                    | kDO_LAMBDA bodystmt 'end'

        _lambda_args: '(' params maybe2<T1 = ';', T2 = _block_params2> ')'
                    | params
