//<>// //<>// //<>//
class genome {

  Map<Integer, connectionGene> connections;
  Map<Integer, nodeGene> nodes;
  List<Integer> temp1;
  List<Integer> temp2;
  float PROBABILITY_PERTURBING = 0.9f; // rest is probability of assigning new weight
  float PROBABILITY_PERTURBING_NODE = 0.3f; // rest is probability of assigning new function
  genome() {
    connections = new HashMap<Integer, connectionGene>();
    nodes = new HashMap<Integer, nodeGene>();
    temp1 = new ArrayList<Integer>();
    temp2 = new ArrayList<Integer>();

    temp1.add(1);
    temp2.add(1);
  }

  genome(genome toBeCopied) {
    nodes = new HashMap<Integer, nodeGene>();
    connections = new HashMap<Integer, connectionGene>();

    for (Integer index : toBeCopied.getNodeGenes().keySet()) {
      nodes.put(index, new nodeGene(toBeCopied.getNodeGenes().get(index)));
    }

    for (Integer index : toBeCopied.getConnectionGenes().keySet()) {
      connections.put(index, new connectionGene(toBeCopied.getConnectionGenes().get(index)));
    }
  }
  Map<Integer, connectionGene> getConnectionGenes() {
    return connections;
  }

  Map<Integer, nodeGene> getNodeGenes() {
    return nodes;
  }

  void addNodeGene(nodeGene gene) {
    nodes.put(gene.getID(), gene);
  }

  void addConnectionGene(connectionGene gene) {
    connections.put(gene.getInNum(), gene);
  }

  void addConnectionMutation(Random r, innovationGenerator innovation, int maxAttempts) {
    int tries = 0;
    boolean success= false;
    while (tries<maxAttempts && !success) {
      tries++;
      nodeGene node1 = nodes.get(r.nextInt(nodes.size()));
      nodeGene node2 = nodes.get(r.nextInt(nodes.size())); 
      boolean reverse = false;
      boolean connectionImpossible = false;
      boolean CE = false;
      if (node1!=null && node2!= null) {
        float weight = r.nextFloat()*2-1;
        if (abs(weight)<0.05)
          weight = weight<0?-0.05:0.05;

        if (node1.getType() == TYPE.HIDDEN && node2.getType() == TYPE.INPUT) {
          reverse = true;
        } else if (node1.getType() == TYPE.HIDDEN && node2.getType() == TYPE.INPUT) {
          reverse = true;
        } else if (node1.getType() == TYPE.OUTPUT && node2.getType() == TYPE.HIDDEN2) {
          reverse = true;
        } else if (node1.getType() == TYPE.HIDDEN2 && node2.getType() == TYPE.HIDDEN) {
          reverse = true;
        }

        if (node1.getType() == TYPE.INPUT && node2.getType() == TYPE.INPUT) {
          connectionImpossible = true;
        } else if (node1.getType() == TYPE.OUTPUT && node2.getType() == TYPE.OUTPUT) {
          connectionImpossible = true;
        } else if (node1.getType() == TYPE.HIDDEN && node2.getType() == TYPE.HIDDEN) {
          connectionImpossible = true;
        } else if (node1.getType() == TYPE.INPUT && node2.getType() == TYPE.OUTPUT) {
          //connectionImpossible = true;//**
        } else if (node1.getType() == TYPE.OUTPUT && node2.getType() == TYPE.INPUT) {
          connectionImpossible = true;
        } else if (node1.getType() == TYPE.HIDDEN2 && node2.getType() == TYPE.INPUT) {
          connectionImpossible = true;
        } else if (node1.getType() == TYPE.INPUT && node2.getType() == TYPE.HIDDEN2) {
          //connectionImpossible = true;//**
        } else if (node1.getType() == TYPE.HIDDEN2 && node2.getType() == TYPE.HIDDEN2) {
          connectionImpossible = true;
        } else if (node1.getType() == TYPE.HIDDEN && node2.getType() == TYPE.OUTPUT&& hiddenNum1 !=0) {
          //connectionImpossible = true;//**
        } else if (node1.getType() == TYPE.OUTPUT && node2.getType() == TYPE.HIDDEN&& hiddenNum1 !=0) {
          connectionImpossible = true;
        }


        for (connectionGene con : connections.values()) {
          if (con.getInNode() == node1.getID() && con.getOutNode() == node2.getID()) {
            CE = true;
            break;
          } else if (con.getInNode() == node2.getID() && con.getOutNode() == node1.getID()) {
            CE = true;
            break;
          }
        }
        if (CE||connectionImpossible) {
          continue;
        } else {
          connectionGene newcon = new connectionGene(reverse? node2.getID():node1.getID(), reverse? node1.getID():node2.getID(), weight, true, innovation.getInn());
          connections.put(newcon.getInNum(), newcon);
          success = true;
        }
      }
      if (!success) {
      }
    }
    if (tries == maxAttempts) {
      //println("Tried, but could not add more connections");
    }
  }//

