
class connectionGene{
  int inNode,outNode,innum;
float weight;
boolean expressed;

  connectionGene(int innode, int outnode, float Weight, boolean E, int inum){
   inNode = innode;
   outNode=outnode;
   weight = Weight;
   expressed = E;
   innum=inum;
   
 }
 connectionGene(connectionGene con) {
    this.inNode = con.inNode;
    this.outNode = con.outNode;
    this.weight = con.weight;
    this.expressed = con.expressed;
    this.innum = con.innum;
  }
 
 int getInNode(){
  return inNode;
 }
 
 void setE(boolean z){
   expressed = z;
 }
 
 int getOutNode(){
  return outNode;
 }
 
 float getWeight(){
  return weight; 
 }
 
 boolean isExpressed(){
  return expressed; 
 }
 
 int getInNum(){
  return innum; 
 }
 
 void disable(){
  expressed = false; 
 }
 
 void enable(){
  expressed = true; 
 }
 
 connectionGene copy(){
   return new connectionGene(inNode,outNode,weight,expressed,innum);
 }
 
 void setWeight(float x){
  weight = x;
 }
 
}
