                // There must be runtime validations:
                // 1. '**' is not allowed (it's for call args only)
                hash: '{' assocs '}'

              assocs: separated_by<Item = _assoc, Sep = ','>

              _assoc: arg '=>' arg
                    | tLABEL maybe1<T = arg>
                    | tSTRING_BEG string_contents tLABEL_END arg
                    | '**' arg
                    | '**'
