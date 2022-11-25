                mlhs: _mlhs_primitive ',' _mlhs_list
                    | '(' mlhs ')'

            // There must be runtime validations:
            // 1. the list can have only one splat
          _mlhs_list: separated_by<Item = _mlhs_item, Sep = ','>

     _mlhs_primitive: primary // primary must be assignable
                    | '*' maybe1<T = primary> // primary must be assignable

          _mlhs_item: _mlhs_primitive
                    | '(' mlhs ')'
