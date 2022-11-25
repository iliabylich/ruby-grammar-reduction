            for_loop: 'for' _for_var 'in' expr do_t compstmt 'end'

            _for_var: primary // assignable
                    | mlhs
