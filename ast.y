%{

#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include "newheader.h"
void yyerror(char *);
int yylex(void);
FILE *html_file;
FILE *ptr;
FILE *yyin;
int yylineno;
extern int section1;
extern int subsection1;
extern int section_count;
extern int tablecount;
extern int figurecount;
extern int eqncount;

int label=1;
char* l[50];
char* labelname[50];

%}

%error-verbose

%union
{
char *s;
struct node* ast;
int i;
}

%start doc_start
%token DOC_CLASS D_CLASS_TYP TITLE AUTHOR DATE MAKETITLE 
%token BEG_DOC END_DOC BEG_ABS END_ABS BEG_ENUM END_ENUM
%token BEG_TAB END_TAB SECTION SUB_SEC L_CURLY_B R_CURLY_B
%token OPT_L OPT_R NEWLINE SPACE USE_PKG PKG_TYPE TODAY
%token BEG_FIG END_FIG PAR HLINE DOLLAR AMP CARET UND_SCR
%token NEW_ROW TILDE BOLD ITEM ITAL LABEL UND_LINE WIDTH 
%token FRAC SQRT BEG_EQN END_EQN INC_GRA CENTER CAPTION INTEGRATION        SUMMATION REF HEIGHT BEG_EQNA END_EQNA CLINE
%token <s> WORD SPECIAL FILE_NAME
%token <s> SYMBOL
%token <s> REL_OP
%token <i> INT
%type <s> text  
%type <s> text2


%type <ast> doc_start doc_type pckg main section subsection math figure table eqn frac sqrt eqnarray option main2 list base math_option fig_opt1 row action3  content_st eqn2 tab_option1 title author section_opt subsection_opt section_st subsection_st label item date tab_option2 action action2 frac_opt sqrt_opt eqn1 caption table_st int int_opt sum sum_opt int_symbol sum_symbol ref inc_gra inc_grac content textformat eqnarray2


%%

doc_start : doc_type pckg BEG_DOC title author date main END_DOC 

           {$$ = new_doc("docstart",$1,$7);};  

doc_type : DOC_CLASS option L_CURLY_B D_CLASS_TYP R_CURLY_B 

           {$$ = new_doctype("doctype",NULL,NULL);};

option : OPT_L text2 OPT_R 
        
         {$$ = create_node($2,NULL,NULL);}

         | OPT_L OPT_R 

         {$$ = create_node("option",NULL,NULL);};

pckg : pckg USE_PKG L_CURLY_B PKG_TYPE R_CURLY_B |

       {$$ = new_pckg("package",NULL,NULL);};  

title : TITLE L_CURLY_B {fprintf(html_file,"Title : ");}textformat R_CURLY_B 
       
        {$$ = new_title("title",$4,NULL,NULL);};

author : AUTHOR L_CURLY_B {fprintf(html_file,"Author : ");}textformat R_CURLY_B 

         {$$ = new_author("author",$4,NULL,NULL);};

date :  DATE L_CURLY_B {fprintf(html_file,"Date : ");} text R_CURLY_B 

        {$$ = new_date("date",NULL,NULL,NULL);};

main2 : section  {$$ = create_node("main2section",$1,NULL);}
 
        | list {$$ = create_node("main2list",$1,NULL);}

        | table {$$ = create_node("main2table",$1,NULL);}  

        | math {$$ = create_node("main2math",$1,NULL);} 

        | figure {$$ = create_node("main2figure",$1,NULL);} 

              
        | PAR {$$=create_node("par",NULL,NULL);};

        | subsection {$$=create_node("section",NULL,NULL);};

        | text {$$=create_node("text",NULL,NULL);};



main : main main2 {$$ = create_node("main",$1,$2);}

       | main2 {$$ = create_node("main",$1,NULL);};

section : section_st label section_opt {$$ = create_node("section",$1,$3); }
 
| section_st section_opt {$$ = create_node("section",$1,$2);};
;

