class SnakeObj {

  ArrayList<SnakeVertex> vertexList = new ArrayList<SnakeVertex>();
  Dir currentDir;
  float speed = 2;
  SnakeVertex head, tail;
  float len = 0;
  float wid;
  float r = 0;
  float g = 0;
  float b = 0;

  SnakeObj (float len, float wid) {
    head = new SnakeVertex(0, 0);
    currentDir = Dir.DirRight;
    tail = new SnakeVertex(-len, 0, currentDir, currentDir);
    this.len = len;
    this.wid = wid;
  }

  SnakeObj (float len, float wid, float startX, float startY) {
    head = new SnakeVertex(startX, startY);
    currentDir = Dir.DirRight;
    tail = new SnakeVertex(startX-len, startY, currentDir, currentDir);
    this.len = len;
    this.wid = wid;
  }

  SnakeObj (float len, float wid, float startX, float startY, Dir startD) {
    head = new SnakeVertex(startX, startY);
    currentDir = startD;
    float tailX = startX;
    float tailY = startY;
    switch (startD){
      case DirUp :
        tailY += len;
        break;
      case DirDown :
        tailY -= len;
        break;
      case DirLeft :
        tailX += len;
        break;
      case DirRight :
        tailX -= len;
        break; 
    }
    tail = new SnakeVertex(tailX, tailY, currentDir, currentDir);
    this.len = len;
    this.wid = wid;
  }

  SnakeObj (float len, float wid, PVector position, Dir startD){
    this(len, wid, position.x, position.y, startD);
  }

  SnakeObj (SnakeObj s){
    this.vertexList = new ArrayList<SnakeVertex>(s.vertexList);
    this.currentDir = s.currentDir;
    this.speed = s.speed;
    this.head = new SnakeVertex(s.head.x, s.head.y, s.head.from, s.head.to);
    this.tail = new SnakeVertex(s.tail.x, s.tail.y, s.tail.to);
    this.len = s.len;
    this.wid = s.wid;
    this.r = s.r;
    this.g = s.g;
    this.b = s.b;
  }

  void move (){
    moveVertex(head, currentDir, speed);

    if (vertexList.isEmpty()){
      moveVertex(tail, currentDir, speed);
      return;
    }

    float diff;
    float dist = speed;
    while ((diff = calcDist(tail, vertexList.get(0))) <= dist) {
      dist -= diff;
      SnakeVertex v = vertexList.get(0);
      tail = new SnakeVertex(v.x, v.y, v.to);
      vertexList.remove(0);
      if (vertexList.isEmpty()){
        moveVertex(tail, tail.to, dist);
        return;
      }
    }
    moveVertex(tail, tail.to, dist);
  }

  void moveVertex(SnakeVertex v, Dir d, float l){
    switch (d){
      case DirUp :
        v.y -= l;
        break;
      case DirDown :
        v.y += l;
        break;
      case DirLeft :
        v.x -= l;
        break;
      case DirRight :
        v.x += l;
        break;
    }
  }
  
  void turn (Dir d){
    if (currentDir == d || getOppo(currentDir) == d){
      return;
    }
    SnakeVertex v = new SnakeVertex(head.x, head.y, currentDir, d);
    if (vertexList.size() > 0 
      && calcDist(v, vertexList.get(vertexList.size() - 1)) < wid * 1.1){
      return;
    }
    vertexList.add(v);
    currentDir = d;
  }

  void turn (Dir d, float num){
    if (currentDir == d || getOppo(currentDir) == d){
      return;
    }
    SnakeVertex v = new SnakeVertex(head.x, head.y, currentDir, d);
    if (vertexList.size() > 0 
      && calcDist(v, vertexList.get(vertexList.size() - 1)) < wid * num){
      return;
    }
    vertexList.add(v);
    currentDir = d;
  }

  void grow (float len){
    this.len += len;
    moveVertex(tail, getOppo(tail.to), len);
  }

  boolean headTouchesDot(float x, float y, float d) {
    float distance = dist(head.x, head.y, x, y);
    return distance <= (wid + d) / 2;
  }

  boolean headTouchesDot(Dot dot) {
    return headTouchesDot(dot.x, dot.y, dot.size);
  }

  boolean headTouchesBoundary() {
    return 
      !((head.x >= leftBoundary + wid/2 && head.x <= rightBoundary - wid/2)
      && (head.y >= topBoundary + wid/2 && head.y <= bottomBoundary - wid/2));
  }

  // Judge whether its body is touched by a point at (x, y)
  boolean bodyTouched(float x, float y){
    SnakeVertex v1 = tail;
    for (SnakeVertex v : vertexList){
      if (distPointToBody(x, y, v1, v) < wid){
        return true;
      }
      v1 = v;
    }
    return distPointToBody(x, y, v1, head) < wid;
  }

