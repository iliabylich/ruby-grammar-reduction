program: top_compstmt

top_compstmt: top_stmts opt_terms

top_stmts: none
        | top_stmt
        | top_stmts terms top_stmt
        | error top_stmt

top_stmt: stmt
        | keyword_BEGIN begin_block

begin_block: '{' top_compstmt '}'

bodystmt: compstmt opt_rescue k_else compstmt opt_ensure
        | compstmt opt_rescue opt_ensure

compstmt: stmts opt_terms

stmts: none
        | stmt_or_begin
        | stmts terms stmt_or_begin
        | error stmt

stmt_or_begin: stmt keyword_BEGIN begin_block

stmt: keyword_alias fitem fitem
        | keyword_alias tGVAR tGVAR
        | keyword_alias tGVAR tBACK_REF
        | keyword_alias tGVAR tNTH_REF
        | keyword_undef undef_list
        | stmt modifier_if expr_value
        | stmt modifier_unless expr_value
        | stmt modifier_while expr_value
        | stmt modifier_until expr_value
        | stmt modifier_rescue stmt
        | keyword_END '{' compstmt '}'
        | command_asgn
        | mlhs '=' lex_ctxt command_call
        | lhs '=' lex_ctxt mrhs
        | mlhs '=' lex_ctxt mrhs_arg modifier_rescue stmt
        | mlhs '=' lex_ctxt mrhs_arg
        | expr

command_asgn: lhs '=' lex_ctxt command_rhs
        | var_lhs tOP_ASGN lex_ctxt command_rhs
        | primary_value '[' opt_call_args rbracket tOP_ASGN lex_ctxt command_rhs
        | primary_value call_op tIDENTIFIER tOP_ASGN lex_ctxt command_rhs
        | primary_value call_op tCONSTANT tOP_ASGN lex_ctxt command_rhs
        | primary_value tCOLON2 tCONSTANT tOP_ASGN lex_ctxt command_rhs
        | primary_value tCOLON2 tIDENTIFIER tOP_ASGN lex_ctxt command_rhs
        | defn_head f_opt_paren_args '=' command
        | defn_head f_opt_paren_args '=' command modifier_rescue arg
        | defs_head f_opt_paren_args '=' command
        | defs_head f_opt_paren_args '=' command modifier_rescue arg
        | backref tOP_ASGN lex_ctxt command_rhs

command_rhs: command_call   %prec tOP_ASGN
        | command_call modifier_rescue stmt
        | command_asgn
        ;

expr: command_call
        | expr keyword_and expr
        | expr keyword_or expr
        | keyword_not opt_nl expr
        | '!' command_call
        | arg tASSOC p_top_expr_body
        | arg keyword_in p_top_expr_body
        | arg %prec tLBRACE_ARG

def_name: fname

defn_head: k_def def_name

defs_head: k_def singleton dot_or_colon def_name

expr_value: expr

expr_value_do: expr_value do

command_call: command
        | block_command

block_command: block_call
        | block_call call_op2 operation2 command_args

cmd_brace_block: tLBRACE_ARG brace_body '}'

fcall: operation

command: fcall command_args       %prec tLOWEST
        | fcall command_args cmd_brace_block
        | primary_value call_op operation2 command_args %prec tLOWEST
        | primary_value call_op operation2 command_args cmd_brace_block
        | primary_value tCOLON2 operation2 command_args %prec tLOWEST
        | primary_value tCOLON2 operation2 command_args cmd_brace_block
        | keyword_super command_args
        | keyword_yield command_args
        | k_return call_args
        | keyword_break call_args
        | keyword_next call_args

mlhs: mlhs_basic
        | tLPAREN mlhs_inner rparen

mlhs_inner: mlhs_basic
        | tLPAREN mlhs_inner rparen

mlhs_basic: mlhs_head
        | mlhs_head mlhs_item
        | mlhs_head tSTAR mlhs_node
        | mlhs_head tSTAR mlhs_node ',' mlhs_post
        | mlhs_head tSTAR
        | mlhs_head tSTAR ',' mlhs_post
        | tSTAR mlhs_node
        | tSTAR mlhs_node ',' mlhs_post
        | tSTAR
        | tSTAR ',' mlhs_post

mlhs_item: mlhs_node
        | tLPAREN mlhs_inner rparen

mlhs_head: mlhs_item ','
        | mlhs_head mlhs_item ','

mlhs_post: mlhs_item
        | mlhs_post ',' mlhs_item

mlhs_node: user_variable
        | keyword_variable
        | primary_value '[' opt_call_args rbracket
        | primary_value call_op tIDENTIFIER
        | primary_value tCOLON2 tIDENTIFIER
        | primary_value call_op tCONSTANT
        | primary_value tCOLON2 tCONSTANT
        | tCOLON3 tCONSTANT
        | backref

lhs: user_variable
        | keyword_variable
        | primary_value '[' opt_call_args rbracket
        | primary_value call_op tIDENTIFIER
        | primary_value tCOLON2 tIDENTIFIER
        | primary_value call_op tCONSTANT
        | primary_value tCOLON2 tCONSTANT
        | tCOLON3 tCONSTANT
        | backref

cname: tIDENTIFIER
        | tCONSTANT

cpath: tCOLON3 cname
        | cname
        | primary_value tCOLON2 cname

fname: tIDENTIFIER
        | tCONSTANT
        | tFID
        | op
        | reswords

fitem: fname
        | symbol

undef_list: fitem
        | undef_list ',' {SET_LEX_STATE(EXPR_FNAME|EXPR_FITEM);} fitem

op: '|'
        | '^'
        | '&'
        | tCMP
        | tEQ
        | tEQQ
        | tMATCH
        | tNMATCH
        | '>'
        | tGEQ
        | '<'
        | tLEQ
        | tNEQ
        | tLSHFT
        | tRSHFT
        | '+'
        | '-'
        | '*'
        | tSTAR
        | '/'
        | '%'
        | tPOW
        | tDSTAR
        | '!'
        | '~'
        | tUPLUS
        | tUMINUS
        | tAREF
        | tASET
        | '`'
        ;

reswords: keyword__LINE__ | keyword__FILE__ | keyword__ENCODING__
        | keyword_BEGIN | keyword_END
        | keyword_alias | keyword_and | keyword_begin
        | keyword_break | keyword_case | keyword_class | keyword_def
        | keyword_defined | keyword_do | keyword_else | keyword_elsif
        | keyword_end | keyword_ensure | keyword_false
        | keyword_for | keyword_in | keyword_module | keyword_next
        | keyword_nil | keyword_not | keyword_or | keyword_redo
        | keyword_rescue | keyword_retry | keyword_return | keyword_self
        | keyword_super | keyword_then | keyword_true | keyword_undef
        | keyword_when | keyword_yield | keyword_if | keyword_unless
        | keyword_while | keyword_until
        ;

arg: lhs '=' lex_ctxt arg_rhs
        | var_lhs tOP_ASGN lex_ctxt arg_rhs
        | primary_value '[' opt_call_args rbracket tOP_ASGN lex_ctxt arg_rhs
        | primary_value call_op tIDENTIFIER tOP_ASGN lex_ctxt arg_rhs
        | primary_value call_op tCONSTANT tOP_ASGN lex_ctxt arg_rhs
        | primary_value tCOLON2 tIDENTIFIER tOP_ASGN lex_ctxt arg_rhs
        | primary_value tCOLON2 tCONSTANT tOP_ASGN lex_ctxt arg_rhs
        | tCOLON3 tCONSTANT tOP_ASGN lex_ctxt arg_rhs
        | backref tOP_ASGN lex_ctxt arg_rhs
        | arg tDOT2 arg
        | arg tDOT3 arg
        | arg tDOT2
        | arg tDOT3
        | tBDOT2 arg
        | tBDOT3 arg
        | arg '+' arg
        | arg '-' arg
        | arg '*' arg
        | arg '/' arg
        | arg '%' arg
        | arg tPOW arg
        | tUMINUS_NUM simple_numeric tPOW arg
        | tUPLUS arg
        | tUMINUS arg
        | arg '|' arg
        | arg '^' arg
        | arg '&' arg
        | arg tCMP arg
        | rel_expr   %prec tCMP
        | arg tEQ arg
        | arg tEQQ arg
        | arg tNEQ arg
        | arg tMATCH arg
        | arg tNMATCH arg
        | '!' arg
        | '~' arg
        | arg tLSHFT arg
        | arg tRSHFT arg
        | arg tANDOP arg
        | arg tOROP arg
        | keyword_defined opt_nl arg
        | arg '?' arg opt_nl ':' arg
        | defn_head f_opt_paren_args '=' arg
        | defn_head f_opt_paren_args '=' arg modifier_rescue arg
        | defs_head f_opt_paren_args '=' arg
        | defs_head f_opt_paren_args '=' arg modifier_rescue arg
        | primary

relop: '>'
        | '<'
        | tGEQ
        | tLEQ
        ;

rel_expr: arg relop arg   %prec '>'
        | rel_expr relop arg   %prec '>'

lex_ctxt: none

arg_value: arg

aref_args: none
        | args trailer
        | args ',' assocs trailer
        | assocs trailer

arg_rhs: arg   %prec tOP_ASGN
        | arg modifier_rescue arg

paren_args: '(' opt_call_args rparen
        | '(' args ',' args_forward rparen
        | '(' args_forward rparen

opt_paren_args: none
        | paren_args

opt_call_args: none
        | call_args
        | args ','
        | args ',' assocs ','
        | assocs ','

