                mlhs: mlhs_basic
                    | '(' mlhs_inner ')'

          mlhs_inner: mlhs_basic
                    | '(' mlhs_inner ')'

        // Runtime validation: this list can have only one splat
          mlhs_basic: separated_by<Item = mlhs_item, Sep = ','>

           mlhs_item: lhs
                    | '*' maybe<lhs>
                    | '(' mlhs_inner ')'
