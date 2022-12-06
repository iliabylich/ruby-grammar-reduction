             literal: _numeric
                    | symbol
                    | _strings
                    | _xstring
                    | _regexp
                    | _words
                    | _qwords
                    | _symbols
                    | _qsymbols

              symbol: tSYMBEG sym_t
                    | tSYMBEG string_contents tSTRING_END

     string_contents: repeat1<T = _string_content>

            _numeric: maybe1<T = '-'> simple_numeric

            _strings: tCHAR
                    | at_least_once<T = _string1>

            _string1: tSTRING_BEG string_contents tSTRING_END

            _xstring: tXSTRING_BEG string_contents tSTRING_END

             _regexp: tREGEXP_BEG string_contents tREGEXP_END

              _words: tWORDS_BEG separated_by<Item = _word, Sep = ' '> tSTRING_END

               _word: at_least_once<T = _string_content>

            _symbols: tSYMBOLS_BEG separated_by<Item = _word, Sep = ' '> tSTRING_END

             _qwords: tQWORDS_BEG separated_by<Item = tSTRING_CONTENT, item = ' '> tSTRING_END

           _qsymbols: tQSYMBOLS_BEG ' ' separated_by<Item = tSTRING_CONTENT, item = ' '> tSTRING_END

     _string_content: tSTRING_CONTENT
                    | tSTRING_DVAR string_dvar
                    | tSTRING_DBEG compstmt tSTRING_DEND

