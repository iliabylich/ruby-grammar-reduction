                mlhs: mlhs_basic
                    | '(' mlhs_inner ')'

          mlhs_inner: mlhs_basic
                    | '(' mlhs_inner ')'

          mlhs_basic: repeat<mlhs_item ','> maybe<mlhs_item>
                    | repeat<mlhs_item ','> mlhs_splat maybe<mlhs_post>
                    | mlhs_splat maybe<mlhs_post>

          mlhs_splat: '*' maybe<lhs>

           mlhs_item: lhs
                    | '(' mlhs_inner ')'

           mlhs_post: repeat<',' mlhs_item>
