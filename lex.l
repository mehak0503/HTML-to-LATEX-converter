
%{
#include <stdio.h>
#include<string.h>
#include "ast.tab.h"
#include "newheader.h"
#define yywrap() 1

int section1=0,subsection1=0,section_count=0,tablecount=0,figurecount=0,eqncount=0;

%}

int [0-9]+
symbol (\.|\,|\;|\\|\:|\'|\?|\!|\/|\~|\(|\)|\`|\|)
special ("{"|"}"|"["|"]"|"$"|"-"|"_"|"^"|"~"|"#"|"@"|"%")
rel_op ("+"|"-"|"="|"*"|"/")
word ([a-zA-Z0-9]+|{rel_op})
comment ["%"]+
space [" "]+
newline "\\n"
table_opt "{"[l|r|c|"|"|" "]+"}"
file_name ({word}"."{word})

com_text ({word}|{symbol}|{rel_op}|{int}|{special}|{space})+
text ({word}|{symbol}|{rel_op}|{int}|{special}|{space})+
%%
"\\documentclass" {return DOC_CLASS;}
"article"|"IEEEtran"|"proc"|"report"|"book"|"letter"|"acmart" {  return D_CLASS_TYP;} 
"\\usepackage" {  return USE_PKG;}
"balance"|"graphicx"|"url"|"amsmath"|"mathtools"|"tabularx"|"caption"|"subcaption"|"multirow"|"graphics"|"latexsym"|"amssymb"  {return PKG_TYPE;}
"\\LaTeX" {}
"\\title" {return TITLE;}
"\\author" {  return AUTHOR;}
"\\date" {  return DATE;}
"\\maketitle" {  return MAKETITLE;}
"\\begin{document}"  {return BEG_DOC;}
"\\end{document}"  {  return END_DOC;}
"\\begin{abstract}"  {  return BEG_ABS;}
"\\end{abstract}"  {  return END_ABS;}
"\\begin{enumerate}"  {  return BEG_ENUM;}
"\\end{enumerate}"  {  return END_ENUM;}
"\\begin{tabular}"  { tablecount++;  return BEG_TAB;}
"\\end{tabular}"  {  return END_TAB;}
"\\begin{figure}"  {figurecount++;   return BEG_FIG;}
"\\end{figure}"  {  return END_FIG;}
"\\begin{equation}"  {  return BEG_EQN;}
"\\end{equation}"  {  return END_EQN;}
"\\begin{eqnarray}"  {  return BEG_EQNA;}
"\\end{eqnarray}"  {  return END_EQNA;}

"\\section" { section1++; return SECTION;}
"\\subsection" { if(section1!=section_count) {section_count++;subsection1=0;} subsection1++; 
  return SUB_SEC;}
"\\par" {  return PAR;}
"\\hline" {  return HLINE;}
"\\cline" {  return CLINE;}

"\\textbf" { return BOLD;}
"\\textit" { return ITAL;}
"\\item" { return ITEM;}
"\\label" { return LABEL;}
"\\underline" { return UND_LINE;}
"\\frac" { return FRAC;}
"\\sqrt" { return SQRT;}
"\\includegraphics" { return INC_GRA;}
"\\centering" { return CENTER;}
"\\caption" { return CAPTION;}
"width=" { return WIDTH;}
"height=" { return HEIGHT;}
{table_opt} {}

"{" {  return L_CURLY_B;} 
"}" {  return R_CURLY_B;} 
"[" {  return OPT_L;}
"]" {  return OPT_R;}  
"\$" {  return DOLLAR;}
"&" {  return AMP;}
"\^" {  return CARET;}
"\_" {  return UND_SCR;}
"\~" {  return TILDE;}
"\\\\" {  return NEW_ROW;}
"\\sum_" {  return SUMMATION;}
"\\int_" {  return INTEGRATION;}
"\\ref" {  return REF;}

{file_name} {  yylval.s = strdup(yytext); return FILE_NAME;}
{space} {}

{int} {  yylval.i = atoi(yytext); return INT;}
{symbol} {  yylval.s = strdup(yytext);  return SYMBOL;} 
{special} {  yylval.s = strdup(yytext); return SPECIAL;} 
{rel_op} {  yylval.s = strdup(yytext);  return REL_OP;}

{word}   { yylval.s = strdup(yytext);  return WORD;}

{comment}{com_text} { }
. { printf("ERROR in %s",yytext);}

%%


