                mlhs: mlhs_primitive maybe<',' mlhs_list>
                    | '(' mlhs ')'

        // Runtime validation: this list can have only one splat
           mlhs_list: separated_by<Item = mlhs_item, Sep = ','>

      mlhs_primitive: lhs
                    | '*' maybe<lhs>

           mlhs_item: mlhs_primitive
                    | '(' mlhs ')'
