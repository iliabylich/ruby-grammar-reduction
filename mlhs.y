                mlhs: value                 ',' _mlhs_list // value must be assignable
                    | '*' maybe1<T = value> ',' _mlhs_list // value must be assignable
                    | '(' mlhs ')'

            // There must be runtime validations:
            // 1. the list can have only one splat
          _mlhs_list: separated_by<Item = _mlhs_item, Sep = ','>

          _mlhs_item: value // value must be assignable
                    | '*' maybe1<T = value> // value must be assignable
                    | '(' mlhs ')'
