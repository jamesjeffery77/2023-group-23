class DotGenerator {
  ArrayList<Dot> dotsList = new ArrayList<Dot>();

  float dotSpeed = 5;
  long gameTime;
  Timer timer;
  float dotSize = sWid * 0.8;

  DotGenerator (float speed){
    this.dotSpeed = speed;
    timer = new Timer(speed);
    generateDot();
  }

  void run(){
    // If time is up, generate a dot, and then reset the timer.
    if (timer.timeIsUp) {
      generateDot();
      timer.reset();
    }
    checkDotsTouching();
    drawDots();
  }

  void generateDot(){
    Dot dot;
    do{
      float dotX = random(leftBoundary + sWid, rightBoundary - sWid);
      float dotY = random(topBoundary + sWid, bottomBoundary - sWid);
      dot = new Dot(dotX, dotY, dotSize);
    } while (s1.headTouchesDot(dot) || s2.headTouchesDot(dot));
    dotsList.add(dot);
  }

  void checkDotsTouching(){
    Iterator<Dot> iter = dotsList.iterator();
    while (iter.hasNext()) {
      Dot dot = (Dot) iter.next();
      if (s1.headTouchesDot(dot)) {
        s1.grow(growthLength);
        score1 ++;
        iter.remove();
      } else if (s2.headTouchesDot(dot)){
        s2.grow(growthLength);
        score2 ++;
        iter.remove();
      }
    }
  }

  void drawDots(){
    for (Dot dot : dotsList){
      dot.draw();
    }
  }
}
