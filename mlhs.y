                mlhs: mlhs_basic
                    | '(' mlhs_inner ')'

          mlhs_inner: mlhs_basic
                    | '(' mlhs_inner ')'

          mlhs_basic: mlhs_head maybe<mlhs_item>
                    | mlhs_head mlhs_splat maybe<mlhs_post>
                    | mlhs_splat maybe<mlhs_post>

          mlhs_splat: '*' maybe<lhs>

           mlhs_item: lhs
                    | '(' mlhs_inner ')'

           mlhs_head: repeat<mlhs_item ','>

           mlhs_post: repeat<',' mlhs_item>
