             backref: tNTH_REF
                    | tBACK_REF

          call_op2_t: call_op_t
                    | '::'

           call_op_t: '.'
                    | '&.'

             cname_t: _id_or_const_t

                do_t: term_t
                    | 'do'

             fname_t: _id_or_const_t
                    | tFID
                    | _op_t
                    | _reswords_t

    keyword_variable: 'nil'
                    | 'self'
                    | 'true'
                    | 'false'
                    | '__FILE__'
                    | '__LINE__'
                    | '__ENCODING__'

        operation2_t: operation_t
                    | _op_t

        operation3_t: tIDENTIFIER
                    | tFID
                    | _op_t

         operation_t: _id_or_const_t
                    | tFID

      simple_numeric: tINTEGER
                    | tFLOAT
                    | tRATIONAL
                    | tIMAGINARY

         string_dvar: _nonlocal_var
                    | backref

               sym_t: fname_t
                    | tIVAR
                    | tGVAR
                    | tCVAR

              term_t: ';'
                    | '\n'

             var_ref: _user_variable
                    | keyword_variable

               _op_t: '|'
                    | '^'
                    | '&'
                    | '<=>'
                    | '=='
                    | '==='
                    | '=~'
                    | '!~'
                    | '>'
                    | '>='
                    | '<'
                    | '<='
                    | '!='
                    | '<<'
                    | '>>'
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
                    | '[]'
                    | '[]='
                    | '`'

         _reswords_t: '__LINE__'
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

      _user_variable: _id_or_const_t
                    | _nonlocal_var

       _nonlocal_var: tIVAR
                    | tGVAR
                    | tCVAR

      _id_or_const_t: tIDENTIFIER
                    | tCONSTANT
