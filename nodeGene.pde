

class nodeGene{
  TYPE type;
int id;
float x,bias;
int y,x1,y1;
  nodeGene(TYPE t, int ID){
   type = t;
   id = ID;
   x=0;
   y=0;
   x1=1;
   y1=1;
   bias = 0;
 }
 
 nodeGene(nodeGene gene) {
    this.type = gene.type;
    this.id = gene.id;
    this.x = gene.x;
    this.y = gene.y;
    this.bias = gene.bias;
  }
 void setX(float z){
 x=z;}
 
 void setY(int z) {y=0;}
 
 void setB(float z){bias = z;}
 
 float getB(){return bias;}
 
 float getX() {return x;}
 int getY(){return y;}
 
  void setX1(int z){x1=z;}
 
 void setY1(int z) {y1=z;}
 
 int getX1() {return x1;}
 int getY1(){return y1;}
 
 TYPE getType(){
  return type; 
 }
 int getID(){
  return id; 
 }
 
 
 nodeGene copy(){
  nodeGene g = new nodeGene(type,id); 
  g.setB(bias);
  g.setX(x);
  g.setY(y);
  return g;
 }
}
