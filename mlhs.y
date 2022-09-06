                mlhs: mlhs_primitive maybe2<T1 = ',', T2 = mlhs_list>
                    | '(' mlhs ')'

            // There must be runtime validations:
            // 1. the list can have only one splat
           mlhs_list: separated_by<Item = mlhs_item, Sep = ','>

      mlhs_primitive: lhs
                    | '*' maybe1<T = lhs>

           mlhs_item: mlhs_primitive
                    | '(' mlhs ')'
