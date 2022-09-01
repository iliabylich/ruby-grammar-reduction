               alias: 'alias' fitem fitem
                    | 'alias' tGVAR tGVAR
                    | 'alias' tGVAR tBACK_REF
                    | 'alias' tGVAR tNTH_REF

               undef: 'undef' fitem repeat<',' fitem>

               fitem: fname_t
                    | symbol