call_args: command
        | args opt_block_arg
        | assocs opt_block_arg
        | args ',' assocs opt_block_arg
        | block_arg

command_args: call_args

block_arg: tAMPER arg_value
        | tAMPER

opt_block_arg: ',' block_arg
        | none

args: arg_value
        | tSTAR arg_value
        | tSTAR
        | args ',' arg_value
        | args ',' tSTAR arg_value
        | args ',' tSTAR

mrhs_arg: mrhs
        | arg_value
        ;

mrhs: args ',' arg_value
        | args ',' tSTAR arg_value
        | tSTAR arg_value

primary: literal
        | strings
        | xstring
        | regexp
        | words
        | qwords
        | symbols
        | qsymbols
        | var_ref
        | backref
        | tFID
        | k_begin bodystmt k_end
        | tLPAREN_ARG rparen
        | tLPAREN_ARG stmt rparen
        | tLPAREN compstmt ')'
        | primary_value tCOLON2 tCONSTANT
        | tCOLON3 tCONSTANT
        | tLBRACK aref_args ']'
        | tLBRACE assoc_list '}'
        | k_return
        | keyword_yield '(' call_args rparen
        | keyword_yield '(' rparen
        | keyword_yield
        | keyword_defined opt_nl '(' {p->ctxt.in_defined = 1;} expr rparen
        | keyword_not '(' expr rparen
        | keyword_not '(' rparen
        | fcall brace_block
        | method_call
        | method_call brace_block
        | lambda
        | k_if expr_value then compstmt if_tail k_end
        | k_unless expr_value then compstmt opt_else k_end
        | k_while expr_value_do compstmt k_end
        | k_until expr_value_do compstmt k_end
        | k_case expr_value opt_terms case_body k_end
        | k_case opt_terms case_body k_end
        | k_case expr_value opt_terms p_case_body k_end
        | k_for for_var keyword_in expr_value_do compstmt k_end
        | k_class cpath superclass bodystmt k_end
        | k_class tLSHFT expr term bodystmt k_end
        | k_module cpath bodystmt k_end
        | defn_head f_arglist bodystmt k_end
        | defs_head f_arglist bodystmt k_end
        | keyword_break
        | keyword_next
        | keyword_redo
        | keyword_retry

primary_value: primary

k_begin: keyword_begin

k_if: keyword_if

k_unless: keyword_unless

k_while: keyword_while

k_until: keyword_until

k_case: keyword_case

k_for: keyword_for

k_class: keyword_class

k_module: keyword_module

k_def: keyword_def

k_do: keyword_do

k_do_block: keyword_do_block

k_rescue: keyword_rescue

k_ensure: keyword_ensure

k_when: keyword_when

k_else: keyword_else

k_elsif: keyword_elsif

k_end: keyword_end

k_return: keyword_return

then: term
        | keyword_then
        | term keyword_then

do      : term
        | keyword_do_cond

if_tail: opt_else
        | k_elsif expr_value then compstmt if_tail

opt_else: none
        | k_else compstmt

for_var: lhs
        | mlhs

f_marg: f_norm_arg
        | tLPAREN f_margs rparen

f_marg_list: f_marg
        | f_marg_list ',' f_marg

f_margs: f_marg_list
        | f_marg_list ',' f_rest_marg
        | f_marg_list ',' f_rest_marg ',' f_marg_list
        | f_rest_marg
        | f_rest_marg ',' f_marg_list

f_rest_marg: tSTAR f_norm_arg
        | tSTAR

f_any_kwrest: f_kwrest
        | f_no_kwarg

f_eq: '=';

block_args_tail: f_block_kwarg ',' f_kwrest opt_f_block_arg
        | f_block_kwarg opt_f_block_arg
        | f_any_kwrest opt_f_block_arg
        | f_block_arg

opt_block_args_tail: ',' block_args_tail
        | /* none */

excessed_comma: ','

block_param : f_arg ',' f_block_optarg ',' f_rest_arg opt_block_args_tail
            {
            $$ = new_args(p, $1, $3, $5, Qnone, $6, &@$);
            }
        | f_arg ',' f_block_optarg ',' f_rest_arg ',' f_arg opt_block_args_tail
            {
            $$ = new_args(p, $1, $3, $5, $7, $8, &@$);
            }
        | f_arg ',' f_block_optarg opt_block_args_tail
            {
            $$ = new_args(p, $1, $3, Qnone, Qnone, $4, &@$);
            }
        | f_arg ',' f_block_optarg ',' f_arg opt_block_args_tail
            {
            $$ = new_args(p, $1, $3, Qnone, $5, $6, &@$);
            }
                | f_arg ',' f_rest_arg opt_block_args_tail
            {
            $$ = new_args(p, $1, Qnone, $3, Qnone, $4, &@$);
            }
        | f_arg excessed_comma
            {
            $$ = new_args_tail(p, Qnone, Qnone, Qnone, &@2);
            $$ = new_args(p, $1, Qnone, $2, Qnone, $$, &@$);
            }
        | f_arg ',' f_rest_arg ',' f_arg opt_block_args_tail
            {
            $$ = new_args(p, $1, Qnone, $3, $5, $6, &@$);
            }
        | f_arg opt_block_args_tail
            {
            $$ = new_args(p, $1, Qnone, Qnone, Qnone, $2, &@$);
            }
        | f_block_optarg ',' f_rest_arg opt_block_args_tail
            {
            $$ = new_args(p, Qnone, $1, $3, Qnone, $4, &@$);
            }
        | f_block_optarg ',' f_rest_arg ',' f_arg opt_block_args_tail
            {
            $$ = new_args(p, Qnone, $1, $3, $5, $6, &@$);
            }
        | f_block_optarg opt_block_args_tail
            {
            $$ = new_args(p, Qnone, $1, Qnone, Qnone, $2, &@$);
            }
        | f_block_optarg ',' f_arg opt_block_args_tail
            {
            $$ = new_args(p, Qnone, $1, Qnone, $3, $4, &@$);
            }
        | f_rest_arg opt_block_args_tail
            {
            $$ = new_args(p, Qnone, Qnone, $1, Qnone, $2, &@$);
            }
        | f_rest_arg ',' f_arg opt_block_args_tail
            {
            $$ = new_args(p, Qnone, Qnone, $1, $3, $4, &@$);
            }
        | block_args_tail
            {
            $$ = new_args(p, Qnone, Qnone, Qnone, Qnone, $1, &@$);
            }
        ;

opt_block_param : none
        | block_param_def
            {
            p->command_start = TRUE;
            }
        ;

block_param_def : '|' opt_bv_decl '|'
            {
            p->cur_arg = 0;
            p->max_numparam = ORDINAL_PARAM;
            p->ctxt.in_argdef = 0;
            /*%%%*/
            $$ = 0;
            /*% %*/
            /*% ripper: block_var!(params!(Qnil,Qnil,Qnil,Qnil,Qnil,Qnil,Qnil), escape_Qundef($2)) %*/
            }
        | '|' block_param opt_bv_decl '|'
            {
            p->cur_arg = 0;
            p->max_numparam = ORDINAL_PARAM;
            p->ctxt.in_argdef = 0;
            /*%%%*/
            $$ = $2;
            /*% %*/
            /*% ripper: block_var!(escape_Qundef($2), escape_Qundef($3)) %*/
            }
        ;


opt_bv_decl : opt_nl
            {
            $$ = 0;
            }
        | opt_nl ';' bv_decls opt_nl
            {
            /*%%%*/
            $$ = 0;
            /*% %*/
            /*% ripper: $3 %*/
            }
        ;

bv_decls    : bvar
            /*% ripper[brace]: rb_ary_new3(1, get_value($1)) %*/
        | bv_decls ',' bvar
            /*% ripper[brace]: rb_ary_push($1, get_value($3)) %*/
        ;

bvar        : tIDENTIFIER
            {
            new_bv(p, get_id($1));
            /*% ripper: get_value($1) %*/
            }
        | f_bad_arg
            {
            $$ = 0;
            }
        ;

lambda      : tLAMBDA
            {
            token_info_push(p, "->", &@1);
            $<vars>1 = dyna_push(p);
            $<num>$ = p->lex.lpar_beg;
            p->lex.lpar_beg = p->lex.paren_nest;
            }
            {
            $<num>$ = p->max_numparam;
            p->max_numparam = 0;
            }
            {
            $<node>$ = numparam_push(p);
            }
          f_larglist
            {
            CMDARG_PUSH(0);
            }
          lambda_body
            {
            int max_numparam = p->max_numparam;
            p->lex.lpar_beg = $<num>2;
            p->max_numparam = $<num>3;
            CMDARG_POP();
            $5 = args_with_numbered(p, $5, max_numparam);
            /*%%%*/
                        {
                            YYLTYPE loc = code_loc_gen(&@5, &@7);
                            $$ = NEW_LAMBDA($5, $7, &loc);
                            nd_set_line($$->nd_body, @7.end_pos.lineno);
                            nd_set_line($$, @5.end_pos.lineno);
                nd_set_first_loc($$, @1.beg_pos);
                        }
            /*% %*/
            /*% ripper: lambda!($5, $7) %*/
            numparam_pop(p, $<node>4);
            dyna_pop(p, $<vars>1);
            }
        ;

f_larglist  : '(' f_args opt_bv_decl ')'
            {
            p->ctxt.in_argdef = 0;
            /*%%%*/
            $$ = $2;
            p->max_numparam = ORDINAL_PARAM;
            /*% %*/
            /*% ripper: paren!($2) %*/
            }
        | f_args
            {
            p->ctxt.in_argdef = 0;
            /*%%%*/
            if (!args_info_empty_p($1->nd_ainfo))
                p->max_numparam = ORDINAL_PARAM;
            /*% %*/
            $$ = $1;
            }
        ;

