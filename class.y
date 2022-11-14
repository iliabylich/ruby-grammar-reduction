               class: 'class' cpath _superclass bodystmt 'end'
                    | 'class' '<<' expr term_t bodystmt 'end'

         _superclass: maybe3<T1 = '<', T2 = expr, T3 = term_t>
