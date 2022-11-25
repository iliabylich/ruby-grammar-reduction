                mlhs: primary                 ',' _mlhs_list // primary must be assignable
                    | '*' maybe1<T = primary> ',' _mlhs_list // primary must be assignable
                    | '(' mlhs ')'

            // There must be runtime validations:
            // 1. the list can have only one splat
          _mlhs_list: separated_by<Item = _mlhs_item, Sep = ','>

          _mlhs_item: primary // primary must be assignable
                    | '*' maybe1<T = primary> // primary must be assignable
                    | '(' mlhs ')'
