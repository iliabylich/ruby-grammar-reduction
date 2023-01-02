              module: 'module' _cpath bodystmt 'end'

               class: 'class' _cpath maybe1<T = _superclass> bodystmt 'end'
                    | 'class' '<<' value term_t bodystmt 'end' // value must be expression

         _superclass: '<' value term_t // value must be expression

              _cpath: value // value must be primary and const-get
