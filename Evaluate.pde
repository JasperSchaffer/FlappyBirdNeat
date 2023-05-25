import java.util.Collections; //<>// //<>// //<>// //<>// //<>// //<>// //<>//
import java.util.Comparator;
float highscore;
int maxTime = 8;

//float MUTATION_RATE = 0.5;
//float ADD_CONNECTION_RATE = 0.5;
//float ADD_NODE_RATE = 0.15;
class evaluate {
  private FitnessGenomeComparator fitComp = new FitnessGenomeComparator();

  Map<genome, species> speciesMap;
  Map<genome, Float> scoreMap;
  List<genome> genomes;
  List<species> speciesList;
  List<genome> nextGen;
  List<genome> blank;


  innovationGenerator nodeInnovation;
  innovationGenerator connectionInnovation;
  Random random = new Random();

  int population;
  //tuning
  float c1 = 0.75;
  float c2= 0.75;
  float c3 = 1;
  float c4 = 0.5;
  float DT = 4;


  genome fittestGenome;


  evaluate(int populationSize, genome startingGenome, innovationGenerator node, innovationGenerator connect) {
    this.population = populationSize;
    this.nodeInnovation = node;
    this.connectionInnovation = connect;
    genomes = new ArrayList<genome>(populationSize);
    for (int i1 = 0; i1 < populationSize; i1++) {
      genomes.add(new genome(startingGenome));
    }
    nextGen = new ArrayList<genome>(populationSize);
    speciesMap = new HashMap<genome, species>();
    scoreMap = new HashMap<genome, Float>();
    speciesList = new ArrayList<species>();
  }


  evaluate(int populationSize, genome startingGenome, innovationGenerator node, innovationGenerator connect, genome startingGenome1) {
    this.population = populationSize;
    this.nodeInnovation = node;
    this.connectionInnovation = connect;
    genomes = new ArrayList<genome>(populationSize);
    genomes.add(new genome(startingGenome));
    startingGenome = new genome();
    for (int i = 0; i < inputNum; i++) {
      startingGenome.addNodeGene(new nodeGene(TYPE.INPUT, nodeInn.getInn()));
    }
    for (int i = 0; i < outputNum; i++) {
      startingGenome.addNodeGene(new nodeGene(TYPE.OUTPUT, nodeInn.getInn()));
    }
    for (int i = 0; i < hiddenNum; i++) {
      startingGenome.addNodeGene(new nodeGene(TYPE.HIDDEN, nodeInn.getInn()));
    }
    for (int i = 0; i < hiddenNum1; i++) {
      startingGenome.addNodeGene(new nodeGene(TYPE.HIDDEN2, nodeInn.getInn()));
    }
    for (int i = 0; i <1000; i++) {
      startingGenome.addConnectionMutation(new Random(), connectionInn, 20);
    }
    for (int i = 1; i < populationSize; i++) {
      genomes.add(new genome(startingGenome1));
    }
    nextGen = new ArrayList<genome>(populationSize);
    speciesMap = new HashMap<genome, species>();
    scoreMap = new HashMap<genome, Float>();
    speciesList = new ArrayList<species>();
  }

