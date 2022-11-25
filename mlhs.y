                mlhs: _mlhs_primitive _mlhs_chain
                    | '(' mlhs ')'

         _mlhs_chain: maybe2<T1 = ',', T2 = _mlhs_list>

            // There must be runtime validations:
            // 1. the list can have only one splat
          _mlhs_list: separated_by<Item = _mlhs_item, Sep = ','>

     _mlhs_primitive: lhs
                    | '*' maybe1<T = lhs>

          _mlhs_item: _mlhs_primitive
                    | '(' mlhs ')'
