import java.util.*;  //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
import java.util.Map.Entry;
List<Integer> nodep = new ArrayList<Integer>();
boolean showPlease;
boolean show;
int gen;
int outputNum;
int inputNum;
int startMut;
int population;
float MUTATION_RATE;
float ADD_CONNECTION_RATE;
float ADD_NODE_RATE;
innovationGenerator nodeInn;
innovationGenerator connectionInn;
evaluate neat;
genome genome;
int indexnum;
List<Integer> steps;
List<Integer> tempList;
float[] outputs;
float[] output;
int hiddenNum;
int hiddenNum1;
pipes pipe1;
pipes pipe2;
pipes pipe3;
flapper flappy;
enum TYPE {
  INPUT,
    HIDDEN,
    HIDDEN2,
    OUTPUT;
}
int scoreNow;
void setup() {
  scoreNow=0;
  startMut = 2;
  pipe1 = new pipes(width);
  pipe2 = new pipes(int(width*1.33));
  pipe3 = new pipes(int(width*1.66));
  flappy = new flapper();
showPlease=false;
show=true;

  inputNum=4;
  hiddenNum=0;
  hiddenNum1=0;
  outputNum=1;
  indexnum = 00000;
  population =500;

  MUTATION_RATE = 0.8;
  ADD_CONNECTION_RATE = 0.75;
  ADD_NODE_RATE = 0.5;

  tempList = new ArrayList<Integer>();
  gen = 0;//generation
  steps = new ArrayList<Integer>();
  outputs = new float[outputNum];
  output = new float[outputNum];

  nodeInn = new innovationGenerator();
  connectionInn = new innovationGenerator();
  genome = new genome();
  setupGenome(  inputNum, hiddenNum, outputNum);


  //printGenome(600, 1400, 10, 280, genome, 30);
  size(1800, 1000);
  background(  89, 134, 252);
}

void draw() {
  background(89, 134, 252);
  //if(!showPlease){
  //  genome = neat.Evaluate();
  //}
  text(scoreNow,100,100);
  text(flappy.getjump(),100,125);
  scoreNow++;
  pipe1.move();
  pipe1.show();
  pipe2.move();
  pipe2.show();
  pipe3.move();
  pipe3.show();
  flappy.show();
  flappy.move();
    if(showPlease){
    pipe1.death();
    pipe2.death();
    pipe3.death();
    flappy.dead();
    showPlease=false;
    scoreNow=0;
    background(89, 134, 252);
        fill(89, 134, 252);
    rect(1200,0,width,height);
    printGenome(1400, 1600, 200, 1000, genome, 20);
    genome = neat.Evaluate();
  }
  if (pipe1.isHit() ||pipe2.isHit() ||pipe3.isHit()) {
   showPlease=true; 
  }
    fill(89, 134, 252);
    rect(1200,0,width,height);
    printGenome(1300, 1700, 200, 1000, genome, 20);
  neat.input(getInput(), genome);
  output =  neat.calculate(genome, true);
  if (output[0]>0)
    flappy.jump();

}
//
//}


