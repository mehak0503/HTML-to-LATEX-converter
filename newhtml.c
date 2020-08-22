#include<stdio.h>
#include<stdlib.h>
#include "newheader.h"

FILE* html_file;
FILE * fptr;
char str[10];
struct node* nodelist[300];
int i=0;
extern char* l[50];
extern char* labelname[50]; 
extern section1;

struct node* create_node(char* type,struct node* l,struct node* r)
{
    struct node* node=(struct node*)malloc(sizeof(struct node));
	node->type=type;
	node->left=l;
	node->right=r;	
	nodelist[i++]=node;
	return node;
}

struct node* create_node2(char* type,struct node* type2,struct node* l,struct node* r)
{
    struct node2* node=(struct node2*)malloc(sizeof(struct node2));
	node->type=type;
	node->type2=type2;
	node->left=l;
	node->right=r;	
    nodelist[i++]=(struct node*)node;
    return (struct node*)node;
		
}



void print_node(struct node* n)
{

	
	if(n!=NULL)
	{
		fprintf(fptr,"%s ",n->type);
		if(n->left!=NULL)
		fprintf(fptr,"-> %s  ",n->left->type);
		if(n->right!=NULL)
		{       if(n->left==NULL)
		        fprintf(fptr,"-> ");
				fprintf(fptr,"%s",n->right->type);
		}
		fprintf(fptr,"\n");
		
    }
	else 
	{
	    return;
    }
	print_node(n->left);
	print_node(n->right);		
}

void print_nodelist()
{
	int j;
	printf("%d\n",i);
	for(j=0;j<i;++j)
	{		
		if(nodelist[j]->type!=NULL)
		printf("%s\n",nodelist[j]->type);
		else
		{
		}
	}
}


struct node* new_doc(char* type,struct node* l,struct node* r)
{
    struct node* node=create_node(type,l,r);
    fprintf(html_file,"</body></html>");
	//print_nodelist();
	
fptr=fopen("ast.txt","w+");
	print_node(node);
	return node;
}

struct node* new_doctype(char* type,struct node* l,struct node* r)
{  
    fprintf(html_file,"<html><head><title>\n</title></head>");
    struct node* node=create_node(type, l,r);
	return node;	
}

struct node* new_pckg(char* type,struct node* l,struct node* r)
{
    struct node* node=create_node(type, l,r);
	return node;
}

struct node* new_title(char* type, struct node* type2,struct node* l,struct node* r)
{
   struct node* node=create_node2(type,type2,l,r);    
	fprintf(html_file,"<br><body>");
	
	return node;
	
}

struct node* new_author(char* type,struct node* type2,struct node* l,struct node* r)
{
    struct node* node=create_node2(type,type2,l,r);
    fprintf(html_file,"<br>");
    return node;	
}

struct node* new_date(char* type, struct node* type2,struct node* l,struct node* r)
{
    struct node* node=create_node2(type,type2,l,r);
	fprintf(html_file,"<br>");
    return node;
	
}


struct node* new_label(char* type,struct node* l,struct node* r)
{   
    struct node* node=create_node(type,l,r);    		
	
	fprintf(html_file,"<a name=%s></a>",type);
	
	return node;
}

struct node* new_ref(char* type,struct node* left,struct node* r)
{   
    struct node* node=create_node(type,left,r);
    int c;
    char* x;
    
	for(c=1;c<=section1;++c)    
	{
		if(labelname[c]!=NULL)
		{
		if(strcmp(type,labelname[c])==0)
		{
		x=l[c]; break;
	    }
	    }
	}		
	fprintf(html_file,"(refer:<a href=#%s>%s</a>) ",x ,x);	
	return node;
}


struct node* new_list(char* type,struct node* l,struct node* r)
{   
    struct node* node=create_node(type, l,r);
	fprintf(html_file,"</ol>");	
	
	return node;
}


struct node* new_textformat(char* type, int id, char* type2,struct node* l,struct node* r)
{
    struct textformat* node=(struct textformat*)malloc(sizeof(struct textformat));
    node->type2=type2;
    node->type=type;
    node->left=l;
    node->right=r;
    	
