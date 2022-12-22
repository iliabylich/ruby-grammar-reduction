               block: _brace_block
                    | _do_block // can be chained ONLY if there's no outer command

           _do_block: 'do' _opt_block_params bodystmt 'end'

        _brace_block: '{' _opt_block_params compstmt '}'

   _opt_block_params: maybe1<T = _block_params>

       _block_params: '|' maybe1<T = _block_params1> maybe2<T1 = ';', T2 = _block_params2> '|'

        // There must be runtime validations:
        // 1. ',' is allowed if there's no rest argument
      _block_params1: params maybe1<T = ','>

      _block_params2: separated_by<Item = tIDENTIFIER, Sep = ','>