void printGenome(int x1, int x2, int y1, int y2, genome g, int size) {
  nodep.clear();
  List<Integer> list;
  textSize(30);
  fill(255);
  int count = 0;
  int shift = 0;
  if (genome != null) {
    list = asSortedList(g.getNodeGenes().keySet(), tempList);
    int in = 0;
    if (ADD_NODE_RATE==0) {
      for (int i = 0; i < list.size(); i++) {
        textAlign(CENTER);
        if ( g.getNodeGenes().get(list.get(i))!= null) { 
          if ( g.getNodeGenes().get(list.get(i)).getType() == TYPE.INPUT) {
            ellipse(x1, (y1)+(in*(y2-y1))/inputNum, size, size);
            g.getNodeGenes().get(list.get(i)).setX1(x1);
            g.getNodeGenes().get(list.get(i)).setY1((y1)+(in*(y2-y1))/inputNum);
            fill(0);
            text(g.getNodeGenes().get(list.get(i)).getX(), x1, (y1)+(in*(y2-y1))/inputNum);
            fill(255);
          } else if (g.getNodeGenes().get(list.get(i)).getType() == TYPE.OUTPUT) {
            ellipse(x2, (y1)+((in-inputNum)*(y2-y1))/outputNum, size, size);
            g.getNodeGenes().get(list.get(i)).setX1(x2);
            g.getNodeGenes().get(list.get(i)).setY1(((y1)+((in-inputNum)*(y2-y1))/outputNum));
            fill(0);
            text(g.getNodeGenes().get(list.get(i)).getX(), x2+20, (y1)+((in-inputNum)*(y2-y1))/outputNum-20);
            fill(255);
          } else if ( g.getNodeGenes().get(list.get(i)).getType() == TYPE.HIDDEN) {
            ellipse(int(x1+((x2-x1)*0.33)), (y1)+((in-inputNum-outputNum)*(y2-y1))/3, size, size);
            g.getNodeGenes().get(list.get(i)).setX1(x1+(int((x2-x1)*0.33)));
            g.getNodeGenes().get(list.get(i)).setY1((y1)+((in-inputNum-outputNum)*(y2-y1))/hiddenNum);
            fill(0);
            text(g.getNodeGenes().get(list.get(i)).getX(), x1+ int((x2-x1)*0.33), (y1)+((in-inputNum-outputNum)*(y2-y1))/hiddenNum);
            fill(255);
          } 
        }
        in++;
      }
    } else {
      for (int i = 0; i < list.size(); i++) { //<>//
        textAlign(CENTER); //<>//
        if ( g.getNodeGenes().get(list.get(i))!= null) { 
          if ( g.getNodeGenes().get(list.get(i)).getType() == TYPE.INPUT) {
            ellipse(x1, (y1)+(in*(y2-y1))/inputNum, size, size);
            g.getNodeGenes().get(list.get(i)).setX1(x1);
            g.getNodeGenes().get(list.get(i)).setY1((y1)+(in*(y2-y1))/inputNum);
            fill(0);
            text(g.getNodeGenes().get(list.get(i)).getX(), x1, (y1)+(in*(y2-y1))/inputNum);
            fill(255);
          } else if (g.getNodeGenes().get(list.get(i)).getType() == TYPE.OUTPUT) {
            ellipse(x2, (y1)+((in-inputNum)*(y2-y1))/outputNum, size, size);
            g.getNodeGenes().get(list.get(i)).setX1(x2);
            g.getNodeGenes().get(list.get(i)).setY1(((y1)+((in-inputNum)*(y2-y1))/outputNum));
            fill(0);
            text(g.getNodeGenes().get(list.get(i)).getX(), x2+20, (y1)+((in-inputNum)*(y2-y1))/outputNum-20);
            fill(255);
          } else {
          //if ( in-inputNum-outputNum<(list.size()-inputNum-outputNum)/2) {
            ellipse(int(x1+((x2-x1)*0.5)), (y1)+(((in+1)-inputNum-outputNum)*(y2-y1))/(list.size()-inputNum-outputNum)/3, size, size);
            g.getNodeGenes().get(list.get(i)).setX1(x1+(int((x2-x1)*0.5)));
            g.getNodeGenes().get(list.get(i)).setY1((y1)+(((in+1)-inputNum-outputNum)*(y2-y1))/(list.size()-inputNum-outputNum)/3);
            fill(0);
            text(g.getNodeGenes().get(list.get(i)).getX(), g.getNodeGenes().get(list.get(i)).getX1(), g.getNodeGenes().get(list.get(i)).getY1());
            fill(255);
          } 
          //else {
          //  ellipse(int(x1+((x2-x1)*0.66)), (y1)+((in-inputNum-outputNum-(list.size()-inputNum-outputNum)/2)*(y2-y1))/(list.size()-inputNum-outputNum)/2, size, size);
          //  g.getNodeGenes().get(list.get(i)).setX1(x1+(int((x2-x1)*0.66)));
          //  g.getNodeGenes().get(list.get(i)).setY1((y1)+((in-inputNum-outputNum-(list.size()-inputNum-outputNum)/2)*(y2-y1))/(list.size()-inputNum-outputNum)/2);
          //  fill(0);
          //  text(g.getNodeGenes().get(list.get(i)).getX(), x1+int((x2-x1)*0.66), (y1)+((in-inputNum-outputNum-(list.size()-inputNum-outputNum)/2)*(y2-y1))/(list.size()-inputNum-outputNum)/2);
          //  fill(255);
          //}
        }
        in++;
      }
    }
  }
}


void keyReleased() {
 if (key == ' '){
 showPlease = true;
 }
 if(key=='a'){
  flappy.decJump(); 
 }
 if (key=='d'){
  flappy.incJump(); 
 }
}
//  if (key=='d') {
//    draw();
//  } else if (key =='r') {
//    savedGenome = false;
//    setup();
//  } else if (key =='g') {
//    amountOfMoves-=100;
//  } else if (key =='h') {
//    amountOfMoves +=100;
//  } else if (key == 'x') {
//    ph = -1;
//  } else if (key == 'f') {
//    fast = !fast;
//  } else if (key=='/') {
//    skip=-1;
//  } else if (key == 'n') {
//    indexnum = amountOfMoves+1;
//  } else if (key == 'u') {
//    skip = gen-1;
//  } else if (key =='q') {
//    population-=100;
//    println("\n"+population);
//  } else if (key =='w') {
//    population+=100;
//    println("\n"+population);
//  } else if (key =='l') {
//    coinskip = 0;
//  } else if (key == 's') {
//    if (slow) {
//      frameRate(900);
//      slow = !slow;
//    } else {
//      frameRate(2);
//      slow = !slow;
//    }
//  }
//}