  genome Evaluate() {
    for (species s : speciesList) {
      s.reset(random);
    }
    scoreMap.clear();
    speciesMap.clear();
    nextGen.clear();
    highscore = Float.MIN_VALUE;
    fittestGenome = null;
    int a =0;
    for (genome g : genomes) {
      
      boolean found = false;
      for (species s : speciesList) {
        float az=g.compatibilityD(g, s.mascot(), c1, c2, c3, c4);
        if (az<DT) {
          s.members.add(g);
          speciesMap.put(g, s);
          found = true;
          break;
        }
      }
      if (!found) {
        species newSpecies = new species(g);
        speciesList.add(newSpecies);
        speciesMap.put(g, newSpecies);
      }
      
    }
    Iterator<species> i = speciesList.iterator();
    while (i.hasNext()) {
      species s = i.next();
      if (s.members.isEmpty()) {
        i.remove();
      }
    }
    //println();
    for (genome g : genomes) {
      if (a%100==0)
        print("[]");
      species s = speciesMap.get(g);
      float score = evaluateGenome(g);
      float adj = score / s.members.size();

      s.addAdjFit(adj);
      s.fitnessPop.add(new fitnessGenome(g, adj));
      scoreMap.put(g, adj);
      if (score>=highscore) {
        highscore = score;
        fittestGenome = g;
      }
      a++;
    }
    println();
    print(population+"\n");

    for (species s : speciesList) {
      Collections.sort(s.fitnessPop(), fitComp);
      Collections.reverse(s.fitnessPop);
      fitnessGenome fittest = s .fitnessPop.get(0);
      nextGen.add(fittest.genome());
    }
    println();
    while (nextGen.size()<population-1) {
      species s = getRandomSpeciesBiasedAjdustedFitness(random);

      genome p1 = getRandomGenomeBiasedAdjustedFitness(s, random);
      genome p2 = getRandomGenomeBiasedAdjustedFitness(s, random);
      genome child;
      if (scoreMap.get(p1)>= scoreMap.get(p2)) {
        child = p1.crossover(p1, p2, random);
      } else {
        child = p1.crossover(p2, p2, random);
      }
      boolean change = true;
      change = false;
      if (random.nextFloat()<MUTATION_RATE) {
        child.mutation(random);
        change = true;
      }
      if (random.nextFloat()< ADD_CONNECTION_RATE) {
        child.addConnectionMutation(random, connectionInnovation, 5);
        change = true;
      }

      if (random.nextFloat()< ADD_NODE_RATE) {
        child.addNodeMutation(random, connectionInnovation, nodeInnovation, 5);
        change = true;
      }

      nextGen.add(child);
    }
    nextGen.add(fittestGenome);
    genomes = nextGen;
    nextGen =new ArrayList<genome>(population);
    println(highscore);
    println(speciesList.size());
    
    return fittestGenome;
  }



  private species getRandomSpeciesBiasedAjdustedFitness(Random random) {
    double completeWeight = 0.0;  // sum of probablities of selecting each species - selection is more probable for species with higher fitness
    for (species s : speciesList) {
      completeWeight += s.totalAdjFit;
    }
    double r = Math.random() * completeWeight;
    double countWeight = 0.0;
    for (species s : speciesList) {
      countWeight += s.totalAdjFit;
      if (countWeight >= r) {
        return s;
      }
    }
    throw new RuntimeException("Couldn't find a species... Number is species in total is "+speciesList.size()+", and the total adjusted fitness is "+completeWeight);
  }

  private genome getRandomGenomeBiasedAdjustedFitness(species selectFrom, Random random) {
    double completeWeight = 0.0;  // sum of probablities of selecting each genome - selection is more probable for genomes with higher fitness
    for (fitnessGenome fg : selectFrom.fitnessPop) {
      completeWeight += fg.fitness();
    }
    double r = Math.random() * (completeWeight*0.95);
    double countWeight = 0.0;
    for (fitnessGenome fg : selectFrom.fitnessPop) {
      countWeight += fg.fitness();
      if (countWeight >= r) {
        return fg.genome();
      }
    }
    //if(selectFrom.fitnessPop.size()>0){
    //return selectFrom.fitnessPop.get((random.nextInt(selectFrom.fitnessPop.size()-1))).genome();
    //}
    throw new RuntimeException("Couldn't find a genome... Number is genomes in selæected species is "+selectFrom.fitnessPop.size()+", and the total adjusted fitness is "+completeWeight);
  }

  public int getSpeciesAmount() {
    return speciesList.size();
  }

  public float getHighestFitness() {
    return highscore;
  }

  public genome getFittestGenome() {
    return fittestGenome;
  }



  float evaluateGenome (genome g) {
    int tries=1;
    int time = 0;
    while (time<50000) {
     time+= pipe1.move();

    time+=  pipe2.move();
    
    time+=  pipe3.move();
     

      flappy.move();
      input(getInput(), g);
      if (calculate(g, false)[0]>0)
        flappy.jump();
      time++;
      if (pipe1.isHit() ||pipe2.isHit() ||pipe3.isHit()) {
        pipe1.death();
        pipe2.death();
        pipe3.death();
        flappy.dead();
        tries++;
        if (tries >5)
        return time/tries;
      }
    }
    return time/tries;
  }

