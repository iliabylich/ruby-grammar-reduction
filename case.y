                case: 'case' value opt_terms _case_body 'end' // value must be expression
                    | 'case' opt_terms _case_body 'end'
                    | 'case' value opt_terms p_case_body 'end' // value must be expression

          _case_args: separated_by<Item = _case_arg, Sep = ','>

           _case_arg: maybe1<T = '*'> value // value must be argument

          _case_body: 'when' _case_args then compstmt _cases

              _cases: opt_else
                    | _case_body
