                op_t: '|'
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

         operation_t: tIDENTIFIER
                    | tCONSTANT
                    | tFID

        operation2_t: operation_t
                    | op_t

        operation3_t: tIDENTIFIER
                    | tFID
                    | op_

          reswords_t: '__LINE__'
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

             fname_t: tIDENTIFIER
                    | tCONSTANT
                    | tFID
                    | op_t
                    | reswords_t

             relop_t: '>'
                    | '<'
                    | '>='
                    | '<='

    simple_numeric_t: tINTEGER
                    | tFLOAT
                    | tRATIONAL
                    | tIMAGINARY

     user_variable_t: tIDENTIFIER
                    | tCONSTANT
                    | nonlocal_var_t

      nonlocal_var_t: tIVAR
                    | tGVAR
                    | tCVAR

  keyword_variable_t: 'nil'
                    | 'self'
                    | 'true'
                    | 'false'
                    | '__FILE__'
                    | '__LINE__'
                    | '__ENCODING__'

           var_ref_t: user_variable_t
                    | keyword_variable_t

           var_lhs_t: user_variable_t
                    | keyword_variable_t

           backref_t: tNTH_REF
                    | tBACK_REF

      dot_or_colon_t: '.'
                    | '::'

           call_op_t: '.'
                    | '&.'

          call_op2_t: '.'
                    | '&.'
                    | '::'

       method_name_t: tIDENTIFIER
                    | tCONSTANT

                do_t: term_t
                    | 'do'

              term_t: ';'
                    | '\n'