sec_start: {fprintf(html_file,"<section><h2>");};
sec_end : {fprintf(html_file,"</h2></section>");};


section_opt : section_opt subsection {$$ = create_node2("sectionopt",NULL,$1,NULL);}

              | tsec textformat tsecend subsection{$$ = create_node2
("sectionopt",$2,$4,NULL);}
  
              | tsec textformat tsecend {$$ = create_node2("sectionopt",$2,NULL,NULL);};

tsec : {fprintf(html_file,"<h4>");};
tsecend : {fprintf(html_file,"</h4>");};

section_st :  SECTION L_CURLY_B sec_start {fprintf(html_file,"%d. ",section1);} text sec_end R_CURLY_B {$$ = create_node("sectionst",NULL,NULL); l[section1]= $5 ;};


subsection : subsection_st subsection_opt {$$ = create_node("subsection",$1,$2);} 

             | subsection_st {$$ = create_node("subsection",$1,NULL);};


subsection_opt : tsec textformat tsecend { $$ = create_node2("subsectionopt",$2,NULL,NULL);};

subsection_st : SUB_SEC L_CURLY_B subsec_start {fprintf(html_file,"%d.%d ",section1,subsection1);} textformat subsec_end R_CURLY_B {$$ = create_node2("subsectionst",$5,NULL,NULL);};

subsec_start : {fprintf(html_file,"<h3>");};

subsec_end : {fprintf(html_file,"</h3>");}


label : LABEL L_CURLY_B text2 R_CURLY_B { $$ = new_label(l[section1],NULL,NULL); labelname[section1]=$3 ;}; 


ref : REF L_CURLY_B text2 R_CURLY_B { $$ = new_ref($3,NULL,NULL); };


list_st : { fprintf(html_file,"<ol>");};

list : BEG_ENUM list_st item END_ENUM {$$ = new_list("list",$3,NULL); };



item : item ITEM L_CURLY_B item_st tsec textformat tsecend item_end R_CURLY_B list{$$ = create_node2("item",$6,$1,NULL);}

| ITEM L_CURLY_B item_st tsec textformat tsecend item_end R_CURLY_B list {$$ = create_node2("item",$5,NULL,NULL);}

| item ITEM L_CURLY_B item_st tsec textformat tsecend item_end R_CURLY_B {$$ = create_node2("item",$6,$1,NULL);}

| ITEM L_CURLY_B item_st tsec textformat tsecend item_end R_CURLY_B {$$ = create_node2("item",$5,NULL,NULL);}

item_st : {fprintf(html_file,"<li>");};

item_end : {fprintf(html_file,"</li>");};

textformat : text {$$ = new_textformat("text",3,$1,NULL,NULL);} ;

            

bold : {fprintf(html_file,"<b>");};

boldend : {fprintf(html_file,"</b>");}

text  : text WORD {fprintf(html_file,"%s&nbsp;",$2);}

| text SYMBOL  {fprintf(html_file,"%s&nbsp;",$2);}  

| text SPECIAL {fprintf(html_file,"%s&nbsp;",$2);}   
| text REL_OP {fprintf(html_file,"%s&nbsp;",$2);}   

| text INT  {fprintf(html_file,"%d&nbsp;",$2);}
| WORD {fprintf(html_file,"%s&nbsp;",$1);}

| SYMBOL {fprintf(html_file,"%s&nbsp;",$1);}
| SPECIAL {fprintf (html_file,"%s&nbsp;",$1);}
| REL_OP {fprintf(html_file,"%s&nbsp;",$1);}
| INT {fprintf(html_file,"%d&nbsp;",$1);}
| text text3;


text3 : bold1
| italic
| underline
| ref;

bold1 : BOLD L_CURLY_B bold text boldend R_CURLY_B ;

italic : {fprintf(html_file,"<i>");} ITAL L_CURLY_B text R_CURLY_B {fprintf(html_file,"</i>");}

