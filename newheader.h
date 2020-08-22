struct node
{
char* type;
struct node* left;
struct node* right;
};

struct node2
{
char* type;
struct node* left;
struct node* right;
struct node* type2;

};

struct textformat
{
char* type;
struct node* left;
struct node* right;
int id;
char* type2;

};

struct textformat2
{
char* type;
struct node* left;
struct node* right;
};


struct content
{
char* type;
struct node* left;
struct node* right;
struct node* action3;
struct node* contentst;

};

struct figure
{
char* type;
struct node* left;
struct node* right;
char* path;
char* width;
char* height;
};

struct node* create_node(char* type,struct node* left, struct node* right);
struct node* create_node2(char* type, struct node* type2,struct node* left,struct node* right);

struct node* new_doc(char* type,struct node* left,struct node* right);
struct node* new_doctype(char* type,struct node* left,struct node* right);
struct node* new_pckg(char* type,struct node* left,struct node* right);
struct node* new_title(char* type,struct node* type2,struct node* left,struct node* right);
struct node* new_author(char* type, struct node* type2,struct node* left,struct node* right);
struct node* new_date(char* type,struct node* type2,struct node* left,struct node* right);

struct node* new_label(char* type, struct node* left,struct node* right);
struct node* new_ref(char* type, struct node* left,struct node* right);

struct node* new_list(char* type,struct node* left,struct node* right);
struct node* new_textformat(char* type ,int id ,char* type2,struct node* left,struct node* right);
struct node* new_contentst(char* type,struct node* left,struct node* right,struct node* c);
struct node* new_action2(char* type,struct node* left,struct node* right);

struct node* new_action3(char* type,struct node* left,struct node* right);
struct node* new_row();
struct node* new_base(int type,struct node* left,struct node* right);
struct node* new_eqn(char* type,struct node* left,struct node* right);
struct node* new_eqn2(char* type,struct node* left,struct node* right);

struct node* new_eqn1_textformat(char* type, struct node* type2,struct node* left,struct node* right);
struct node* new_eqn1_relop(char* type,struct node* left,struct node* right);

struct node* new_eqn1_int(int type,struct node* left,struct node* right);
struct node* new_eqn1_null();

struct node* new_eqnarray(char* type,struct node* left,struct node* right);



struct node* new_incgra(char* type, struct node* left, struct node* right, char* path,char* width,char* height);
struct node* new_incgrac(char* type, struct node* left, struct node* right, char* path,char* width,char* height);


struct node* new_content(char* type,struct node* left,struct node* right,struct node* contentst);

