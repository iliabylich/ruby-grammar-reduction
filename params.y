            // There must be runtime validations:
            // 1. params are ordered
            //    req -> opt -> (single) rest -> post -> kw[req/opt/rest] -> block
              params: separated_by<Item = _param, Sep = ','>

              _param: _arg
                    | _optarg
                    | _rest
                    | _arg
                    | _kwarg
                    | _kwoptarg
                    | _kwrest
                    | _blockarg

                _arg: tIDENTIFIER
                    | '(' _multi_args ')'

             _optarg: tIDENTIFIER '=' value // value must be primary

               _rest: '*' maybe1<T = tIDENTIFIER>

              _kwarg: tLABEL

           _kwoptarg: tLABEL value // value must be primary

             _kwrest: '**' maybe1<T = tIDENTIFIER>

           _blockarg: '&' tIDENTIFIER

          // There must be runtime validations:
          // 1. restarg appears only once
         _multi_args: separated_by<Item = _multi_arg, Sep = ','>

          _multi_arg: _arg
                    | _rest
