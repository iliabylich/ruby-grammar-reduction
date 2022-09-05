               array: '[' _items ']'

                // There must be runtime validations:
                // 1. pairs go after values
                // 2. ',' requires non-empty list of items
              _items: separated_by<Item = _item, Sep = ','> maybe<','>

               _item:
                    // values:
                    | '*' arg
                    | arg
                    |
                    // pairs:
                    | arg '=>' arg
                    | tLABEL maybe<arg>
                    | tSTRING_BEG string_contents tLABEL_END arg
                    | '**' arg
