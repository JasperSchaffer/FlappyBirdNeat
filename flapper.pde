class flapper {
  int x, y, r, jumpH;
  float v, g, t;
  flapper() {
    x=200;
    y=300;
    r=25;
    v=0;
    g=9.81;
    t=0.2;
    jumpH=40;
  }
  void show() {
    fill(255, 255, 0);
    circle(x, y, r*2);
  }
int getjump(){
  return jumpH;
}
  void move() {
    v += t*g;
    y+= t*v;
    //println(v);
  }
  void incJump() {
    jumpH+=5 ;
  }
  void decJump() {
    jumpH-=5 ;
  }

  void jump() {
    v=-jumpH;
  }
  int getX() {
    return x;
  }
  int getY() {
    return y;
  }
  int getR() {
    return r;
  }
  float getV() {
    return v;
  }
  void dead() {
    y=300;
    v=0;
  }
}