underline : {fprintf(html_file,"<u>");} UND_LINE L_CURLY_B text R_CURLY_B {fprintf(html_file,"</u>");}

;

text2 : text2 WORD | WORD;


table : BEG_TAB table_st tablecount tab_option1  content_st caption END_TAB table_end {$$ = create_node("table1",$4,$5);}

       | BEG_TAB table_st tablecount tab_option1 content_st END_TAB table_end {$$ = create_node("table2",$4,$5);}

       | BEG_TAB table_st tablecount content_st END_TAB table_end {$$ = create_node("table3",NULL,$4);} 
       
       | BEG_TAB table_st tablecount tab_option1 END_TAB table_end {$$ = create_node("table4",$4,NULL);} ;

tablecount : { fprintf(html_file,"<br> &#9;Table %d. ",tablecount);}


table_st : { fprintf(html_file,"<center><table border='1'>");};

table_end : { fprintf(html_file,"</table></center>");};

tab_option1 : L_CURLY_B tab_option2 R_CURLY_B {$$ = create_node("taboption",$2,NULL);};

tab_option2 : "1" {$$ = create_node("l",NULL,NULL);}

              |"r" {$$ = create_node("r",NULL,NULL);}

              |"c" {$$ = create_node("c",NULL,NULL);} ;

content_st : row action content {$$ = new_contentst("contentst",$1,$2,$3);};

            

action : action3 tsec textformat tsecend action2 {$$ = create_node2("tabledata",$3,NULL,NULL);};

content : AMP action content content_st{$$ = new_content("tablecontent1",$2,$3,$4);}

         | NEW_ROW row_end opt content_st {$$ = new_content("tablecontent3",NULL,NULL,$4);}
         | NEW_ROW row_end opt{$$ = new_content("tablecontent2",NULL,NULL,NULL);}

         | AMP action content NEW_ROW row_end opt{$$ = new_content("tablecontent4",$2,$3,NULL);}

         | AMP action NEW_ROW row_end opt{$$ = new_content("tablecontent5",NULL,NULL,NULL);};




action2 : {$$ = new_action2("dataend",NULL,NULL);};

action3 : {$$ = new_action3("datastart",NULL,NULL);};

row :     {$$ = new_row();};

row_end : {fprintf(html_file,"</tr>");};

opt : HLINE|CLINE|;

math  :    DOLLAR tsec math_option tsecend DOLLAR {$$ = create_node("math",$3,NULL);}

          | eqn {$$ = create_node("matheqn",$1,NULL);};
          | eqnarray {$$ = create_node("matheqnarray",$1,NULL);};

          


math_option : frac {$$ = create_node("opfrac",$1,NULL);}

             | sqrt {$$ = create_node("opsqrt",$1,NULL);}

             | sum {$$ = create_node("opsum",$1,NULL);} 

             | int {$$ = create_node("opint",$1,NULL);};



frac : DOLLAR FRAC L_CURLY_B frac_opt {fprintf (html_file,"/");} R_CURLY_B L_CURLY_B frac_opt R_CURLY_B DOLLAR 

       {$$ = create_node("frac",NULL,NULL);};


frac_opt : text {$$ = create_node($1,NULL,NULL);}

          | math_option {$$ = create_node("mathopt",$1,NULL);} ;


sqrt : DOLLAR SQRT sqrt_opt L_CURLY_B sqrt_symbol frac_opt R_CURLY_B DOLLAR {$$ = create_node("sqrt1",NULL,NULL);}

      | DOLLAR SQRT L_CURLY_B sqrt_symbol frac_opt R_CURLY_B DOLLAR {$$ = create_node("sqrt2",NULL,NULL);};


sqrt_opt : OPT_L base OPT_R {$$ = create_node("sqrtopt",$2,NULL);}

         | tsec text tsecend {$$ = create_node($2,NULL,NULL);};


