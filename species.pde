class species{
  genome mascot;
  List<genome> members;
  List<fitnessGenome> fitnessPop;
  float totalAdjFit = 0.0;
  
 species(genome genome) {
   mascot = genome;
   members = new LinkedList<genome>();
   members.add(mascot);
   fitnessPop = new ArrayList<fitnessGenome>();
   
 }
 
 void addAdjFit(float fit){
   totalAdjFit += abs(fit);
 }
 
 void reset(Random r){
   int newMascotIndex = r.nextInt(members.size());
   mascot = members.get(newMascotIndex);
   members.clear();
   fitnessPop.clear();
   totalAdjFit=0.0;
 }
 genome  mascot(){
  return mascot; 
 }
 List<fitnessGenome> fitnessPop(){
  return fitnessPop; 
 }
 
}
