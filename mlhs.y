                mlhs: mlhs_basic
                    | '(' mlhs_inner ')'

          mlhs_inner: mlhs_basic
                    | '(' mlhs_inner ')'

          mlhs_basic: mlhs_head
                    | mlhs_head mlhs_item
                    | mlhs_head '*' lhs
                    | mlhs_head '*' lhs ',' mlhs_post
                    | mlhs_head '*'
                    | mlhs_head '*' ',' mlhs_post
                    | '*' lhs
                    | '*' lhs ',' mlhs_post
                    | '*'
                    | '*' ',' mlhs_post

           mlhs_item: lhs
                    | '(' mlhs_inner ')'

           mlhs_head: mlhs_item ','
                    | mlhs_head mlhs_item ','

           mlhs_post: mlhs_item
                    | mlhs_post ',' mlhs_item
