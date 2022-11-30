                // There must be runtime validations:
                // 1. '**' is not allowed (it's for call args only)
                hash: '{' _assocs '}'

             _assocs: separated_by<Item = assoc, Sep = ','>

               assoc: expr '=>' expr // both expressions must be arguments
                    | tLABEL maybe1<T = expr> // expr must be argument
                    | tSTRING_BEG string_contents tLABEL_END expr // expr must be argument
                    | '**' expr // expr must be argument
                    | '**'