base : INT {$$ = new_base($1,NULL,NULL);};


eqn : DOLLAR eqn1 DOLLAR{ eqncount++;fprintf(html_file,"&nbsp;&nbsp;(%d)",eqncount);$$ = new_eqn("eqn1",NULL,NULL);}

      | eqn2 {$$ = new_eqn("eqn2",NULL,NULL);} ;     
      


eqn1 : eqn1 text {$$ = new_eqn1_textformat("eqn1",$1,NULL,NULL);}
       
       | {$$ = new_eqn1_null();};


eqn2 : BEG_EQN eqn1 END_EQN {eqncount++;fprintf(html_file,"&nbsp;&nbsp;(%d)",eqncount);$$ = new_eqn2("eqn21",$2,NULL);};

eqnarray : BEG_EQNA eqnarray2 END_EQNA {$$ = new_eqnarray("eqnarr1",$2,NULL);};
 
eqnarray2 : eqnarray2 eqn1 NEW_ROW {eqncount++;fprintf(html_file,"&nbsp;&nbsp;(%d)",eqncount);fprintf(html_file,"<br>");}

| eqn1 NEW_ROW {eqncount++;fprintf(html_file,"&nbsp;&nbsp;(%d)",eqncount);fprintf(html_file,"<br>");}; 

sum : DOLLAR SUMMATION sum_symbol sum_opt frac_opt DOLLAR {$$= create_node("summation",NULL,NULL);};


sum_opt : L_CURLY_B tsec WORD REL_OP WORD R_CURLY_B CARET WORD tsecend {$$=create_node("sumopt",NULL,NULL);}

         | L_CURLY_B WORD REL_OP INT R_CURLY_B CARET INT {$$=create_node("sumopt2",NULL,NULL);};


int : DOLLAR INTEGRATION int_symbol int_opt frac_opt DOLLAR {$$ = create_node("integration",NULL,NULL);};

int_opt : WORD CARET WORD {$$ = create_node("integrationopt",NULL,NULL);};

sum_symbol : {fprintf(html_file,"&sum;");};

int_symbol : {fprintf(html_file,"&int;");};

sqrt_symbol : {fprintf(html_file,"&radic;");};

figure : BEG_FIG fig_opt1 END_FIG {$$ = create_node("figure",$2,NULL);};

fig_opt1 : CENTER inc_grac captionc {$$ = create_node("figopt1",$2,NULL);}

          | inc_gra caption{$$ = create_node("figopt2",$1,NULL);};


inc_gra : INC_GRA OPT_L HEIGHT WORD SYMBOL WIDTH WORD OPT_R L_CURLY_B FILE_NAME 
R_CURLY_B 

          {$$ = new_incgra("incgra",NULL,NULL,$10,$7,$4);}

inc_grac : INC_GRA OPT_L HEIGHT WORD SYMBOL WIDTH WORD OPT_R L_CURLY_B FILE_NAME R_CURLY_B 
     
           {$$ = new_incgrac("incgrac",NULL,NULL,$10,$7,$4);} ; 

caption : CAPTION L_CURLY_B tsec {fprintf(html_file,"<br> &#9;Figure %d. ",figurecount);}textformat tsecend R_CURLY_B 

          {$$ = create_node2("caption",$5,NULL,NULL);};

captionc : CAPTION L_CURLY_B {fprintf(html_file,"<center>");} tsec {fprintf(html_file,"<br> &#9;Figure %d. ",figurecount);}textformat {fprintf(html_file,"</center>");} tsecend R_CURLY_B ;


          
        	
%%

void yyerror(char *msg)
{
printf("Error:");
fprintf(stderr,"%s\n",msg); 
}

int main(int argc,char* argv[])
{

ptr = fopen(argv[1],"r");
if(ptr==NULL)
{printf("Cannot open file");return 0;}
yyin = ptr;
html_file = fopen("result.html","w+");
return yyparse();

} 
