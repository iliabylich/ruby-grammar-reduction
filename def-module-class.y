              module: 'module' _cpath bodystmt 'end'

               class: 'class' _cpath _superclass bodystmt 'end'
                    | 'class' '<<' value term_t bodystmt 'end' // value must be expression

         _superclass: maybe3<T1 = '<', T2 = value, T3 = term_t> // value must be expression

              _cpath: maybe2<T1 = maybe1<T = value>, T2 = '::'> cname_t // value must be primary
