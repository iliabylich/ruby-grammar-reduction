                mlhs: mlhs_list
                    | '(' mlhs_inner ')'

          mlhs_inner: mlhs_list
                    | '(' mlhs_inner ')'

        // Runtime validation: this list can have only one splat
           mlhs_list: separated_by<Item = mlhs_item, Sep = ','>

           mlhs_item: lhs
                    | '*' maybe<lhs>
                    | '(' mlhs_inner ')'
