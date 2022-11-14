                expr: command_call
                    | expr 'and' expr
                    | expr 'or'  expr
                    | 'not' expr
                    | '!' command_call
                    | arg '=>' p_top_expr_body
                    | arg 'in' p_top_expr_body
                    | arg
