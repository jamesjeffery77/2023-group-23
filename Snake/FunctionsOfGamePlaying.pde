/***
 * 
 *  The Funtions directly related to play the game.
 * 
 ***/
 
 void newGame(){
  s1 = new SnakeObj(sLen, sWid, s1InitPosition, s1InitD);
  s1.setColour(s1Colour);
  if (twoPlayers){
    s2 = new SnakeObj(sLen, sWid, s2InitPosition, s2InitD);
    s2.setColour(s2Colour);
  }
  dotGenerator = new DotGenerator(dotSpeed);
  switch (timeState){
    case THIRTY_SECONDS:
      gameTimer = new Timer(30);
      break;
    case SIXTY_SECONDS:
      gameTimer = new Timer(60);
      break;
  }
  score1 = 0;
  score2 = 0;
  gameState = GameState.PLAYING;
}


/* PLAYING */
void playingGame(){
  background(255);
  drawTopBar();
  s1.move();
  s1.draw();
  if (twoPlayers) {
    s2.move();
    s2.draw();
  }
  dotGenerator.run();
  dotGenerator.drawDots();
  checkGameOver();
}

void checkGameOver(){
  // Must set gameResult when gameState is set as GameState.GAME_OVER
  // GameState.GAME_OVER is only used when there is only 1 player

  if (timeState != TimeState.UNLIMITED){
    if (gameTimer.timeIsUp){
      gameState = GameState.GAME_OVER;
      if(twoPlayers){
        if(score1 == score2) gameResult = GameResult.DRAW;
        else gameResult = score1 > score2 ? GameResult.P1_WON : GameResult.P2_WON;
      } else {
        gameResult = GameResult.TIME_IS_UP;
      }
      return;
    }
  }
  if (s1.headTouchesBoundary() || s1.selfTouched()){
    gameState = GameState.GAME_OVER;
    gameResult = twoPlayers ? GameResult.P2_WON : GameResult.GAME_OVER;
    return;
  }
  if (twoPlayers){
    if (s2.headTouchesBoundary() || s2.selfTouched()){
      gameState = GameState.GAME_OVER;
      gameResult = GameResult.P1_WON;
      return;
    }
    boolean b1 = s1.bodyTouched(s2.head.x, s2.head.y);
    boolean b2 = s2.bodyTouched(s1.head.x, s1.head.y);
    if (b1 && b2){
      gameState = GameState.GAME_OVER;
      if(score1 == score2) gameResult = GameResult.DRAW;
      else gameResult = score1 > score2 ? GameResult.P1_WON : GameResult.P2_WON;
      return;
    }
    if (b1 || b2){
      gameState = GameState.GAME_OVER;
      gameResult = b1 ? GameResult.P1_WON : GameResult.P2_WON;
      return;
    }
  }
}

void drawTopBar(){ 
  for(int i = 0; i < topBoundary; i ++){
    stroke(230, 230, 255, 200 * i / topBoundary);
    strokeWeight(1);
    line(0, i, width, i);
  }
  pushMatrix();
  translate(width/2, topBoundary/2);
  sTemp3.draw();
  sTemp4.draw();
  if (timeState != TimeState.UNLIMITED){
    textAlign(CENTER, CENTER);
    float textSize = topBoundary/2;
    textSize(textSize);
    fill(250, 0, 0);
    text("" + (gameTime - gameTimer.duration / 1000), 0,  - 0.2 * textSize);
  }

  textAlign(LEFT, CENTER);
  float textSize = topBoundary/3.5;
  textSize(textSize);
  // Following codes can outline the score text.
  // -0.2*textSize is a correction to center alignment.
  fill(0); 
  text("" + score1, -0.45*width - 1,  -0.2*textSize - 1);
  text("" + score1, -0.45*width - 1,  -0.2*textSize + 1);
  text("" + score1, -0.45*width + 1,  -0.2*textSize - 1);
  text("" + score1, -0.45*width + 1,  -0.2*textSize + 1);
  fill(255);
  text("" + score1, -width * 0.45,  - 0.2 * textSize);
  if (twoPlayers) {
      fill(0);
      text("" + score2, 0.45*width - 1,  -0.2*textSize - 1);
      text("" + score2, 0.45*width - 1,  -0.2*textSize + 1);
      text("" + score2, 0.45*width + 1,  -0.2*textSize - 1);
      text("" + score2, 0.45*width + 1,  -0.2*textSize + 1);
      fill(255);
      text("" + score2, width * 0.45,  - 0.2 * textSize);
  }

  popMatrix();
}
