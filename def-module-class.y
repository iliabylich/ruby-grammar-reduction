              module: 'module' _cpath bodystmt 'end'

               class: 'class' _cpath maybe1<T = _superclass> bodystmt 'end'
                    | 'class' '<<' value term_t bodystmt 'end' // value must be expression

         _superclass: '<' value term_t // value must be expression

              _cpath: maybe2<T1 = maybe1<T = value>, T2 = '::'> cname_t // value must be primary
