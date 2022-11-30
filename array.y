               array: '[' _items ']'

                // There must be runtime validations:
                // 1. pairs go after values
                // 2. ',' requires non-empty list of items
              _items: separated_by<Item = _item, Sep = ','> maybe1<T = ','>

               _item: '*' expr // expr must be argument
                    | expr // expr must be argument
                    |
                    // pairs:
                    | expr '=>' expr // both expressions must be argument
                    | tLABEL maybe1<T = expr> // expr must be argument
                    | tSTRING_BEG string_contents tLABEL_END expr // expr must be argument
                    | '**' expr // expr must be argument
