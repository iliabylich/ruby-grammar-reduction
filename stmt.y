           top_stmts: separated_by<Item = _stmt_or_begin, Sep = terms>

        top_compstmt: top_stmts opt_terms

              _stmts: separated_by<Item = _stmt_or_begin, Sep = terms>

            compstmt: _stmts opt_terms

            bodystmt: compstmt opt_rescue maybe2<T1 = 'else', T2 = compstmt> maybe2<T1 = 'ensure', T2 = compstmt>

      _stmt_or_begin: stmt
                    | preexe

                stmt: _stmt_head maybe1<T = _stmt_tail>

          _stmt_head: alias
                    | undef
                    | postexe
                    |
                    | endless_method_def<Return = command>
                    |
                    | primary '=' command_rhs // primary must be assignable
                    | primary '=' mrhs // primary must be assignable
                    | primary tOP_ASGN command_rhs // primary must be assignable
                    |
                    | mlhs '=' command_call
                    | mlhs '=' mrhs maybe2<T1 = 'rescue', T2 = stmt>
                    | mlhs '=' arg maybe2<T1 = 'rescue', T2 = stmt>
                    | expr

            // %nonassoc 'if' 'unless' 'while' 'until'
            // %left 'rescue'
          _stmt_tail: 'if'     expr
                    | 'unless' expr
                    | 'while'  expr
                    | 'until'  expr
                    | 'rescue' stmt