lambda_body : tLAMBEG compstmt '}'
            {
            token_info_pop(p, "}", &@3);
            $$ = $2;
            }
        | keyword_do_LAMBDA bodystmt k_end
            {
            $$ = $2;
            }
        ;

do_block    : k_do_block do_body k_end
            {
            $$ = $2;
            /*%%%*/
            $$->nd_body->nd_loc = code_loc_gen(&@1, &@3);
            nd_set_line($$, @1.end_pos.lineno);
            /*% %*/
            }
        ;

block_call  : command do_block
            {
            /*%%%*/
            if (nd_type_p($1, NODE_YIELD)) {
                compile_error(p, "block given to yield");
            }
            else {
                block_dup_check(p, $1->nd_args, $2);
            }
            $$ = method_add_block(p, $1, $2, &@$);
            fixpos($$, $1);
            /*% %*/
            /*% ripper: method_add_block!($1, $2) %*/
            }
        | block_call call_op2 operation2 opt_paren_args
            {
            /*%%%*/
            $$ = new_qcall(p, $2, $1, $3, $4, &@3, &@$);
            /*% %*/
            /*% ripper: opt_event(:method_add_arg!, call!($1, $2, $3), $4) %*/
            }
        | block_call call_op2 operation2 opt_paren_args brace_block
            {
            /*%%%*/
            $$ = new_command_qcall(p, $2, $1, $3, $4, $5, &@3, &@$);
            /*% %*/
            /*% ripper: opt_event(:method_add_block!, command_call!($1, $2, $3, $4), $5) %*/
            }
        | block_call call_op2 operation2 command_args do_block
            {
            /*%%%*/
            $$ = new_command_qcall(p, $2, $1, $3, $4, $5, &@3, &@$);
            /*% %*/
            /*% ripper: method_add_block!(command_call!($1, $2, $3, $4), $5) %*/
            }
        ;

method_call : fcall paren_args
            {
            /*%%%*/
            $$ = $1;
            $$->nd_args = $2;
            nd_set_last_loc($1, @2.end_pos);
            /*% %*/
            /*% ripper: method_add_arg!(fcall!($1), $2) %*/
            }
        | primary_value call_op operation2 opt_paren_args
            {
            /*%%%*/
            $$ = new_qcall(p, $2, $1, $3, $4, &@3, &@$);
            nd_set_line($$, @3.end_pos.lineno);
            /*% %*/
            /*% ripper: opt_event(:method_add_arg!, call!($1, $2, $3), $4) %*/
            }
        | primary_value tCOLON2 operation2 paren_args
            {
            /*%%%*/
            $$ = new_qcall(p, ID2VAL(idCOLON2), $1, $3, $4, &@3, &@$);
            nd_set_line($$, @3.end_pos.lineno);
            /*% %*/
            /*% ripper: method_add_arg!(call!($1, ID2VAL(idCOLON2), $3), $4) %*/
            }
        | primary_value tCOLON2 operation3
            {
            /*%%%*/
            $$ = new_qcall(p, ID2VAL(idCOLON2), $1, $3, Qnull, &@3, &@$);
            /*% %*/
            /*% ripper: call!($1, ID2VAL(idCOLON2), $3) %*/
            }
        | primary_value call_op paren_args
            {
            /*%%%*/
            $$ = new_qcall(p, $2, $1, ID2VAL(idCall), $3, &@2, &@$);
            nd_set_line($$, @2.end_pos.lineno);
            /*% %*/
            /*% ripper: method_add_arg!(call!($1, $2, ID2VAL(idCall)), $3) %*/
            }
        | primary_value tCOLON2 paren_args
            {
            /*%%%*/
            $$ = new_qcall(p, ID2VAL(idCOLON2), $1, ID2VAL(idCall), $3, &@2, &@$);
            nd_set_line($$, @2.end_pos.lineno);
            /*% %*/
            /*% ripper: method_add_arg!(call!($1, ID2VAL(idCOLON2), ID2VAL(idCall)), $3) %*/
            }
        | keyword_super paren_args
            {
            /*%%%*/
            $$ = NEW_SUPER($2, &@$);
            /*% %*/
            /*% ripper: super!($2) %*/
            }
        | keyword_super
            {
            /*%%%*/
            $$ = NEW_ZSUPER(&@$);
            /*% %*/
            /*% ripper: zsuper! %*/
            }
        | primary_value '[' opt_call_args rbracket
            {
            /*%%%*/
            if ($1 && nd_type_p($1, NODE_SELF))
                $$ = NEW_FCALL(tAREF, $3, &@$);
            else
                $$ = NEW_CALL($1, tAREF, $3, &@$);
            fixpos($$, $1);
            /*% %*/
            /*% ripper: aref!($1, escape_Qundef($3)) %*/
            }
        ;

brace_block : '{' brace_body '}'
            {
            $$ = $2;
            /*%%%*/
            $$->nd_body->nd_loc = code_loc_gen(&@1, &@3);
            nd_set_line($$, @1.end_pos.lineno);
            /*% %*/
            }
        | k_do do_body k_end
            {
            $$ = $2;
            /*%%%*/
            $$->nd_body->nd_loc = code_loc_gen(&@1, &@3);
            nd_set_line($$, @1.end_pos.lineno);
            /*% %*/
            }
        ;

brace_body  : {$<vars>$ = dyna_push(p);}
            {
            $<num>$ = p->max_numparam;
            p->max_numparam = 0;
            }
            {
            $<node>$ = numparam_push(p);
            }
          opt_block_param compstmt
            {
            int max_numparam = p->max_numparam;
            p->max_numparam = $<num>2;
            $4 = args_with_numbered(p, $4, max_numparam);
            /*%%%*/
            $$ = NEW_ITER($4, $5, &@$);
            /*% %*/
            /*% ripper: brace_block!(escape_Qundef($4), $5) %*/
            numparam_pop(p, $<node>3);
            dyna_pop(p, $<vars>1);
            }
        ;

do_body     : {$<vars>$ = dyna_push(p);}
            {
            $<num>$ = p->max_numparam;
            p->max_numparam = 0;
            }
            {
            $<node>$ = numparam_push(p);
            CMDARG_PUSH(0);
            }
          opt_block_param bodystmt
            {
            int max_numparam = p->max_numparam;
            p->max_numparam = $<num>2;
            $4 = args_with_numbered(p, $4, max_numparam);
            /*%%%*/
            $$ = NEW_ITER($4, $5, &@$);
            /*% %*/
            /*% ripper: do_block!(escape_Qundef($4), $5) %*/
            CMDARG_POP();
            numparam_pop(p, $<node>3);
            dyna_pop(p, $<vars>1);
            }
        ;

case_args   : arg_value
            {
            /*%%%*/
            check_literal_when(p, $1, &@1);
            $$ = NEW_LIST($1, &@$);
            /*% %*/
            /*% ripper: args_add!(args_new!, $1) %*/
            }
        | tSTAR arg_value
            {
            /*%%%*/
            $$ = NEW_SPLAT($2, &@$);
            /*% %*/
            /*% ripper: args_add_star!(args_new!, $2) %*/
            }
        | case_args ',' arg_value
            {
            /*%%%*/
            check_literal_when(p, $3, &@3);
            $$ = last_arg_append(p, $1, $3, &@$);
            /*% %*/
            /*% ripper: args_add!($1, $3) %*/
            }
        | case_args ',' tSTAR arg_value
            {
            /*%%%*/
            $$ = rest_arg_append(p, $1, $4, &@$);
            /*% %*/
            /*% ripper: args_add_star!($1, $4) %*/
            }
        ;

case_body   : k_when case_args then
          compstmt
          cases
            {
            /*%%%*/
            $$ = NEW_WHEN($2, $4, $5, &@$);
            fixpos($$, $2);
            /*% %*/
            /*% ripper: when!($2, $4, escape_Qundef($5)) %*/
            }
        ;

cases       : opt_else
        | case_body
        ;

p_case_body : keyword_in
            {
            SET_LEX_STATE(EXPR_BEG|EXPR_LABEL);
            p->command_start = FALSE;
            $<ctxt>1 = p->ctxt;
            p->ctxt.in_kwarg = 1;
            $<tbl>$ = push_pvtbl(p);
            }
            {
            $<tbl>$ = push_pktbl(p);
            }
          p_top_expr then
            {
            pop_pktbl(p, $<tbl>3);
            pop_pvtbl(p, $<tbl>2);
            p->ctxt.in_kwarg = $<ctxt>1.in_kwarg;
            }
          compstmt
          p_cases
            {
            /*%%%*/
            $$ = NEW_IN($4, $7, $8, &@$);
            /*% %*/
            /*% ripper: in!($4, $7, escape_Qundef($8)) %*/
            }
        ;

p_cases     : opt_else
        | p_case_body
        ;

p_top_expr  : p_top_expr_body
        | p_top_expr_body modifier_if expr_value
            {
            /*%%%*/
            $$ = new_if(p, $3, $1, 0, &@$);
            fixpos($$, $3);
            /*% %*/
            /*% ripper: if_mod!($3, $1) %*/
            }
        | p_top_expr_body modifier_unless expr_value
            {
            /*%%%*/
            $$ = new_unless(p, $3, $1, 0, &@$);
            fixpos($$, $3);
            /*% %*/
            /*% ripper: unless_mod!($3, $1) %*/
            }
        ;

