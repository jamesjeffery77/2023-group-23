import java.util.Collections;

class SnakeControler {
  SnakeObj s;
  SnakeObj opponent;
  DotGenerator dotGenerator;
  float dotSize;
  float minWallDist = sWid / 2;
  float minBodyDist = 1.5 * sWid;
  float minDotDist;
  Dot target = null;

  SnakeControler (SnakeObj s, SnakeObj opponent, DotGenerator dotGenerator) {
    this.s = s;
    this.opponent = opponent;
    this.dotGenerator = dotGenerator;
    this.dotSize = dotGenerator.dotSize;
    this.minDotDist = (sWid + dotSize) / 2;
  }

  void control(){
    ArrayList<Float> wallDists = detectWalls();
    // When the barrier in front is too closed, it must turn.
    float fwl = wallDists.get(0); // Float Wall Left
    float fwf = wallDists.get(1); // Float Wall Front
    float fwr = wallDists.get(2); // Float Wall Right
    if (fwf < minWallDist){
      if (fwl > fwr){
        turnLeft();
      } else {
        turnRight();
      }
      return;
    }

    if (dotGenerator.dotsList.size() == 0) return;
    if (target != null && !dotGenerator.dotsList.contains(target)) target = null;
    float sX = s.head.x;
    float sY = s.head.y;
    ArrayList<Float> dotDists = detectDots();
    ArrayList<Float> sortedDotDists = new ArrayList<Float>(dotDists);
    Collections.sort(sortedDotDists);
    Float f = sortedDotDists.get(0);
    Dot dot = dotGenerator.dotsList.get(dotDists.indexOf(f));

    if (target == null 
      || dist(target.x, target.y, sX, sY) - dist(dot.x, dot.y, sX, sY) >= sWid){
      target = dot;
    }
    boolean bdf = isAtFront(target.x, target.y); // Boolean Dot Front
    boolean bdl = isAtLeft(target.x, target.y);  // Boolean Dot Left
    boolean bdr = isAtRight(target.x, target.y); // Boolean Dot Right
    if (bdf && !bdl && !bdr) return; // Go straight if the dot is in frontward.
    if ((bdl && !bdf && fwl > 1.5 * minBodyDist) // If the dot is at left side and turn left is safe.
      //||(bdl && bdf && (fwl > fwf)) 
      ){ // If the dot is at the left front and the left is safer than front.
      turnLeft();
    } else if ((bdr && !bdf && fwr > 1.5 * minBodyDist) // Same to codes of left.
      //|| (bdr && bdf && (fwr > fwf))
      ){
      turnRight();
    } 
  }



  // Returns the distances to the boundary or to a snake body
  // of the three directions.
  // 'dists.get(0)' is the leftward side;
  // 'dists.get(1)' is the frontward side;
  // 'dists.get(2)' is the rightward side;
  ArrayList<Float> detectWalls(){ 
    ArrayList<Float> dists = new ArrayList<Float>();
    SnakeObj tempSnake;
    Dir d = getLeftDir(s.currentDir);
    float sX = s.head.x;
    float sY = s.head.y;
    for (int i = 0; i < 3; i++){
      tempSnake = new SnakeObj(s);
      tempSnake.turn(d, 1.5);
      while(!tempSnake.headTouchesBoundary()
        && !tempSnake.selfTouched()
        && (opponent == null 
          || !opponent.bodyTouched(tempSnake.head.x, tempSnake.head.y))){
        tempSnake.move();
      }
      if (d == tempSnake.currentDir){
        dists.add(dist(tempSnake.head.x, tempSnake.head.y, sX, sY));
      } else {
        dists.add(0.0);
      }
      d = getRightDir(d);
    }
    return dists;
  }

  // Returns the distances to the boundary or to a snake body
  // of the three directions.
  // 'dists.get(0)' is the leftward side;
  // 'dists.get(1)' is the frontward side;
  // 'dists.get(2)' is the rightward side;
  ArrayList<Float> detectDots(){
    ArrayList<Dot> dotList = dotGenerator.dotsList;
    ArrayList<Float> result = new ArrayList<Float>();
    float sX = s.head.x;
    float sY = s.head.y;
    for (Dot dot : dotList){
      result.add(dist(dot.x, dot.y, sX, sY));
    }
    return result;
  }

  void turnLeft (){
    Dir d = s.currentDir;
    switch (s.currentDir){
      case DirLeft:
        d = Dir.DirDown;
        break;
      case DirRight:
        d = Dir.DirUp;
        break;
      case DirUp:
        d = Dir.DirLeft;
        break;
      case DirDown:
        d = Dir.DirRight;
        break;
    }
    s.turn(d, 1.5);
  }

  void turnRight (){
    Dir d = s.currentDir;
    switch (s.currentDir){
      case DirRight:
        d = Dir.DirDown;
        break;
      case DirLeft:
        d = Dir.DirUp;
        break;
      case DirDown:
        d = Dir.DirLeft;
        break;
      case DirUp:
        d = Dir.DirRight;
        break;
    }
    s.turn(d, 1.5);
  }

  Dir getLeftDir(Dir d){
    switch (d){
      case DirLeft:
        return Dir.DirDown;
      case DirRight:
        return Dir.DirUp;
      case DirUp:
        return Dir.DirLeft;
      case DirDown:
        return Dir.DirRight;
    }
    return Dir.DirErr;
  }

  Dir getRightDir(Dir d){
    switch (d){
      case DirLeft:
        return Dir.DirUp;
      case DirRight:
        return Dir.DirDown;
      case DirUp:
        return Dir.DirRight;
      case DirDown:
        return Dir.DirLeft;
    }
    return Dir.DirErr;
  }

  boolean isAtLeft(float x, float y){
    float sX = s.head.x;
    float sY = s.head.y;
    switch (s.currentDir){
      case DirLeft:
        return sY + minDotDist < y;
      case DirRight:
        return sY - minDotDist > y;
      case DirUp:
        return sX - minDotDist > x;
      case DirDown:
        return sX + minDotDist < x;
    }
    return false;
  }

  boolean isAtRight(float x, float y){
    float sX = s.head.x;
    float sY = s.head.y;
    switch (s.currentDir){
      case DirRight:
        return sY + minDotDist < y;
      case DirLeft:
        return sY - minDotDist > y;
      case DirDown:
        return sX - minDotDist > x;
      case DirUp:
        return sX + minDotDist < x;
    }
    return false;
  }

  boolean isAtFront(float x, float y){
    float sX = s.head.x;
    float sY = s.head.y;
    switch (s.currentDir){
      case DirRight:
        return x > sX;
      case DirLeft:
        return x < sX;
      case DirDown:
        return y > sY;
      case DirUp:
        return y < sY;
    }
    return false;
  }

}
