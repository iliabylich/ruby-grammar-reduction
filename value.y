                    // Value is assignable if it is:
                    // 1. backref
                    // 2. local/instance/class/global variable
                    // 3. constant (with **any** scope)
                    // 4. indexasgn
                    // 5. fcall
                    //
                    // Value is primary if it is:
                    // 1. literal (numer/sym/str/array/hash)
                    // 2. local/instance/class/global variable
                    // 3. backref
                    // 4. tFID-based method call
                    // 5. begin..end
                    // 6. (value/compstmt/nothing)
                    // 7. global constant or const defined on a primary
                    // 8. not (value?) where value must be expression
                    // 9. fcall maybe with brace block if receiver is also primry
                    // 10. super/yield in fcall mode
                    // 11. break/next/redo/retry with no arguments
                    // 12. lambda
                    // 13. if/unless (non-modifier)
                    // 14. for loop
                    // 15. while/until (non-modifier)
                    // 16. class/module definition
                    // 17. method definition
                    // 18. indexasgn if receiver is also primary
                    //
                    // Value is an argument ALWAYS if it's not:
                    // 1. command (i.e. a method call with argument but without parentheses)
                    // 2. 'not value'
                    // 3. '!' command
                    // 4. '=>' or 'in' one-line pattern-matching
                    // 5. binary operation 'and' / 'or'
                    // 6. super/yield/return/break/next in command mode
                    //
                    // Value is an expression ALWAYS if it's not:
                    // 1. mass-assignment
                    // 2. alias/undef/postexe
                    //
                    // Value is a command if:
                    // 1. it is a method call with arguments but without parentheses
                    // 2. super/yield/return/break next -.-
                    //
               value: value _assignment_t value // LHS must be assignable, RHS must be argument
                    | value '=' mrhs            // LHS must be assignable
                    |
                    | mlhs '=' mrhs
                    | mlhs '=' value // RHS must be expression or comand
                    |
                    | value '..'  value // LHS and RHS must be arguments
                    | value '...' value // LHS and RHS must be arguments
                    | value '+'   value // LHS and RHS must be arguments
                    | value '-'   value // LHS and RHS must be arguments
                    | value '*'   value // LHS and RHS must be arguments
                    | value '/'   value // LHS and RHS must be arguments
                    | value '%'   value // LHS and RHS must be arguments
                    | value '**'  value // LHS and RHS must be arguments
                    | value '|'   value // LHS and RHS must be arguments
                    | value '^'   value // LHS and RHS must be arguments
                    | value '&'   value // LHS and RHS must be arguments
                    | value '<=>' value // LHS and RHS must be arguments
                    | value '=='  value // LHS and RHS must be arguments
                    | value '===' value // LHS and RHS must be arguments
                    | value '!='  value // LHS and RHS must be arguments
                    | value '=~'  value // LHS and RHS must be arguments
                    | value '!~'  value // LHS and RHS must be arguments
                    | value '<<'  value // LHS and RHS must be arguments
                    | value '>>'  value // LHS and RHS must be arguments
                    | value '&&'  value // LHS and RHS must be arguments
                    | value '||'  value // LHS and RHS must be arguments
                    | value '>'   value // LHS and RHS must be arguments
                    | value '<'   value // LHS and RHS must be arguments
                    | value '>='  value // LHS and RHS must be arguments
                    | value '<='  value // LHS and RHS must be arguments
                    |
                    | value '..'       // LHS must be argument
                    | value '...'      // LHS must be argument
                    |
                    | '..'  value     // RHS must be argument
                    | '...' value     // RHS must be argument
                    | '+'   value     // RHS must be argument
                    | '-'   value     // RHS must be argument
                    | '!'   value     // RHS must be argument or command
                    | '~'   value     // RHS must be argument
                    |
                    | 'not' value     // value must be expression
                    |
                    | 'defined?' value // value must be argument
                    |
                    | '-' simple_numeric '**' value // RHS must be argument
                    |
                    | value '?' value ':' value // LHS, MHS and RHS must be arguments
                    |
                    | value 'and' value // both must be expressions
                    | value 'or'  value // both must be expressions
                    |
                    | value '=>' p_top_expr_body // LHS must be argument
                    | value 'in' p_top_expr_body // LHS must be argument
                    |
                    | value 'if'     value // RHS must be expression
                    | value 'unless' value // RHS must be expression
                    | value 'while'  value // RHS must be expression
                    | value 'until'  value // RHS must be expression
                    | // if LHS is (mass-)assignment it should be re-grouped to `lhs = (rhs rescue value)`
                    | value 'rescue' value
                    |
                    | _value0 repeat1<T = _call_tail> // value must be expression

             _value0: _var_ref_or_method_call
                    |
                    | literal
                    | array
                    | hash
                    | backref
                    | 'begin' bodystmt 'end'
                    | '(' maybe1<T = compstmt> ')'
                    | '::' tCONSTANT
                    | 'not' '(' maybe1<T = value> ')' // value must be expression
                    |
                    | lambda
                    |
                    | if_stmt
                    | unless_stmt
                    |
                    | 'while'  value do_t compstmt 'end' // value must be expression
                    | 'until'  value do_t compstmt 'end' // value must be expression
                    |
                    | case
                    |
                    | for_loop
                    |
                    | class
                    | module
                    |
                    | method_def
                    |
                    | keyword_cmd
                    |
                    | endless_method_def
                    |
                    | alias
                    | undef
                    | postexe

          _call_tail: // '::' tCONSTANT <any block> with no args is not allowed (and it's a const access)
                    | dot_or_colon2_t _method_name_t   call_args maybe_block
                    |
                    | dot_or_colon2_t                 paren_args maybe_block
                    |
                    | _aref_args                         maybe_block

      _method_name_t: tIDENTIFIER
                    | tCONSTANT
                    | tFID
                    | op_t

                         // `operation_t` and `var_ref` have an overlap
_var_ref_or_method_call: operation_t call_args maybe_block
                       | var_ref
                       | tFID

                    // There must be runtime validations:
                    // 1. trailing ',' is allowed only if arglist is not empty
          _aref_args: '[' maybe1<T = args> maybe1<T = ','> ']'

       _assignment_t: '='
                    | tOP_ASGN