p_top_expr_body : p_expr
        | p_expr ','
            {
            $$ = new_array_pattern_tail(p, Qnone, 1, 0, Qnone, &@$);
            $$ = new_array_pattern(p, Qnone, get_value($1), $$, &@$);
            }
        | p_expr ',' p_args
            {
            $$ = new_array_pattern(p, Qnone, get_value($1), $3, &@$);
            /*%%%*/
            nd_set_first_loc($$, @1.beg_pos);
            /*%
            %*/
            }
        | p_find
            {
            $$ = new_find_pattern(p, Qnone, $1, &@$);
            }
        | p_args_tail
            {
            $$ = new_array_pattern(p, Qnone, Qnone, $1, &@$);
            }
        | p_kwargs
            {
            $$ = new_hash_pattern(p, Qnone, $1, &@$);
            }
        ;

p_expr      : p_as
        ;

p_as        : p_expr tASSOC p_variable
            {
            /*%%%*/
            NODE *n = NEW_LIST($1, &@$);
            n = list_append(p, n, $3);
            $$ = new_hash(p, n, &@$);
            /*% %*/
            /*% ripper: binary!($1, STATIC_ID2SYM((id_assoc)), $3) %*/
            }
        | p_alt
        ;

p_alt       : p_alt '|' p_expr_basic
            {
            /*%%%*/
            $$ = NEW_NODE(NODE_OR, $1, $3, 0, &@$);
            /*% %*/
            /*% ripper: binary!($1, STATIC_ID2SYM(idOr), $3) %*/
            }
        | p_expr_basic
        ;

p_lparen    : '(' {$<tbl>$ = push_pktbl(p);};
p_lbracket  : '[' {$<tbl>$ = push_pktbl(p);};

p_expr_basic    : p_value
        | p_variable
        | p_const p_lparen p_args rparen
            {
            pop_pktbl(p, $<tbl>2);
            $$ = new_array_pattern(p, $1, Qnone, $3, &@$);
            /*%%%*/
            nd_set_first_loc($$, @1.beg_pos);
            /*%
            %*/
            }
        | p_const p_lparen p_find rparen
            {
            pop_pktbl(p, $<tbl>2);
            $$ = new_find_pattern(p, $1, $3, &@$);
            /*%%%*/
            nd_set_first_loc($$, @1.beg_pos);
            /*%
            %*/
            }
        | p_const p_lparen p_kwargs rparen
            {
            pop_pktbl(p, $<tbl>2);
            $$ = new_hash_pattern(p, $1, $3, &@$);
            /*%%%*/
            nd_set_first_loc($$, @1.beg_pos);
            /*%
            %*/
            }
        | p_const '(' rparen
            {
            $$ = new_array_pattern_tail(p, Qnone, 0, 0, Qnone, &@$);
            $$ = new_array_pattern(p, $1, Qnone, $$, &@$);
            }
        | p_const p_lbracket p_args rbracket
            {
            pop_pktbl(p, $<tbl>2);
            $$ = new_array_pattern(p, $1, Qnone, $3, &@$);
            /*%%%*/
            nd_set_first_loc($$, @1.beg_pos);
            /*%
            %*/
            }
        | p_const p_lbracket p_find rbracket
            {
            pop_pktbl(p, $<tbl>2);
            $$ = new_find_pattern(p, $1, $3, &@$);
            /*%%%*/
            nd_set_first_loc($$, @1.beg_pos);
            /*%
            %*/
            }
        | p_const p_lbracket p_kwargs rbracket
            {
            pop_pktbl(p, $<tbl>2);
            $$ = new_hash_pattern(p, $1, $3, &@$);
            /*%%%*/
            nd_set_first_loc($$, @1.beg_pos);
            /*%
            %*/
            }
        | p_const '[' rbracket
            {
            $$ = new_array_pattern_tail(p, Qnone, 0, 0, Qnone, &@$);
            $$ = new_array_pattern(p, $1, Qnone, $$, &@$);
            }
        | tLBRACK p_args rbracket
            {
            $$ = new_array_pattern(p, Qnone, Qnone, $2, &@$);
            }
        | tLBRACK p_find rbracket
            {
            $$ = new_find_pattern(p, Qnone, $2, &@$);
            }
        | tLBRACK rbracket
            {
            $$ = new_array_pattern_tail(p, Qnone, 0, 0, Qnone, &@$);
            $$ = new_array_pattern(p, Qnone, Qnone, $$, &@$);
            }
        | tLBRACE
            {
            $<tbl>$ = push_pktbl(p);
            $<ctxt>1 = p->ctxt;
            p->ctxt.in_kwarg = 0;
            }
          p_kwargs rbrace
            {
            pop_pktbl(p, $<tbl>2);
            p->ctxt.in_kwarg = $<ctxt>1.in_kwarg;
            $$ = new_hash_pattern(p, Qnone, $3, &@$);
            }
        | tLBRACE rbrace
            {
            $$ = new_hash_pattern_tail(p, Qnone, 0, &@$);
            $$ = new_hash_pattern(p, Qnone, $$, &@$);
            }
        | tLPAREN {$<tbl>$ = push_pktbl(p);} p_expr rparen
            {
            pop_pktbl(p, $<tbl>2);
            $$ = $3;
            }
        ;

p_args      : p_expr
            {
            /*%%%*/
            NODE *pre_args = NEW_LIST($1, &@$);
            $$ = new_array_pattern_tail(p, pre_args, 0, 0, Qnone, &@$);
            /*%
            $$ = new_array_pattern_tail(p, rb_ary_new_from_args(1, get_value($1)), 0, 0, Qnone, &@$);
            %*/
            }
        | p_args_head
            {
            $$ = new_array_pattern_tail(p, $1, 1, 0, Qnone, &@$);
            }
        | p_args_head p_arg
            {
            /*%%%*/
            $$ = new_array_pattern_tail(p, list_concat($1, $2), 0, 0, Qnone, &@$);
            /*%
            VALUE pre_args = rb_ary_concat($1, get_value($2));
            $$ = new_array_pattern_tail(p, pre_args, 0, 0, Qnone, &@$);
            %*/
            }
        | p_args_head p_rest
            {
            $$ = new_array_pattern_tail(p, $1, 1, $2, Qnone, &@$);
            }
        | p_args_head p_rest ',' p_args_post
            {
            $$ = new_array_pattern_tail(p, $1, 1, $2, $4, &@$);
            }
        | p_args_tail
        ;

p_args_head : p_arg ','
            {
            $$ = $1;
            }
        | p_args_head p_arg ','
            {
            /*%%%*/
            $$ = list_concat($1, $2);
            /*% %*/
            /*% ripper: rb_ary_concat($1, get_value($2)) %*/
            }
        ;

p_args_tail : p_rest
            {
            $$ = new_array_pattern_tail(p, Qnone, 1, $1, Qnone, &@$);
            }
        | p_rest ',' p_args_post
            {
            $$ = new_array_pattern_tail(p, Qnone, 1, $1, $3, &@$);
            }
        ;

p_find      : p_rest ',' p_args_post ',' p_rest
            {
            $$ = new_find_pattern_tail(p, $1, $3, $5, &@$);
            }
        ;


p_rest      : tSTAR tIDENTIFIER
            {
            $$ = $2;
            }
        | tSTAR
            {
            $$ = 0;
            }
        ;

p_args_post : p_arg
        | p_args_post ',' p_arg
            {
            /*%%%*/
            $$ = list_concat($1, $3);
            /*% %*/
            /*% ripper: rb_ary_concat($1, get_value($3)) %*/
            }
        ;

p_arg       : p_expr
            {
            /*%%%*/
            $$ = NEW_LIST($1, &@$);
            /*% %*/
            /*% ripper: rb_ary_new_from_args(1, get_value($1)) %*/
            }
        ;

p_kwargs    : p_kwarg ',' p_any_kwrest
            {
            $$ =  new_hash_pattern_tail(p, new_unique_key_hash(p, $1, &@$), $3, &@$);
            }
        | p_kwarg
            {
            $$ =  new_hash_pattern_tail(p, new_unique_key_hash(p, $1, &@$), 0, &@$);
            }
        | p_kwarg ','
            {
            $$ =  new_hash_pattern_tail(p, new_unique_key_hash(p, $1, &@$), 0, &@$);
            }
        | p_any_kwrest
            {
            $$ =  new_hash_pattern_tail(p, new_hash(p, Qnone, &@$), $1, &@$);
            }
        ;

p_kwarg     : p_kw
            /*% ripper[brace]: rb_ary_new_from_args(1, $1) %*/
        | p_kwarg ',' p_kw
            {
            /*%%%*/
            $$ = list_concat($1, $3);
            /*% %*/
            /*% ripper: rb_ary_push($1, $3) %*/
            }
        ;

p_kw        : p_kw_label p_expr
            {
            error_duplicate_pattern_key(p, get_id($1), &@1);
            /*%%%*/
            $$ = list_append(p, NEW_LIST(NEW_LIT(ID2SYM($1), &@1), &@$), $2);
            /*% %*/
            /*% ripper: rb_ary_new_from_args(2, get_value($1), get_value($2)) %*/
            }
        | p_kw_label
            {
            error_duplicate_pattern_key(p, get_id($1), &@1);
            if ($1 && !is_local_id(get_id($1))) {
                yyerror1(&@1, "key must be valid as local variables");
            }
            error_duplicate_pattern_variable(p, get_id($1), &@1);
            /*%%%*/
            $$ = list_append(p, NEW_LIST(NEW_LIT(ID2SYM($1), &@$), &@$), assignable(p, $1, 0, &@$));
            /*% %*/
            /*% ripper: rb_ary_new_from_args(2, get_value($1), Qnil) %*/
            }
        ;

