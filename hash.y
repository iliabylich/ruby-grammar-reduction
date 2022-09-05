                // There must be runtime validations:
                // 1. '**' is not allowed (it's for call args only)
                hash: '{' assocs '}'

              assocs: separated_by<Item = assoc, Sep = ','>

               assoc: arg '=>' arg
                    | tLABEL maybe<arg>
                    | tSTRING_BEG string_contents tLABEL_END arg
                    | '**' arg
                    | '**'
