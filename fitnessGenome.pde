
class fitnessGenome{
  genome genome1;
float fit;
 fitnessGenome(genome genome, float fitness){
   genome1 = genome;
   fit=fitness;
 }
 
 genome genome(){
  return genome1; 
 }
 
 float fitness(){
  return fit;
 }
}