  float[] calculate(genome g, boolean show) {


    List<Integer>  list = asSortedList(g.getNodeGenes().keySet(), tempList);
    for (int i = 0; i < list.size(); i++) {
      if (g.getNodeGenes().get(list.get(i))!=null&&g.getNodeGenes().get(list.get(i)).getType() !=TYPE.INPUT) {
        g.getNodeGenes().get(list.get(i)).setX(0);
      }
    }
    list = asSortedList(g.getConnectionGenes().keySet(), tempList);
    for (int i = 0; i < list.size(); i++) {
      if (g.getConnectionGenes().get(list.get(i))!=null) {
        int idOut = g.getConnectionGenes().get(list.get(i)).getOutNode();
        int idIn = g.getConnectionGenes().get(list.get(i)).getInNode();
        float weight = g.getConnectionGenes().get(list.get(i)).getWeight();
        boolean e = g.getConnectionGenes().get(list.get(i)).isExpressed();
        if (abs(weight)<0.05) {
          weight = weight<0?-0.05:0.05;
          g.getConnectionGenes().get(list.get(i)).setWeight(weight);
        }
        if (g.getNodeGenes().get(idIn).getX() == -9999999&&g.getNodeGenes().get(idIn).getType() == TYPE.HIDDEN) {
          g.getNodeGenes().get(idIn).setX(0);
        }
        if (g.getNodeGenes().get(idIn).getX() == -9999999&&g.getNodeGenes().get(idIn).getType() == TYPE.HIDDEN2) {
          g.getNodeGenes().get(idIn).setX(0);
        }
        if (g.getNodeGenes().get(idOut).getType() == TYPE.HIDDEN) {
          if (g.getNodeGenes().get(idOut).getX() == -9999999) {
            g.getNodeGenes().get(idOut).setX(0);
          }
          if (e) {
            switch(g.getNodeGenes().get(idOut).getY()) {
              case(0):
              case(1):
              g.getNodeGenes().get(idOut).setX(g.getNodeGenes().get(idOut).getX()+g.getNodeGenes().get(idIn).getX()*weight);
              break;
              case(2):
              case(5):
              float yu =g.getNodeGenes().get(idOut).getX()-g.getNodeGenes().get(idIn).getX()*weight;
              g.getNodeGenes().get(idOut).setX(yu);
              break;
              case(3):
              if (g.getNodeGenes().get(idOut).getX()==0) {
                g.getNodeGenes().get(idOut).setX(1);
              }
              g.getNodeGenes().get(idOut).setX( g.getNodeGenes().get(idOut).getX()* g.getNodeGenes().get(idOut).getX());

              break;
              case(4):
              g.getNodeGenes().get(idOut).setX(sqrt(sq(g.getNodeGenes().get(idOut).getX())+sq(g.getNodeGenes().get(idIn).getX()*weight)));
              break;
            }
            if (show) { //<>//
              strokeWeight(abs(weight)*2); //<>//
              if (weight>0) {
                stroke(255);
              }

              line(g.getNodeGenes().get(idOut).getX1(), g.getNodeGenes().get(idOut).getY1(), g.getNodeGenes().get(idIn).getX1(), g.getNodeGenes().get(idIn).getY1());
              strokeWeight(2);
              stroke(0);
            }
          }
        }
      }
    }
    for (int i = 0; i < list.size(); i++) {
      if (g.getConnectionGenes().get(list.get(i))!=null) {
        int idOut = g.getConnectionGenes().get(list.get(i)).getOutNode();
        int idIn = g.getConnectionGenes().get(list.get(i)).getInNode();
        float weight = g.getConnectionGenes().get(list.get(i)).getWeight();
        boolean e = g.getConnectionGenes().get(list.get(i)).isExpressed();
        if (g.getNodeGenes().get(idIn).getX() == -9999999&&g.getNodeGenes().get(idIn).getType() == TYPE.HIDDEN2) {
          g.getNodeGenes().get(idIn).setX(0);
        }
        if (g.getNodeGenes().get(idIn).getX() == -9999999&&g.getNodeGenes().get(idIn).getType() == TYPE.HIDDEN) {
          g.getNodeGenes().get(idIn).setX(0);
        }
        if (g.getNodeGenes().get(idOut).getType() == TYPE.HIDDEN2) {
          if (g.getNodeGenes().get(idOut).getX() == -9999999) {
            g.getNodeGenes().get(idOut).setX(0);
          }
          if (e) {
            switch(g.getNodeGenes().get(idOut).getY()) {
              case(0):
              case(1):
              float uy = g.getNodeGenes().get(idOut).getX()+g.getNodeGenes().get(idIn).getX()*weight;
              g.getNodeGenes().get(idOut).setX(uy);
              break;
              case(2):
              case(5):
              float yu =g.getNodeGenes().get(idOut).getX()-g.getNodeGenes().get(idIn).getX()*weight;
              g.getNodeGenes().get(idOut).setX(yu);
              break;
              case(3):
              if (g.getNodeGenes().get(idOut).getX()==0) {
                g.getNodeGenes().get(idOut).setX(1);
              }
              g.getNodeGenes().get(idOut).setX( g.getNodeGenes().get(idOut).getX()* g.getNodeGenes().get(idOut).getX());

              break;
              case(4):
              g.getNodeGenes().get(idOut).setX(sqrt(sq(g.getNodeGenes().get(idOut).getX())+sq(g.getNodeGenes().get(idIn).getX()*weight)));
              break;
            }
            if (show) {
              strokeWeight(abs(weight)*2);
              if (weight>0) {
                stroke(255);
              }

              line(g.getNodeGenes().get(idOut).getX1(), g.getNodeGenes().get(idOut).getY1(), g.getNodeGenes().get(idIn).getX1(), g.getNodeGenes().get(idIn).getY1());
              strokeWeight(2);
              stroke(0);
            }
          }
        }
      }
    }


    list = asSortedList(g.getNodeGenes().keySet(), tempList);
    for (int i = 0; i < list.size(); i++) {
      if (g.getNodeGenes().get(list.get(i))!=null&&g.getNodeGenes().get(list.get(i)).getType() ==TYPE.HIDDEN) {
        g.getNodeGenes().get(list.get(i)).setX(g.getNodeGenes().get(list.get(i)).getX()+g.getNodeGenes().get(list.get(i)).getB());
      }
      if (g.getNodeGenes().get(list.get(i))!=null&&g.getNodeGenes().get(list.get(i)).getType() ==TYPE.HIDDEN2) {
        g.getNodeGenes().get(list.get(i)).setX(g.getNodeGenes().get(list.get(i)).getX()+g.getNodeGenes().get(list.get(i)).getB());
      }
    }
    list = asSortedList(g.getConnectionGenes().keySet(), tempList);
    for (int i = 0; i < list.size(); i++) {
      if (g.getConnectionGenes().get(list.get(i))!=null) {
        int idOut = g.getConnectionGenes().get(list.get(i)).getOutNode();
        int idIn = g.getConnectionGenes().get(list.get(i)).getInNode();
        float weight = g.getConnectionGenes().get(list.get(i)).getWeight();
        boolean e = g.getConnectionGenes().get(list.get(i)).isExpressed();
        if (g.getNodeGenes().get(idOut).getType() == TYPE.OUTPUT&&e) {
          if (g.getNodeGenes().get(idOut).getX()==-9999999 ) {
            g.getNodeGenes().get(idOut).setX(g.getNodeGenes().get(idIn).getX()*weight);
          } else {
            g.getNodeGenes().get(idOut).setX(g.getNodeGenes().get(idOut).getX()+g.getNodeGenes().get(idIn).getX()*weight);
            // outputs[idOut-inputNum]+=(g.getNodeGenes().get(idOut).getX());
          }
          if (show) {
            strokeWeight(abs(weight)*2);
            if (weight>0) {
              stroke(255);
            }

            line(g.getNodeGenes().get(idOut).getX1(), g.getNodeGenes().get(idOut).getY1(), g.getNodeGenes().get(idIn).getX1(), g.getNodeGenes().get(idIn).getY1());
            strokeWeight(2);
            stroke(0);
          }
        }
      }
    }
    for (int i = 0; i < outputNum; i++) {
      outputs[i] = 0;
    }
    for (int i = 0; i < list.size(); i++) {
      if (g.getConnectionGenes().get(list.get(i))!=null) {
        boolean e = g.getConnectionGenes().get(list.get(i)).isExpressed();
        int idOut = g.getConnectionGenes().get(list.get(i)).getOutNode();
        if (g.getNodeGenes().get(idOut).getType() == TYPE.OUTPUT&&e) {
          outputs[idOut-inputNum]=(g.getNodeGenes().get(idOut).getX());
        }
      }
    }
    return outputs;
  }

  void input(float[] inputs, genome g) {
    for ( int i = 0; i < inputNum; i++) {
      if (g.getNodeGenes().get(i).getType() == TYPE.INPUT) {
        g.getNodeGenes().get(i).setX(inputs[i]);
      }
    }
  }
}

public class FitnessGenomeComparator implements Comparator<fitnessGenome> {

  @Override
    public int compare(fitnessGenome one, fitnessGenome two) {
    if (one.fitness() > two.fitness()) {
      return 1;
    } else if (one.fitness() < two.fitness()) {
      return -1;
    }
    return 0;
  }
}