  // Judge whether its body touched by its head.
  boolean selfTouched(){
    if (vertexList.size() < 3){
      return false;
    }
    float x = head.x;
    float y = head.y;
    SnakeVertex v1 = tail;
    for (int i = 0; i < vertexList.size() - 2; i++){
      SnakeVertex v = vertexList.get(i);
      if (distPointToBody(x, y, v1, v) < wid/2){
        return true;
      }
      v1 = v;
    }
    return false;
  }

  // Calculate the distance between two vertices.
  float calcDist(SnakeVertex a, SnakeVertex b){
    return dist(a.x, a.y, b.x, b.y);
  }

  // Calculate the distance between a point and a line connected by two vertices,
  // where the two vertices must be horizontal or vertical.
  float distPointToBody(float x, float y, SnakeVertex vertexA, SnakeVertex vertexB){
    float x1 = vertexA.x >= vertexB.x ? vertexA.x : vertexB.x;
    float x2 = vertexA.x <  vertexB.x ? vertexA.x : vertexB.x;
    float y1 = vertexA.y >= vertexB.y ? vertexA.y : vertexB.y;
    float y2 = vertexA.y <  vertexB.y ? vertexA.y : vertexB.y;
    if (y1 == y2){
      if (x <= x1 && x >= x2){
        return abs(y - y1);
      }
      if (x > x1) return dist(x, y, x1, y1);
      if (x < x2) return dist(x, y, x2, y2);
    }
    if (x1 == x2){
      if (y <= y1 && y >= y2){
        return abs(x - x1);
      }
      if (y > y1) return dist(x, y, x1, y1);
      if (y < y2) return dist(x, y, x2, y2);
    }
    return -1;
  }




  /***
   * 
   *  Following are the functions to draw a snake.
   * 
   ***/

  void setColour(float r, float g, float b){
    this.r = r;
    this.g = g;
    this.b = b;
  }

  void setColour(PVector v){
    this.setColour(v.x, v.y, v.z);
  }

  void draw (){
    float tempLen = 0;
    pushMatrix();
    //strokeCap(SQUARE);
    smooth();
    noFill();
    stroke(r, g, b);
    strokeWeight(wid);
    beginShape();
    vertex(head.x, head.y);
    for (int i = vertexList.size() - 1; i >= 0; i--){
      SnakeVertex v = vertexList.get(i);
      drawRoundCorner(v, wid/2);
    }
    vertex(tail.x, tail.y);
    endShape();
    
    drawHead();
    drawTail();
    popMatrix();
  }

  void drawRoundCorner(SnakeVertex v, float size){
    float x = v.x;
    float y = v.y;

    float xBiasF = 0;
    float yBiasF = 0;
    float xBiasT = 0;
    float yBiasT = 0;

    switch (v.from){
      case DirUp :
        yBiasF += size;
        break;
      case DirDown :
        yBiasF -= size;
        break;
      case DirLeft :
        xBiasF += size;
        break;
      case DirRight :
        xBiasF -= size;
        break;
    }
    switch (v.to){
      case DirUp :
        yBiasT -= size;
        break;
      case DirDown :
        yBiasT += size;
        break;
      case DirLeft :
        xBiasT -= size;
        break;
      case DirRight :
        xBiasT += size;
        break;
    }

    vertex(x + xBiasT, y + yBiasT);
    bezierVertex(
      x, y,
      x, y,
      x + xBiasF, y + yBiasF);
    vertex(x + xBiasF, y + yBiasF);

  }

  void drawHead(){
    pushMatrix();
    translate(head.x, head.y);
    switch (currentDir){
      case DirUp :
        rotate(-PI/2);
        break;
      case DirDown :
        rotate(PI/2);
        break;
      case DirLeft :
        rotate(-PI);
        break;
      case DirRight :
        break;
    }
    smooth();
    fill(r, g, b);
    noStroke();
    beginShape();
    //vertex(wid, 0);
    
    vertex(-wid, 0);
    bezierVertex(-wid, wid, 0, wid, wid, 0);
    vertex(wid, 0);
    bezierVertex(0, -wid, -wid, -wid, -wid, 0);
    endShape();
    fill(0);
    ellipse(0, -wid/4, wid/4, wid/4);
    ellipse(0, wid/4, wid/4, wid/4);
    popMatrix();
  }

  void drawTail(){
    pushMatrix();
    translate(tail.x, tail.y);
    switch (tail.to){
      case DirUp :
        rotate(-PI/2);
        break;
      case DirDown :
        rotate(PI/2);
        break;
      case DirLeft :
        rotate(-PI);
        break;
      case DirRight :
        break;
    }
    smooth();
    fill(r, g, b);
    noStroke();
    beginShape();
    vertex(0, -wid/2);
    bezierVertex(-wid/2, -wid/2, -wid*3/4, -wid/2, -wid, 0);
    bezierVertex(-wid*3/4, wid/2, -wid/2, wid/2, 0, wid/2);
    vertex(0, wid/2);
    vertex(0, -wid/2);
    endShape();
    popMatrix();
  }

}
