                // There must be runtime validations:
                // 1. '**' is not allowed (it's for call args only)
                hash: '{' _assocs '}'

              _assoc: value '=>' value // both values must be arguments
                    | tLABEL maybe1<T = value> // value must be argument
                    | tSTRING_BEG string_contents tLABEL_END value // value must be argument
                    | '**' value // value must be argument
                    | '**'

             _assocs: separated_by<Item = _assoc, Sep = ','>