	node->id=id;
    
    nodelist[i++]=(struct node*)node;
   
	return (struct node*)node;

}



struct node* new_contentst(char* type, struct node* l,struct node* r,struct node* c)
{
    struct content* node=(struct content*)malloc(sizeof(struct content));	
	node->left=l;
	node->right=NULL;
	node->action3=r;
	node->contentst=c;	
	node->type=type;
	return (struct node*)node;
}

struct node* new_action2(char* type , struct node* l , struct node* r)
{
    	
	fprintf(html_file,"</td>");	
	struct node* node=create_node(type, l,r);
	return node;
}

struct node* new_action3(char* type,struct node* l,struct node* r)
{
    struct node* node=create_node(type, l,r);
	fprintf(html_file,"<td>");
	
	return node;
}

struct node* new_row()
{
    struct node* node=create_node("row",NULL,NULL);
	
	fprintf(html_file,"<tr>");
	return node;
}


struct node* new_base(int type,struct node* l,struct node* r)
{
	struct node* node=(struct node*)malloc(sizeof(struct node));
    node->type="base";
	node->left=l;
	node->right=r;
	fprintf(html_file,"%d",type);	
	nodelist[i++]=node;
	return node;
}

struct node* new_eqn(char* type,struct node* l,struct node* r)
{
	struct node* node=create_node(type, l,r);
    fprintf(html_file,"<br>");
	
	return node;
}

struct node* new_eqn1_textformat(char* type, struct node* type2,struct node* l,struct node* r)
{
	struct node* node=create_node2(type,type2,l,r);	

     return node;
}

struct node* new_eqn1_relop(char* type,struct node* l,struct node* r)
{
	struct node* node=create_node(type,l,r);   
	
	fprintf(html_file,"%s",type);
    
	return (struct node*) node;
}

struct node* new_eqn1_int(int type,struct node* l,struct node* r)
{
	struct node* node=(struct node*)malloc(sizeof(struct node));
    node->type="eqnint";
	node->left=l;
	node->right=r;		
	fprintf(html_file,"%d",type); 
	nodelist[i++]=node;   
	return node;
}

struct node* new_eqn1_null()
{
	struct node* node=(struct node*)malloc(sizeof(struct node));
    node->type=0;
	node->left=NULL;
	node->right=NULL;	
	nodelist[i++]=node;
	return node;
}

struct node* new_eqn2(char* type,struct node* l,struct node* r)
{
	struct node* node=create_node(type, l,r);
    fprintf(html_file,"<br>");
	
	return node;
}

struct node* new_eqnarray(char* type,struct node* l,struct node* r)
{ 
    struct node* node=create_node(type, l,r);
    fprintf(html_file,"<br>");
	return node;
}


struct node* new_incgra(char* type, struct node* left, struct node* right, char* path, char* w, char* h)
{
	struct figure* node=(struct figure*)malloc(sizeof(struct figure));
    node->type=type;
    node->left=left;
    node->right=right;
    node->path=path;
	node->width=w;
	node->height=h;
	fprintf(html_file,"<img src='%s' alt='%s' width='%s' height='%s'>",path,"CANT DISPLAY",w ,h );
	nodelist[i++]=(struct node*)node;	
	return (struct node*)node;
}


struct node* new_incgrac(char* type, struct node* left, struct node* right, char* path, char* w, char* h)

{   struct figure* node=(struct figure*)malloc(sizeof(struct figure));
    node->type=type;
    node->left=left;
    node->right=right;
    node->path=path;
	node->width=w;
	node->height=h;
	
	fprintf(html_file,"<center><img src='%s' alt='%s' width='%s' height='%s'></center>",path,"CANT DISPLAY",w , h);
	nodelist[i++]=(struct node*)node;
	return (struct node*)node;
}



struct node* new_content(char* id,struct node* act,struct node* con,struct node* contentst)
{
    struct content* node=(struct content*)malloc(sizeof(struct content));
	node->type=id;
	node->left=act;
		
	node->right=con;
	node->contentst=contentst;
	nodelist[i++]=(struct node*)node;
	return (struct node*)node;	
}

