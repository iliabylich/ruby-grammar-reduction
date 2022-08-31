                  op: '|'
                    | '^'
                    | '&'
                    | tCMP
                    | tEQ
                    | tEQQ
                    | tMATCH
                    | tNMATCH
                    | '>'
                    | '>='
                    | '<'
                    | '<='
                    | tNEQ
                    | tLSHFT
                    | tRSHFT
                    | '+'
                    | '-'
                    | '*'
                    | '*'
                    | '/'
                    | '%'
                    | '**'
                    | '**'
                    | '!'
                    | '~'
                    | tUPLUS
                    | tUMINUS
                    | tAREF
                    | tASET
                    | '`'

           operation: tIDENTIFIER
                    | tCONSTANT
                    | tFID

          operation2: operation
                    | op

          operation3: tIDENTIFIER
                    | tFID
                    | op

            reswords: '__LINE__'
                    | '__FILE__'
                    | '__ENCODING__'
                    | 'BEGIN'
                    | 'END'
                    | 'alias'
                    | 'and'
                    | 'begin'
                    | 'break'
                    | 'case'
                    | 'class'
                    | 'def'
                    | 'defined?'
                    | 'do'
                    | 'else'
                    | 'elsif'
                    | 'end'
                    | 'ensure'
                    | 'false'
                    | 'for'
                    | 'in'
                    | 'module'
                    | 'next'
                    | 'nil'
                    | 'not'
                    | 'or'
                    | 'redo'
                    | 'rescue'
                    | 'retry'
                    | 'return'
                    | 'self'
                    | 'super'
                    | 'then'
                    | 'true'
                    | 'undef'
                    | 'when'
                    | 'yield'
                    | 'if'
                    | 'unless'
                    | 'while'
                    | 'until'

               fname: tIDENTIFIER
                    | tCONSTANT
                    | tFID
                    | op
                    | reswords

               relop: '>'
                    | '<'
                    | '>='
                    | '<='

      simple_numeric: tINTEGER
                    | tFLOAT
                    | tRATIONAL
                    | tIMAGINARY

       user_variable: tIDENTIFIER
                    | tCONSTANT
                    | nonlocal_var

        nonlocal_var: tIVAR
                    | tGVAR
                    | tCVAR

    keyword_variable: 'nil'
                    | 'self'
                    | 'true'
                    | 'false'
                    | '__FILE__'
                    | '__LINE__'
                    | '__ENCODING__'

             backref: tNTH_REF
                    | tBACK_REF

           f_bad_arg: tCONSTANT
                    | tIVAR
                    | tGVAR
                    | tCVAR

          f_norm_arg: f_bad_arg
                    | tIDENTIFIER

        dot_or_colon: '.'
                    | '::'

             call_op: '.'
                    | '&.'

            call_op2: '.'
                    | '&.'
                    | '::'

                term: ';'
                    | '\n'
