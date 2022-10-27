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

         operation_t: _id_or_const_t
                    | tFID

        operation2_t: operation_t
                    | _op_t

        operation3_t: tIDENTIFIER
                    | tFID
                    | _op_t

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

             fname_t: _id_or_const_t
                    | tFID
                    | _op_t
                    | _reswords_t

    simple_numeric_t: tINTEGER
                    | tFLOAT
                    | tRATIONAL
                    | tIMAGINARY

     user_variable_t: _id_or_const_t
                    | _nonlocal_var_t

     _nonlocal_var_t: tIVAR
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

           backref_t: tNTH_REF
                    | tBACK_REF

             cname_t: _id_or_const_t

       string_dvar_t: _nonlocal_var_t
                    | backref_t

               sym_t: fname_t
                    | _nonlocal_var_t

           call_op_t: '.'
                    | '&.'

          call_op2_t: call_op_t
                    | '::'

      _id_or_const_t: tIDENTIFIER
                    | tCONSTANT

       method_name_t: _id_or_const_t

                do_t: term_t
                    | 'do'

              term_t: ';'
                    | '\n'
