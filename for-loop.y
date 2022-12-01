            for_loop: 'for' _for_var 'in' value do_t compstmt 'end' // value must be expression

            _for_var: value // must be assignable
                    | mlhs
