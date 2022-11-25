                expr: _expr_head _expr_tail

          _expr_head: command_call
                    | 'not' expr
                    | '!' command_call
                    | arg '=>' p_top_expr_body
                    | arg 'in' p_top_expr_body
                    | arg

          _expr_tail: 'and' expr
                    | 'or' expr
