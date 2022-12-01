               array: '[' _items ']'

                // There must be runtime validations:
                // 1. pairs go after values
                // 2. ',' requires non-empty list of items
              _items: separated_by<Item = _item, Sep = ','> maybe1<T = ','>

               _item: '*' value // value must be argument
                    | value // value must be argument
                    |
                    // pairs:
                    | value '=>' value // both values must be argument
                    | tLABEL maybe1<T = value> // value must be argument
                    | tSTRING_BEG string_contents tLABEL_END value // value must be argument
                    | '**' value // value must be argument