p_kw_label  : tLABEL
        | tSTRING_BEG string_contents tLABEL_END
            {
            YYLTYPE loc = code_loc_gen(&@1, &@3);
            /*%%%*/
            if (!$2 || nd_type_p($2, NODE_STR)) {
                NODE *node = dsym_node(p, $2, &loc);
                $$ = SYM2ID(node->nd_lit);
            }
            /*%
            if (ripper_is_node_yylval($2) && RNODE($2)->nd_cval) {
                VALUE label = RNODE($2)->nd_cval;
                VALUE rval = RNODE($2)->nd_rval;
                $$ = ripper_new_yylval(p, rb_intern_str(label), rval, label);
                RNODE($$)->nd_loc = loc;
            }
            %*/
            else {
                yyerror1(&loc, "symbol literal with interpolation is not allowed");
                $$ = 0;
            }
            }
        ;

p_kwrest    : kwrest_mark tIDENTIFIER
            {
                $$ = $2;
            }
        | kwrest_mark
            {
                $$ = 0;
            }
        ;

p_kwnorest  : kwrest_mark keyword_nil
            {
                $$ = 0;
            }
        ;

p_any_kwrest    : p_kwrest
        | p_kwnorest {$$ = ID2VAL(idNil);}
        ;

p_value     : p_primitive
        | p_primitive tDOT2 p_primitive
            {
            /*%%%*/
            value_expr($1);
            value_expr($3);
            $$ = NEW_DOT2($1, $3, &@$);
            /*% %*/
            /*% ripper: dot2!($1, $3) %*/
            }
        | p_primitive tDOT3 p_primitive
            {
            /*%%%*/
            value_expr($1);
            value_expr($3);
            $$ = NEW_DOT3($1, $3, &@$);
            /*% %*/
            /*% ripper: dot3!($1, $3) %*/
            }
        | p_primitive tDOT2
            {
            /*%%%*/
            value_expr($1);
            $$ = NEW_DOT2($1, new_nil_at(p, &@2.end_pos), &@$);
            /*% %*/
            /*% ripper: dot2!($1, Qnil) %*/
            }
        | p_primitive tDOT3
            {
            /*%%%*/
            value_expr($1);
            $$ = NEW_DOT3($1, new_nil_at(p, &@2.end_pos), &@$);
            /*% %*/
            /*% ripper: dot3!($1, Qnil) %*/
            }
        | p_var_ref
        | p_expr_ref
        | p_const
        | tBDOT2 p_primitive
            {
            /*%%%*/
            value_expr($2);
            $$ = NEW_DOT2(new_nil_at(p, &@1.beg_pos), $2, &@$);
            /*% %*/
            /*% ripper: dot2!(Qnil, $2) %*/
            }
        | tBDOT3 p_primitive
            {
            /*%%%*/
            value_expr($2);
            $$ = NEW_DOT3(new_nil_at(p, &@1.beg_pos), $2, &@$);
            /*% %*/
            /*% ripper: dot3!(Qnil, $2) %*/
            }
        ;

p_primitive : literal
        | strings
        | xstring
        | regexp
        | words
        | qwords
        | symbols
        | qsymbols
        | keyword_variable
            {
            /*%%%*/
            if (!($$ = gettable(p, $1, &@$))) $$ = NEW_BEGIN(0, &@$);
            /*% %*/
            /*% ripper: var_ref!($1) %*/
            }
        | lambda
        ;

p_variable  : tIDENTIFIER
            {
            /*%%%*/
            error_duplicate_pattern_variable(p, $1, &@1);
            $$ = assignable(p, $1, 0, &@$);
            /*% %*/
            /*% ripper: assignable(p, var_field(p, $1)) %*/
            }
        ;

p_var_ref   : '^' tIDENTIFIER
            {
            /*%%%*/
            NODE *n = gettable(p, $2, &@$);
            if (!(nd_type_p(n, NODE_LVAR) || nd_type_p(n, NODE_DVAR))) {
                compile_error(p, "%"PRIsVALUE": no such local variable", rb_id2str($2));
            }
            $$ = n;
            /*% %*/
            /*% ripper: var_ref!($2) %*/
            }
                | '^' nonlocal_var
            {
            /*%%%*/
            if (!($$ = gettable(p, $2, &@$))) $$ = NEW_BEGIN(0, &@$);
            /*% %*/
            /*% ripper: var_ref!($2) %*/
                    }
        ;

p_expr_ref  : '^' tLPAREN expr_value ')'
            {
            /*%%%*/
            $$ = NEW_BEGIN($3, &@$);
            /*% %*/
            /*% ripper: begin!($3) %*/
            }
        ;

p_const     : tCOLON3 cname
            {
            /*%%%*/
            $$ = NEW_COLON3($2, &@$);
            /*% %*/
            /*% ripper: top_const_ref!($2) %*/
            }
        | p_const tCOLON2 cname
            {
            /*%%%*/
            $$ = NEW_COLON2($1, $3, &@$);
            /*% %*/
            /*% ripper: const_path_ref!($1, $3) %*/
            }
        | tCONSTANT
           {
            /*%%%*/
            $$ = gettable(p, $1, &@$);
            /*% %*/
            /*% ripper: var_ref!($1) %*/
           }
        ;

opt_rescue  : k_rescue exc_list exc_var then
          compstmt
          opt_rescue
            {
            /*%%%*/
            $$ = NEW_RESBODY($2,
                     $3 ? block_append(p, node_assign(p, $3, NEW_ERRINFO(&@3), NO_LEX_CTXT, &@3), $5) : $5,
                     $6, &@$);
            fixpos($$, $2?$2:$5);
            /*% %*/
            /*% ripper: rescue!(escape_Qundef($2), escape_Qundef($3), escape_Qundef($5), escape_Qundef($6)) %*/
            }
        | none
        ;

exc_list    : arg_value
            {
            /*%%%*/
            $$ = NEW_LIST($1, &@$);
            /*% %*/
            /*% ripper: rb_ary_new3(1, get_value($1)) %*/
            }
        | mrhs
            {
            /*%%%*/
            if (!($$ = splat_array($1))) $$ = $1;
            /*% %*/
            /*% ripper: $1 %*/
            }
        | none
        ;

exc_var     : tASSOC lhs
            {
            $$ = $2;
            }
        | none
        ;

opt_ensure  : k_ensure compstmt
            {
            /*%%%*/
            $$ = $2;
            /*% %*/
            /*% ripper: ensure!($2) %*/
            }
        | none
        ;

literal     : numeric
        | symbol
        ;

strings     : string
            {
            /*%%%*/
            NODE *node = $1;
            if (!node) {
                node = NEW_STR(STR_NEW0(), &@$);
                            RB_OBJ_WRITTEN(p->ast, Qnil, node->nd_lit);
            }
            else {
                node = evstr2dstr(p, node);
            }
            $$ = node;
            /*% %*/
            /*% ripper: $1 %*/
            }
        ;

string      : tCHAR
        | string1
        | string string1
            {
            /*%%%*/
            $$ = literal_concat(p, $1, $2, &@$);
            /*% %*/
            /*% ripper: string_concat!($1, $2) %*/
            }
        ;

string1     : tSTRING_BEG string_contents tSTRING_END
            {
            /*%%%*/
            $$ = heredoc_dedent(p, $2);
            if ($$) nd_set_loc($$, &@$);
            /*% %*/
            /*% ripper: string_literal!(heredoc_dedent(p, $2)) %*/
            }
        ;

xstring     : tXSTRING_BEG xstring_contents tSTRING_END
            {
            /*%%%*/
            $$ = new_xstring(p, heredoc_dedent(p, $2), &@$);
            /*% %*/
            /*% ripper: xstring_literal!(heredoc_dedent(p, $2)) %*/
            }
        ;

regexp      : tREGEXP_BEG regexp_contents tREGEXP_END
            {
            $$ = new_regexp(p, $2, $3, &@$);
            }
        ;

words       : tWORDS_BEG ' ' word_list tSTRING_END
            {
            /*%%%*/
            $$ = make_list($3, &@$);
            /*% %*/
            /*% ripper: array!($3) %*/
            }
        ;

word_list   : /* none */
            {
            /*%%%*/
            $$ = 0;
            /*% %*/
            /*% ripper: words_new! %*/
            }
        | word_list word ' '
            {
            /*%%%*/
            $$ = list_append(p, $1, evstr2dstr(p, $2));
            /*% %*/
            /*% ripper: words_add!($1, $2) %*/
            }
        ;

word        : string_content
            /*% ripper[brace]: word_add!(word_new!, $1) %*/
        | word string_content
            {
            /*%%%*/
            $$ = literal_concat(p, $1, $2, &@$);
            /*% %*/
            /*% ripper: word_add!($1, $2) %*/
            }
        ;

symbols     : tSYMBOLS_BEG ' ' symbol_list tSTRING_END
            {
            /*%%%*/
            $$ = make_list($3, &@$);
            /*% %*/
            /*% ripper: array!($3) %*/
            }
        ;

symbol_list : /* none */
            {
            /*%%%*/
            $$ = 0;
            /*% %*/
            /*% ripper: symbols_new! %*/
            }
        | symbol_list word ' '
            {
            /*%%%*/
            $$ = symbol_append(p, $1, evstr2dstr(p, $2));
            /*% %*/
            /*% ripper: symbols_add!($1, $2) %*/
            }
        ;

