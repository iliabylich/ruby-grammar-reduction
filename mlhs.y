                mlhs: mlhs_basic
                    | '(' mlhs_inner ')'

          mlhs_inner: mlhs_basic
                    | '(' mlhs_inner ')'

          mlhs_basic: separated_by<Item = mlhs_item, Sep = ','>
                    | repeat<mlhs_item ','> mlhs_splat maybe<mlhs_post>
                    | mlhs_splat maybe<mlhs_post>

          mlhs_splat: '*' maybe<lhs>

           mlhs_item: lhs
                    | '(' mlhs_inner ')'

           mlhs_post: repeat<',' mlhs_item>
