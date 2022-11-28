             if_stmt: 'if'     expr then compstmt _if_tail 'end'

         unless_stmt: 'unless' expr then compstmt opt_else 'end'

            _if_tail: opt_else
                    | 'elsif' expr then compstmt _if_tail

            opt_else: maybe2<T1 = 'else', T2 = compstmt>

                then: maybe1<T = term_t> maybe1<T = 'then'>