qwords      : tQWORDS_BEG ' ' qword_list tSTRING_END
            {
            /*%%%*/
            $$ = make_list($3, &@$);
            /*% %*/
            /*% ripper: array!($3) %*/
            }
        ;

qsymbols    : tQSYMBOLS_BEG ' ' qsym_list tSTRING_END
            {
            /*%%%*/
            $$ = make_list($3, &@$);
            /*% %*/
            /*% ripper: array!($3) %*/
            }
        ;

qword_list  : /* none */
            {
            /*%%%*/
            $$ = 0;
            /*% %*/
            /*% ripper: qwords_new! %*/
            }
        | qword_list tSTRING_CONTENT ' '
            {
            /*%%%*/
            $$ = list_append(p, $1, $2);
            /*% %*/
            /*% ripper: qwords_add!($1, $2) %*/
            }
        ;

qsym_list   : /* none */
            {
            /*%%%*/
            $$ = 0;
            /*% %*/
            /*% ripper: qsymbols_new! %*/
            }
        | qsym_list tSTRING_CONTENT ' '
            {
            /*%%%*/
            $$ = symbol_append(p, $1, $2);
            /*% %*/
            /*% ripper: qsymbols_add!($1, $2) %*/
            }
        ;

string_contents : /* none */
            {
            /*%%%*/
            $$ = 0;
            /*% %*/
            /*% ripper: string_content! %*/
            /*%%%*/
            /*%
            $$ = ripper_new_yylval(p, 0, $$, 0);
            %*/
            }
        | string_contents string_content
            {
            /*%%%*/
            $$ = literal_concat(p, $1, $2, &@$);
            /*% %*/
            /*% ripper: string_add!($1, $2) %*/
            /*%%%*/
            /*%
            if (ripper_is_node_yylval($1) && ripper_is_node_yylval($2) &&
                !RNODE($1)->nd_cval) {
                RNODE($1)->nd_cval = RNODE($2)->nd_cval;
                RNODE($1)->nd_rval = add_mark_object(p, $$);
                $$ = $1;
            }
            %*/
            }
        ;

xstring_contents: /* none */
            {
            /*%%%*/
            $$ = 0;
            /*% %*/
            /*% ripper: xstring_new! %*/
            }
        | xstring_contents string_content
            {
            /*%%%*/
            $$ = literal_concat(p, $1, $2, &@$);
            /*% %*/
            /*% ripper: xstring_add!($1, $2) %*/
            }
        ;

regexp_contents: /* none */
            {
            /*%%%*/
            $$ = 0;
            /*% %*/
            /*% ripper: regexp_new! %*/
            /*%%%*/
            /*%
            $$ = ripper_new_yylval(p, 0, $$, 0);
            %*/
            }
        | regexp_contents string_content
            {
            /*%%%*/
            NODE *head = $1, *tail = $2;
            if (!head) {
                $$ = tail;
            }
            else if (!tail) {
                $$ = head;
            }
            else {
                switch (nd_type(head)) {
                  case NODE_STR:
                nd_set_type(head, NODE_DSTR);
                break;
                  case NODE_DSTR:
                break;
                  default:
                head = list_append(p, NEW_DSTR(Qnil, &@$), head);
                break;
                }
                $$ = list_append(p, head, tail);
            }
            /*%
            VALUE s1 = 1, s2 = 0, n1 = $1, n2 = $2;
            if (ripper_is_node_yylval(n1)) {
                s1 = RNODE(n1)->nd_cval;
                n1 = RNODE(n1)->nd_rval;
            }
            if (ripper_is_node_yylval(n2)) {
                s2 = RNODE(n2)->nd_cval;
                n2 = RNODE(n2)->nd_rval;
            }
            $$ = dispatch2(regexp_add, n1, n2);
            if (!s1 && s2) {
                $$ = ripper_new_yylval(p, 0, $$, s2);
            }
            %*/
            }
        ;

string_content  : tSTRING_CONTENT
            /*% ripper[brace]: ripper_new_yylval(p, 0, get_value($1), $1) %*/
        | tSTRING_DVAR
            {
            /* need to backup p->lex.strterm so that a string literal `%&foo,#$&,bar&` can be parsed */
            $<strterm>$ = p->lex.strterm;
            p->lex.strterm = 0;
            SET_LEX_STATE(EXPR_BEG);
            }
          string_dvar
            {
            p->lex.strterm = $<strterm>2;
            /*%%%*/
            $$ = NEW_EVSTR($3, &@$);
            nd_set_line($$, @3.end_pos.lineno);
            /*% %*/
            /*% ripper: string_dvar!($3) %*/
            }
        | tSTRING_DBEG
            {
            CMDARG_PUSH(0);
            COND_PUSH(0);
            }
            {
            /* need to backup p->lex.strterm so that a string literal `%!foo,#{ !0 },bar!` can be parsed */
            $<strterm>$ = p->lex.strterm;
            p->lex.strterm = 0;
            }
            {
            $<num>$ = p->lex.state;
            SET_LEX_STATE(EXPR_BEG);
            }
            {
            $<num>$ = p->lex.brace_nest;
            p->lex.brace_nest = 0;
            }
            {
            $<num>$ = p->heredoc_indent;
            p->heredoc_indent = 0;
            }
          compstmt tSTRING_DEND
            {
            COND_POP();
            CMDARG_POP();
            p->lex.strterm = $<strterm>3;
            SET_LEX_STATE($<num>4);
            p->lex.brace_nest = $<num>5;
            p->heredoc_indent = $<num>6;
            p->heredoc_line_indent = -1;
            /*%%%*/
            if ($7) $7->flags &= ~NODE_FL_NEWLINE;
            $$ = new_evstr(p, $7, &@$);
            /*% %*/
            /*% ripper: string_embexpr!($7) %*/
            }
        ;

string_dvar : tGVAR
            {
            /*%%%*/
            $$ = NEW_GVAR($1, &@$);
            /*% %*/
            /*% ripper: var_ref!($1) %*/
            }
        | tIVAR
            {
            /*%%%*/
            $$ = NEW_IVAR($1, &@$);
            /*% %*/
            /*% ripper: var_ref!($1) %*/
            }
        | tCVAR
            {
            /*%%%*/
            $$ = NEW_CVAR($1, &@$);
            /*% %*/
            /*% ripper: var_ref!($1) %*/
            }
        | backref
        ;

symbol      : ssym
        | dsym
        ;

ssym        : tSYMBEG sym
            {
            SET_LEX_STATE(EXPR_END);
            /*%%%*/
            $$ = NEW_LIT(ID2SYM($2), &@$);
            /*% %*/
            /*% ripper: symbol_literal!(symbol!($2)) %*/
            }
        ;

sym     : fname
        | nonlocal_var
        ;

dsym        : tSYMBEG string_contents tSTRING_END
            {
            SET_LEX_STATE(EXPR_END);
            /*%%%*/
            $$ = dsym_node(p, $2, &@$);
            /*% %*/
            /*% ripper: dyna_symbol!($2) %*/
            }
        ;

numeric     : simple_numeric
        | tUMINUS_NUM simple_numeric   %prec tLOWEST
            {
            /*%%%*/
            $$ = $2;
            RB_OBJ_WRITE(p->ast, &$$->nd_lit, negate_lit(p, $$->nd_lit));
            /*% %*/
            /*% ripper: unary!(ID2VAL(idUMinus), $2) %*/
            }
        ;

simple_numeric  : tINTEGER
        | tFLOAT
        | tRATIONAL
        | tIMAGINARY
        ;

nonlocal_var    : tIVAR
        | tGVAR
        | tCVAR
        ;

user_variable   : tIDENTIFIER
        | tCONSTANT
        | nonlocal_var
        ;

keyword_variable: keyword_nil {$$ = KWD2EID(nil, $1);}
        | keyword_self {$$ = KWD2EID(self, $1);}
        | keyword_true {$$ = KWD2EID(true, $1);}
        | keyword_false {$$ = KWD2EID(false, $1);}
        | keyword__FILE__ {$$ = KWD2EID(_FILE__, $1);}
        | keyword__LINE__ {$$ = KWD2EID(_LINE__, $1);}
        | keyword__ENCODING__ {$$ = KWD2EID(_ENCODING__, $1);}
        ;

var_ref     : user_variable
            {
            /*%%%*/
            if (!($$ = gettable(p, $1, &@$))) $$ = NEW_BEGIN(0, &@$);
            /*%
            if (id_is_var(p, get_id($1))) {
                $$ = dispatch1(var_ref, $1);
            }
            else {
                $$ = dispatch1(vcall, $1);
            }
            %*/
            }
        | keyword_variable
            {
            /*%%%*/
            if (!($$ = gettable(p, $1, &@$))) $$ = NEW_BEGIN(0, &@$);
            /*% %*/
            /*% ripper: var_ref!($1) %*/
            }
        ;

var_lhs     : user_variable
            {
            /*%%%*/
            $$ = assignable(p, $1, 0, &@$);
            /*% %*/
            /*% ripper: assignable(p, var_field(p, $1)) %*/
            }
        | keyword_variable
            {
            /*%%%*/
            $$ = assignable(p, $1, 0, &@$);
            /*% %*/
            /*% ripper: assignable(p, var_field(p, $1)) %*/
            }
        ;

backref     : tNTH_REF
        | tBACK_REF
        ;

superclass  : '<'
            {
            SET_LEX_STATE(EXPR_BEG);
            p->command_start = TRUE;
            }
          expr_value term
            {
            $$ = $3;
            }
        | /* none */
            {
            /*%%%*/
            $$ = 0;
            /*% %*/
            /*% ripper: Qnil %*/
            }
        ;

