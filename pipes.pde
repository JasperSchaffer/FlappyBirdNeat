class pipes{
int x,y,w,x2;

pipes(int x1){
  y = int(random(250,700));
  x = x1;
  x2 = x1;
  w=100;
}

int move(){
 x=x<-100?reset():x-5; 
 if (x==width)
 return 200;
 return 0;
}

int x(){
 return x; 
}

int y(){
 return y; 
}
void death(){
  x=x2;
  y = int(random(250,700));
}

void show(){    
 fill(0, 255, 0);
 rect(x,height-y,w,y); 
 rect(x,0,100,abs((height-y)-250)); 

}

int reset(){
    y = int(random(250,700));
    return width;
}

 boolean isHit(){
float xsq = ((x-flappy.getX())*(x-flappy.getX()));
   float ysq= ((height-y)-flappy.getY())*((height-y)-flappy.getY());
    float xsq1 = ((x+100-flappy.getX())*(x+100-flappy.getX()));
   float ysq1= ((height-y-250)-flappy.getY())*((height-y-250)-flappy.getY());
   
   if(flappy.getX()+flappy.getR()>x&&flappy.getX()-flappy.getR()<x+w){
   if((flappy.getY()+flappy.getR()>height-y||flappy.getY()+flappy.getR()<abs((height-y)-250))){
     return true;
   }
   }
   if(sqrt(xsq+ysq)<flappy.getR() || sqrt(xsq1+ysq)<flappy.getR() || sqrt(xsq+ysq1)<flappy.getR() || sqrt(xsq1+ysq1)<flappy.getR()  ){
     return true;
   }
   if(flappy.getY()+flappy.getR()>height||flappy.getY()-flappy.getR()<0)
   return true;
   return false;
  }

}//end class