int maxIndex(float arr[], boolean show) {
  //if (outputNum>2) {
  //  if (arr[2]>abs(arr[1])||arr[2]>abs(arr[0])||(arr[0]==-9999999&&arr[1]==-9999999)) {
  //    return 0;
  //  }
  //}
  if (outputNum > 3) {
    for (int i = 0; i < outputNum; i++) {
      if (arr[i] == -9999999)
        arr[i]=0;
    }
    float leftRight = arr[0]-arr[1];
    float upDown = arr[2]-arr[3];
    if (show) {
      fill(0);
      text(leftRight, width-175, height-625);
      text(upDown, width-175, height-325);
    }
    if (abs(leftRight)>=1&&abs(upDown)>=1) {
      if (leftRight<0&&upDown>0) {
        return 3;
      } else  if (leftRight<0&&upDown<0) {
        return -3;
      } else  if (leftRight>0&&upDown>0) {
        return -4;
      } else {
        return 4;
      }
    } else if (abs(leftRight)>=1&&abs(upDown)<1) {
      return (leftRight>0)?1:-1;
    } else if (abs(leftRight)<1&&abs(upDown)>=1) {
      return (upDown>0)?2:-2;
    } else return 0;
    // fill(255, 0, 0);

    //if (min == -9999999)
    //  return 5;
    //return mini;
  } else {
    for (int i = 0; i < outputNum; i++) {
      if (arr[i] == -9999999)
        arr[i]=0;
    }
    if (outputNum==3) {
      if (arr[2]>abs(arr[1])&&arr[2]>abs(arr[0])) {
        return 0;
      }
    }
    if (abs(arr[0])>=1&&abs(arr[1])>=1) {
      if (arr[0]<0&&arr[1]>0) {
        return 3;
      } else  if (arr[0]<0&&arr[1]<0) {
        return -3;
      } else  if (arr[0]>0&&arr[1]>0) {
        return -4;
      } else {
        return 4;
      }
    } else if (abs(arr[0])>=1&&abs(arr[1])<1) {
      return (arr[0]>0)?1:-1;
    } else if (abs(arr[0])<1&&abs(arr[1])>=1) {
      return (arr[1]>0)?2:-2;
    } else return 0;
  }
}

int minIndex(float arr[]) {
  int mini = 0;
  float min = arr[0];
  for (int i = 0; i< arr.length; i++) {
    if (min == 0 && arr[i]!= 0) {
      min = arr[i];
      mini=i;
    }
    if (arr[i]<min&& arr[i]!=0) {
      min = arr[i];
      mini=i;
    }
  }

  if (min == 0)
    return 5;
  return mini;
}
int findIndex(List<Integer> x, int y) {
  for (int i = 0; i < x.size(); i++) {
    if (x.get(i)==y) {
      return i ;
    }
  }
  return -1;
}

void setupGenome(  int inputNum, int hiddenNum, int outputNum) {
  for (int i = 0; i < inputNum; i++) {
    genome.addNodeGene(new nodeGene(TYPE.INPUT, nodeInn.getInn()));
  }
  for (int i = 0; i < outputNum; i++) {
    genome.addNodeGene(new nodeGene(TYPE.OUTPUT, nodeInn.getInn()));
  }
  for (int i = 0; i < hiddenNum; i++) {
    genome.addNodeGene(new nodeGene(TYPE.HIDDEN, nodeInn.getInn()));
  }
  for (int i = 0; i <startMut; i++) {
    genome.addConnectionMutation(new Random(), connectionInn, 20);
  }
  neat = new evaluate(population, genome, nodeInn, connectionInn);
}
float[] getInput() {
  float[] ip = new float[4];
  ip[0]=map(flappy.getY(),0,height,0,1);
  //ip[1]=map(flappy.getV(),-100,100,0,1);
  if (pipe1.x()<pipe2.x()&&pipe1.x()<pipe3.x()) {
    ip[2]=map(height-pipe1.y(),0,height,0,1);
    ip[3]=map(abs((height-pipe1.y()))-250,0,height,0,1);
    ip[1]=map(pipe1.x(),0,1200,0,1);
  } else if (pipe2.x()<pipe3.x()) {
    ip[2]=map(height-pipe2.y(),0,height,0,1);
     ip[3]=map(abs((height-pipe2.y()))-250,0,height,0,1);
    ip[1]=map(pipe2.x(),0,1200,0,1);
  } else {
    ip[2]=map(height-pipe3.y(),0,height,0,1);
     ip[3]=map(abs((height-pipe3.y()))-250,0,height,0,1);
    ip[1]=map(pipe3.x(),0,1200,0,1);
  }
  return ip;
}