f_opt_paren_args: f_paren_args
        | none
            {
            p->ctxt.in_argdef = 0;
            $$ = new_args_tail(p, Qnone, Qnone, Qnone, &@0);
            $$ = new_args(p, Qnone, Qnone, Qnone, Qnone, $$, &@0);
            }
        ;

f_paren_args    : '(' f_args rparen
            {
            /*%%%*/
            $$ = $2;
            /*% %*/
            /*% ripper: paren!($2) %*/
            SET_LEX_STATE(EXPR_BEG);
            p->command_start = TRUE;
            p->ctxt.in_argdef = 0;
            }
                ;

f_arglist   : f_paren_args
        |   {
            $<ctxt>$ = p->ctxt;
            p->ctxt.in_kwarg = 1;
            p->ctxt.in_argdef = 1;
            SET_LEX_STATE(p->lex.state|EXPR_LABEL); /* force for args */
            }
          f_args term
            {
            p->ctxt.in_kwarg = $<ctxt>1.in_kwarg;
            p->ctxt.in_argdef = 0;
            $$ = $2;
            SET_LEX_STATE(EXPR_BEG);
            p->command_start = TRUE;
            }
        ;

args_tail   : f_kwarg ',' f_kwrest opt_f_block_arg
            {
            $$ = new_args_tail(p, $1, $3, $4, &@3);
            }
        | f_kwarg opt_f_block_arg
            {
            $$ = new_args_tail(p, $1, Qnone, $2, &@1);
            }
        | f_any_kwrest opt_f_block_arg
            {
            $$ = new_args_tail(p, Qnone, $1, $2, &@1);
            }
        | f_block_arg
            {
            $$ = new_args_tail(p, Qnone, Qnone, $1, &@1);
            }
        | args_forward
            {
            add_forwarding_args(p);
            $$ = new_args_tail(p, Qnone, $1, ID2VAL(idFWD_BLOCK), &@1);
            }
        ;

opt_args_tail   : ',' args_tail
            {
            $$ = $2;
            }
        | /* none */
            {
            $$ = new_args_tail(p, Qnone, Qnone, Qnone, &@0);
            }
        ;

f_args      : f_arg ',' f_optarg ',' f_rest_arg opt_args_tail
            {
            $$ = new_args(p, $1, $3, $5, Qnone, $6, &@$);
            }
        | f_arg ',' f_optarg ',' f_rest_arg ',' f_arg opt_args_tail
            {
            $$ = new_args(p, $1, $3, $5, $7, $8, &@$);
            }
        | f_arg ',' f_optarg opt_args_tail
            {
            $$ = new_args(p, $1, $3, Qnone, Qnone, $4, &@$);
            }
        | f_arg ',' f_optarg ',' f_arg opt_args_tail
            {
            $$ = new_args(p, $1, $3, Qnone, $5, $6, &@$);
            }
        | f_arg ',' f_rest_arg opt_args_tail
            {
            $$ = new_args(p, $1, Qnone, $3, Qnone, $4, &@$);
            }
        | f_arg ',' f_rest_arg ',' f_arg opt_args_tail
            {
            $$ = new_args(p, $1, Qnone, $3, $5, $6, &@$);
            }
        | f_arg opt_args_tail
            {
            $$ = new_args(p, $1, Qnone, Qnone, Qnone, $2, &@$);
            }
        | f_optarg ',' f_rest_arg opt_args_tail
            {
            $$ = new_args(p, Qnone, $1, $3, Qnone, $4, &@$);
            }
        | f_optarg ',' f_rest_arg ',' f_arg opt_args_tail
            {
            $$ = new_args(p, Qnone, $1, $3, $5, $6, &@$);
            }
        | f_optarg opt_args_tail
            {
            $$ = new_args(p, Qnone, $1, Qnone, Qnone, $2, &@$);
            }
        | f_optarg ',' f_arg opt_args_tail
            {
            $$ = new_args(p, Qnone, $1, Qnone, $3, $4, &@$);
            }
        | f_rest_arg opt_args_tail
            {
            $$ = new_args(p, Qnone, Qnone, $1, Qnone, $2, &@$);
            }
        | f_rest_arg ',' f_arg opt_args_tail
            {
            $$ = new_args(p, Qnone, Qnone, $1, $3, $4, &@$);
            }
        | args_tail
            {
            $$ = new_args(p, Qnone, Qnone, Qnone, Qnone, $1, &@$);
            }
        | /* none */
            {
            $$ = new_args_tail(p, Qnone, Qnone, Qnone, &@0);
            $$ = new_args(p, Qnone, Qnone, Qnone, Qnone, $$, &@0);
            }
        ;

args_forward    : tBDOT3
            {
            /*%%%*/
            $$ = idFWD_KWREST;
            /*% %*/
            /*% ripper: args_forward! %*/
            }
        ;

f_bad_arg   : tCONSTANT
            {
            static const char mesg[] = "formal argument cannot be a constant";
            /*%%%*/
            yyerror1(&@1, mesg);
            $$ = 0;
            /*% %*/
            /*% ripper[error]: param_error!(ERR_MESG(), $1) %*/
            }
        | tIVAR
            {
            static const char mesg[] = "formal argument cannot be an instance variable";
            /*%%%*/
            yyerror1(&@1, mesg);
            $$ = 0;
            /*% %*/
            /*% ripper[error]: param_error!(ERR_MESG(), $1) %*/
            }
        | tGVAR
            {
            static const char mesg[] = "formal argument cannot be a global variable";
            /*%%%*/
            yyerror1(&@1, mesg);
            $$ = 0;
            /*% %*/
            /*% ripper[error]: param_error!(ERR_MESG(), $1) %*/
            }
        | tCVAR
            {
            static const char mesg[] = "formal argument cannot be a class variable";
            /*%%%*/
            yyerror1(&@1, mesg);
            $$ = 0;
            /*% %*/
            /*% ripper[error]: param_error!(ERR_MESG(), $1) %*/
            }
        ;

f_norm_arg  : f_bad_arg
        | tIDENTIFIER
            {
            formal_argument(p, $1);
            p->max_numparam = ORDINAL_PARAM;
            $$ = $1;
            }
        ;

f_arg_asgn  : f_norm_arg
            {
            ID id = get_id($1);
            arg_var(p, id);
            p->cur_arg = id;
            $$ = $1;
            }
        ;

f_arg_item  : f_arg_asgn
            {
            p->cur_arg = 0;
            /*%%%*/
            $$ = NEW_ARGS_AUX($1, 1, &NULL_LOC);
            /*% %*/
            /*% ripper: get_value($1) %*/
            }
        | tLPAREN f_margs rparen
            {
            /*%%%*/
            ID tid = internal_id(p);
            YYLTYPE loc;
            loc.beg_pos = @2.beg_pos;
            loc.end_pos = @2.beg_pos;
            arg_var(p, tid);
            if (dyna_in_block(p)) {
                $2->nd_value = NEW_DVAR(tid, &loc);
            }
            else {
                $2->nd_value = NEW_LVAR(tid, &loc);
            }
            $$ = NEW_ARGS_AUX(tid, 1, &NULL_LOC);
            $$->nd_next = $2;
            /*% %*/
            /*% ripper: mlhs_paren!($2) %*/
            }
        ;

f_arg       : f_arg_item
            /*% ripper[brace]: rb_ary_new3(1, get_value($1)) %*/
        | f_arg ',' f_arg_item
            {
            /*%%%*/
            $$ = $1;
            $$->nd_plen++;
            $$->nd_next = block_append(p, $$->nd_next, $3->nd_next);
            rb_discard_node(p, $3);
            /*% %*/
            /*% ripper: rb_ary_push($1, get_value($3)) %*/
            }
        ;


f_label     : tLABEL
            {
            arg_var(p, formal_argument(p, $1));
            p->cur_arg = get_id($1);
            p->max_numparam = ORDINAL_PARAM;
            p->ctxt.in_argdef = 0;
            $$ = $1;
            }
        ;

f_kw        : f_label arg_value
            {
            p->cur_arg = 0;
            p->ctxt.in_argdef = 1;
            /*%%%*/
            $$ = new_kw_arg(p, assignable(p, $1, $2, &@$), &@$);
            /*% %*/
            /*% ripper: rb_assoc_new(get_value(assignable(p, $1)), get_value($2)) %*/
            }
        | f_label
            {
            p->cur_arg = 0;
            p->ctxt.in_argdef = 1;
            /*%%%*/
            $$ = new_kw_arg(p, assignable(p, $1, NODE_SPECIAL_REQUIRED_KEYWORD, &@$), &@$);
            /*% %*/
            /*% ripper: rb_assoc_new(get_value(assignable(p, $1)), 0) %*/
            }
        ;

f_block_kw  : f_label primary_value
            {
            p->ctxt.in_argdef = 1;
            /*%%%*/
            $$ = new_kw_arg(p, assignable(p, $1, $2, &@$), &@$);
            /*% %*/
            /*% ripper: rb_assoc_new(get_value(assignable(p, $1)), get_value($2)) %*/
            }
        | f_label
            {
            p->ctxt.in_argdef = 1;
            /*%%%*/
            $$ = new_kw_arg(p, assignable(p, $1, NODE_SPECIAL_REQUIRED_KEYWORD, &@$), &@$);
            /*% %*/
            /*% ripper: rb_assoc_new(get_value(assignable(p, $1)), 0) %*/
            }
        ;

