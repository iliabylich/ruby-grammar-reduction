                mlhs: mlhs_basic
                    | '(' mlhs_inner ')'

          mlhs_inner: mlhs_basic
                    | '(' mlhs_inner ')'

          mlhs_basic: mlhs_head
                    | mlhs_head mlhs_item
                    | mlhs_head mlhs_splat
                    | mlhs_head mlhs_splat mlhs_post
                    | mlhs_splat
                    | mlhs_splat mlhs_post

          mlhs_splat: '*' lhs
                    | '*'

           mlhs_item: lhs
                    | '(' mlhs_inner ')'

           mlhs_head: repeat<mlhs_item ','>

           mlhs_post: repeat<',' mlhs_item>
