                mlhs: expr                 ',' _mlhs_list // expr must be assignable
                    | '*' maybe1<T = expr> ',' _mlhs_list // expr must be assignable
                    | '(' mlhs ')'

            // There must be runtime validations:
            // 1. the list can have only one splat
          _mlhs_list: separated_by<Item = _mlhs_item, Sep = ','>

          _mlhs_item: expr // expr must be assignable
                    | '*' maybe1<T = expr> // expr must be assignable
                    | '(' mlhs ')'