f_block_kwarg   : f_block_kw
            {
            /*%%%*/
            $$ = $1;
            /*% %*/
            /*% ripper: rb_ary_new3(1, get_value($1)) %*/
            }
        | f_block_kwarg ',' f_block_kw
            {
            /*%%%*/
            $$ = kwd_append($1, $3);
            /*% %*/
            /*% ripper: rb_ary_push($1, get_value($3)) %*/
            }
        ;


f_kwarg     : f_kw
            {
            /*%%%*/
            $$ = $1;
            /*% %*/
            /*% ripper: rb_ary_new3(1, get_value($1)) %*/
            }
        | f_kwarg ',' f_kw
            {
            /*%%%*/
            $$ = kwd_append($1, $3);
            /*% %*/
            /*% ripper: rb_ary_push($1, get_value($3)) %*/
            }
        ;

kwrest_mark : tPOW
        | tDSTAR
        ;

f_no_kwarg  : p_kwnorest
            {
            /*%%%*/
            /*% %*/
            /*% ripper: nokw_param!(Qnil) %*/
            }
        ;

f_kwrest    : kwrest_mark tIDENTIFIER
            {
            arg_var(p, shadowing_lvar(p, get_id($2)));
            /*%%%*/
            $$ = $2;
            /*% %*/
            /*% ripper: kwrest_param!($2) %*/
            }
        | kwrest_mark
            {
            arg_var(p, ANON_KEYWORD_REST_ID);
            /*%%%*/
            /*% %*/
            /*% ripper: kwrest_param!(Qnil) %*/
            }
        ;

f_opt       : f_arg_asgn f_eq arg_value
            {
            p->cur_arg = 0;
            p->ctxt.in_argdef = 1;
            /*%%%*/
            $$ = NEW_OPT_ARG(0, assignable(p, $1, $3, &@$), &@$);
            /*% %*/
            /*% ripper: rb_assoc_new(get_value(assignable(p, $1)), get_value($3)) %*/
            }
        ;

f_block_opt : f_arg_asgn f_eq primary_value
            {
            p->cur_arg = 0;
            p->ctxt.in_argdef = 1;
            /*%%%*/
            $$ = NEW_OPT_ARG(0, assignable(p, $1, $3, &@$), &@$);
            /*% %*/
            /*% ripper: rb_assoc_new(get_value(assignable(p, $1)), get_value($3)) %*/
            }
        ;

f_block_optarg  : f_block_opt
            {
            /*%%%*/
            $$ = $1;
            /*% %*/
            /*% ripper: rb_ary_new3(1, get_value($1)) %*/
            }
        | f_block_optarg ',' f_block_opt
            {
            /*%%%*/
            $$ = opt_arg_append($1, $3);
            /*% %*/
            /*% ripper: rb_ary_push($1, get_value($3)) %*/
            }
        ;

f_optarg    : f_opt
            {
            /*%%%*/
            $$ = $1;
            /*% %*/
            /*% ripper: rb_ary_new3(1, get_value($1)) %*/
            }
        | f_optarg ',' f_opt
            {
            /*%%%*/
            $$ = opt_arg_append($1, $3);
            /*% %*/
            /*% ripper: rb_ary_push($1, get_value($3)) %*/
            }
        ;

restarg_mark    : '*'
        | tSTAR
        ;

f_rest_arg  : restarg_mark tIDENTIFIER
            {
            arg_var(p, shadowing_lvar(p, get_id($2)));
            /*%%%*/
            $$ = $2;
            /*% %*/
            /*% ripper: rest_param!($2) %*/
            }
        | restarg_mark
            {
            arg_var(p, ANON_REST_ID);
            /*%%%*/
            /*% %*/
            /*% ripper: rest_param!(Qnil) %*/
            }
        ;

blkarg_mark : '&'
        | tAMPER
        ;

f_block_arg : blkarg_mark tIDENTIFIER
            {
            arg_var(p, shadowing_lvar(p, get_id($2)));
            /*%%%*/
            $$ = $2;
            /*% %*/
            /*% ripper: blockarg!($2) %*/
            }
                | blkarg_mark
                    {
            arg_var(p, ANON_BLOCK_ID);
                    /*%%%*/
                    /*% %*/
            /*% ripper: blockarg!(Qnil) %*/
                    }
        ;

opt_f_block_arg : ',' f_block_arg
            {
            $$ = $2;
            }
        | none
            {
            $$ = Qnull;
            }
        ;

singleton   : var_ref
            {
            value_expr($1);
            $$ = $1;
            }
        | '(' {SET_LEX_STATE(EXPR_BEG);} expr rparen
            {
            /*%%%*/
            switch (nd_type($3)) {
              case NODE_STR:
              case NODE_DSTR:
              case NODE_XSTR:
              case NODE_DXSTR:
              case NODE_DREGX:
              case NODE_LIT:
              case NODE_LIST:
              case NODE_ZLIST:
                yyerror1(&@3, "can't define singleton method for literals");
                break;
              default:
                value_expr($3);
                break;
            }
            $$ = $3;
            /*% %*/
            /*% ripper: paren!($3) %*/
            }
        ;

assoc_list  : none
        | assocs trailer
            {
            /*%%%*/
            $$ = $1;
            /*% %*/
            /*% ripper: assoclist_from_args!($1) %*/
            }
        ;

assocs      : assoc
            /*% ripper[brace]: rb_ary_new3(1, get_value($1)) %*/
        | assocs ',' assoc
            {
            /*%%%*/
            NODE *assocs = $1;
            NODE *tail = $3;
            if (!assocs) {
                assocs = tail;
            }
            else if (tail) {
                            if (assocs->nd_head &&
                                !tail->nd_head && nd_type_p(tail->nd_next, NODE_LIST) &&
                                nd_type_p(tail->nd_next->nd_head, NODE_HASH)) {
                                /* DSTAR */
                                tail = tail->nd_next->nd_head->nd_head;
                            }
                assocs = list_concat(assocs, tail);
            }
            $$ = assocs;
            /*% %*/
            /*% ripper: rb_ary_push($1, get_value($3)) %*/
            }
        ;

assoc       : arg_value tASSOC arg_value
            {
            /*%%%*/
            if (nd_type_p($1, NODE_STR)) {
                nd_set_type($1, NODE_LIT);
                RB_OBJ_WRITE(p->ast, &$1->nd_lit, rb_fstring($1->nd_lit));
            }
            $$ = list_append(p, NEW_LIST($1, &@$), $3);
            /*% %*/
            /*% ripper: assoc_new!($1, $3) %*/
            }
        | tLABEL arg_value
            {
            /*%%%*/
            $$ = list_append(p, NEW_LIST(NEW_LIT(ID2SYM($1), &@1), &@$), $2);
            /*% %*/
            /*% ripper: assoc_new!($1, $2) %*/
            }
        | tLABEL
            {
            /*%%%*/
            NODE *val = gettable(p, $1, &@$);
            if (!val) val = NEW_BEGIN(0, &@$);
            $$ = list_append(p, NEW_LIST(NEW_LIT(ID2SYM($1), &@1), &@$), val);
            /*% %*/
            /*% ripper: assoc_new!($1, Qnil) %*/
            }
        | tSTRING_BEG string_contents tLABEL_END arg_value
            {
            /*%%%*/
            YYLTYPE loc = code_loc_gen(&@1, &@3);
            $$ = list_append(p, NEW_LIST(dsym_node(p, $2, &loc), &loc), $4);
            /*% %*/
            /*% ripper: assoc_new!(dyna_symbol!($2), $4) %*/
            }
        | tDSTAR arg_value
            {
            /*%%%*/
                        if (nd_type_p($2, NODE_HASH) &&
                            !($2->nd_head && $2->nd_head->nd_alen)) {
                            static VALUE empty_hash;
                            if (!empty_hash) {
                                empty_hash = rb_obj_freeze(rb_hash_new());
                                rb_gc_register_mark_object(empty_hash);
                            }
                            $$ = list_append(p, NEW_LIST(0, &@$), NEW_LIT(empty_hash, &@$));
                        }
                        else
                            $$ = list_append(p, NEW_LIST(0, &@$), $2);
            /*% %*/
            /*% ripper: assoc_splat!($2) %*/
            }
        | tDSTAR
            {
                        if (!local_id(p, ANON_KEYWORD_REST_ID)) {
                            compile_error(p, "no anonymous keyword rest parameter");
                        }
            /*%%%*/
                        $$ = list_append(p, NEW_LIST(0, &@$),
                                         NEW_LVAR(ANON_KEYWORD_REST_ID, &@$));
            /*% %*/
            /*% ripper: assoc_splat!(Qnil) %*/
            }
        ;

operation   : tIDENTIFIER
        | tCONSTANT
        | tFID
        ;

operation2  : operation
        | op
        ;

operation3  : tIDENTIFIER
        | tFID
        | op
        ;

dot_or_colon    : '.'
        | tCOLON2
        ;

call_op     : '.'
        | tANDDOT
        ;

call_op2    : call_op
        | tCOLON2
        ;

opt_terms   : /* none */
        | terms
        ;

opt_nl      : /* none */
        | '\n'
        ;

rparen      : opt_nl ')'
        ;

rbracket    : opt_nl ']'
        ;

rbrace      : opt_nl '}'
        ;

trailer     : opt_nl
        | ','
        ;

term        : ';' {yyerrok;token_flush(p);}
        | '\n' {token_flush(p);}
        ;

terms       : term
        | terms ';' {yyerrok;}
        ;

none        : /* none */
            {
            $$ = Qnull;
            }
        ;
