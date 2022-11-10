                case: 'case' expr opt_terms _case_body 'end'
                    | 'case' opt_terms _case_body 'end'
                    | 'case' expr opt_terms p_case_body 'end'

          _case_args: separated_by<Item = _case_arg, Sep = ','>

           _case_arg: maybe1<T = '*'> arg

          _case_body: 'when' _case_args then compstmt _cases

              _cases: opt_else
                    | _case_body
