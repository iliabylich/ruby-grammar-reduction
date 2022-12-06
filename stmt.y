           top_stmts: separated_by<Item = _value_or_preexe, Sep = _terms>

            compstmt: separated_by<Item = _value_or_preexe, Sep = _terms> opt_terms

            bodystmt: compstmt opt_rescue opt_else maybe2<T1 = 'ensure', T2 = compstmt>

           opt_terms: maybe1<T = _terms>

    _value_or_preexe: value
                    | preexe

              _terms: separated_by<Item = term_t, Sep = ';'>
