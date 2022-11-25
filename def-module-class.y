              module: 'module' _cpath bodystmt 'end'

               class: 'class' _cpath _superclass bodystmt 'end'
                    | 'class' '<<' expr term_t bodystmt 'end'

         _superclass: maybe3<T1 = '<', T2 = expr, T3 = term_t>

              _cpath: maybe2<T1 = maybe1<T = primary>, T2 = '::'> cname_t