  void mutation(Random r) {
    for (connectionGene con : connections.values()) {
      if (r.nextFloat()<PROBABILITY_PERTURBING) {
        float changernum =0;
        for (int i = 0; i < 10&&abs(changernum)>100||abs(changernum)<0.05; i++) {
          changernum= con.getWeight()*(r.nextFloat()*4.0-2.0);
        }
        if (abs(changernum)>100)
          con.setWeight(changernum>0?100:-100);
        if (abs(changernum)<0.05)
          con.setWeight(changernum<0?-0.05:0.05);
      } else {
        float we = r.nextFloat()*4.0-2.0;
        con.setWeight((abs(we)>100&&abs(we)<0.05)?1:we);
      }
      if (r.nextFloat()<0.012) {
        con.setE(!con.isExpressed());
      }
    }
    for (nodeGene con : nodes.values()) {
      if (r.nextFloat()<PROBABILITY_PERTURBING_NODE) {
        con.setY(int(random(6)));
      } else if (r.nextFloat()<PROBABILITY_PERTURBING_NODE) {
        //con.setB(r.nextFloat()*4-2) ;
      }
    }
  }

  void addNodeMutation(Random r, innovationGenerator conenectionInnovation, innovationGenerator nodeInnovation, int attempts) {
    if (connections.size()!=0) {
      connectionGene con = (connectionGene) connections.values().toArray()[r.nextInt(connections.size())];
       nodeGene inNode = nodes.get(con.getInNode());
      nodeGene outNode = nodes.get(con.getOutNode());
      int z = 0;
      boolean foundspot = false;
      boolean impossible = false;
      while (impossible&&z<attempts) {
       con = (connectionGene) connections.values().toArray()[r.nextInt(connections.size())];
       inNode = nodes.get(con.getInNode());
       outNode = nodes.get(con.getOutNode());
        inNode = nodes.get(con.getInNode());
        outNode = nodes.get(con.getOutNode());
        if (inNode.getType() == TYPE.HIDDEN && outNode.getType()== TYPE.HIDDEN) {
          impossible = true ;
        }
        if (inNode.getType() == TYPE.HIDDEN2 && outNode.getType()== TYPE.HIDDEN2) {
       impossible = true ;
          
        }
        if (inNode.getType() == TYPE.HIDDEN2 && outNode.getType()== TYPE.HIDDEN) {
          impossible = true ;
          
        }
                    if (inNode.getType() == TYPE.HIDDEN && outNode.getType()== TYPE.INPUT) {
          impossible = true ;
          
        }
                if (outNode.getType()== TYPE.INPUT) {
          impossible = true ;
          
        }
                if (inNode.getType() == TYPE.OUTPUT) {
          impossible = true ;
          
        }
        z++;
      }
      if (!impossible) {
        con.disable();
        nodeGene newNode;
if(Math.random()<0.5){
         newNode = new nodeGene(TYPE.HIDDEN, nodeInnovation.getInn());
         
}else{
         newNode = new nodeGene(TYPE.HIDDEN2, nodeInnovation.getInn());
         }
        newNode.setY(int(random(6)));
        connectionGene inToNew = new connectionGene(inNode.getID(), newNode.getID(), 1f, true, conenectionInnovation.getInn());
        connectionGene newToOut = new connectionGene(newNode.getID(), outNode.getID(), con.getWeight(), true, conenectionInnovation.getInn());

        nodes.put(newNode.getID(), newNode);
        connections.put(inToNew.getInNum(), inToNew);
        connections.put(newToOut.getInNum(), newToOut);
      }
    }
  }

  genome crossover(genome parent1, genome parent2, Random r) {
    genome child = new genome();

    for (nodeGene parent1node : parent1.getNodeGenes().values()) {
      child.addNodeGene(parent1node.copy());
    }
    for (connectionGene parent1node : parent1.getConnectionGenes().values()) {
      if (parent2.getConnectionGenes().containsKey(parent1node.getInNum())) {//mathcing gene
        connectionGene childCon = r.nextBoolean() ? parent1node.copy():parent2.getConnectionGenes().get(parent1node.getInNum()).copy();
        child.addConnectionGene(childCon);
      } else {//disjointed
        child.addConnectionGene(parent1node.copy());
      }
    }
    return child;
  }

