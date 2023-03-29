class Dot {
  float x;
  float y;

  float size;
  float dotRadius = 10;

  Dot (PVector position){
    this(position.x, position.y);
  }

  Dot (float x, float y){
    this.x = x;
    this.y = y;
    size = sWid * 0.8;
  }

  Dot (PVector position, float size){
    this(position.x, position.y, size);
  }

  Dot (float x, float y, float size){
    this.x = x;
    this.y = y;
    this.size = size;
  }

  void draw(){
    fill(255, 0, 0);
    noStroke();
    ellipse(x, y, size, size);
  }
}