  float compatibilityD(genome genome1, genome genome2, float c1, float c2, float c3, float c4) {
    int matchingGenes = 0;
    int disjointedGenes = 0;
    int excessGenes = 0;
    int weightDifference = 0;
    int enabledDiff = 0;
    List<Integer> nodekey1 = asSortedList((genome1.getNodeGenes().keySet()), tempList);
    List<Integer> nodekey2 = asSortedList((genome2.getNodeGenes().keySet()), tempList);

    int highestInnovation1 = nodekey1.get(nodekey1.size()-1);
    int highestInnovation2 = nodekey2.get(nodekey2.size()-1);
    int index = Math.max(highestInnovation1, highestInnovation2);

    for (int i = 0; i <= index; i++) {
      nodeGene node1 = genome1.getNodeGenes().get(i);
      nodeGene node2 = genome2.getNodeGenes().get(i);    

      if (node1 == null && highestInnovation1 < i && node2 != null) {
        excessGenes++;
      } else if (node2 == null && highestInnovation2 < i && node1 != null) {
        excessGenes++;
      }    
      if (node1 != null  &&node2!= null) {
        matchingGenes++;
      }
      if (node1 == null && highestInnovation1 > i && node2!= null) {
        disjointedGenes++;
      } else if (node2 == null && highestInnovation2 > i && node1!= null) {
        disjointedGenes++;
      }
    }

    List<Integer> conkey1 = asSortedList((genome1.getConnectionGenes().keySet()), tempList);
    List<Integer> conkey2 = asSortedList((genome2.getConnectionGenes().keySet()), tempList);

    if (conkey1.size()!=0) {
      highestInnovation1 = conkey1.get(conkey1.size()-1);
      highestInnovation2 = conkey2.get(conkey2.size()-1);
    } else {
      highestInnovation1=-1;
      highestInnovation2=-1;
    }
    index = Math.max(highestInnovation1, highestInnovation2);

    for (int i = 0; i <= index; i++) {
      connectionGene node1 = genome1.getConnectionGenes().get(i);
      connectionGene node2 = genome2.getConnectionGenes().get(i);   

      if (node1 == null && highestInnovation1 < i && node2 != null) {
        excessGenes++;
      } else if (node2 == null && highestInnovation2 < i && node1 != null) {
        excessGenes++;
      }

      if (node1 != null && node2 != null) {
        if (node1.expressed&&node2.expressed) {
          matchingGenes++;
          weightDifference += Math.abs(node1.getWeight()-node2.getWeight());
        } else {
          if (!node1.expressed&&node2.expressed) {
            enabledDiff++;
          } else if (node1.expressed&&!node2.expressed) {
            enabledDiff++;
          }
        }
      }
      if (node1 == null && highestInnovation1 > i && node2!= null) {
        disjointedGenes++;
      } else if (node2 == null && highestInnovation2 > i && node1!= null) {
        disjointedGenes++;
      }
    }
    float awd = 0;
    if (matchingGenes ==0) {
      awd= weightDifference;
    } else {
      awd= weightDifference/matchingGenes;
    }
    return c1* excessGenes+c2*disjointedGenes+c3*awd+enabledDiff*c4;
  }//end comp D

  float averageWeightDiff(genome genome1, genome genome2) {
    int  highestInnovation1=-1;
    int highestInnovation2=-1;

    int weightDifference = 0;
    int matchingGenes=0;
    List<Integer> conkey1 = asSortedList((genome1.getConnectionGenes().keySet()), tempList);
    List<Integer> conkey2 = asSortedList((genome2.getConnectionGenes().keySet()), tempList);

    if (conkey1.size()!=0) {
      highestInnovation1 = conkey1.get(conkey1.size()-1);
      highestInnovation2 = conkey2.get(conkey2.size()-1);
    } else {
      highestInnovation1=-1;
      highestInnovation2=-1;
    }
    int  index = Math.max(highestInnovation1, highestInnovation2);

    for (int i = 0; i <= index; i++) {
      connectionGene node1 = genome1.getConnectionGenes().get(i);
      connectionGene node2 = genome2.getConnectionGenes().get(i); 

      if (node1 != null && node2 != null) {
        matchingGenes++;
        weightDifference += Math.abs(node1.getWeight()-node2.getWeight());
      }
    }

    if (matchingGenes ==0)
      return weightDifference;
    return weightDifference/matchingGenes;
  }//end matching
}//end class

private static List<Integer> asSortedList(Collection<Integer> c, List<Integer> list) {
  list.clear();
  list.addAll(c);
  java.util.Collections.sort(list);
  return list;
}
