/***
 * 
 *  The Funtions in diffrent game states.
 * 
 ***/

/* START_MENU */
void displayStartMenu(){
  background(255);
  drawStartMenuBackground();
  drawTitle(width/2, 100);
  onePlayerButton.display();
  twoPlayerButton.display();
}

void mousePressedOfStartMenu(){
  if (onePlayerButton.isMouseOver()) {
    gameState = GameState.MODE_SELECTION;
    twoPlayers = false;
  } else if (twoPlayerButton.isMouseOver()) {
    gameState = GameState.MODE_SELECTION;
    twoPlayers = true;
  }
}

void drawTitle(float x, float y){

  // TODO: Add a more beautiful title
  pushMatrix();
  translate(x, y);
  sTemp1.draw();
  sTemp2.draw();

  pushMatrix();
  translate(0, width/8);
  scale(1.2, 0.3);
  textAlign(CENTER, BOTTOM);
  textSize(width/5);
  fill(220);
  text("S N A K E S", 0, -5);
  popMatrix();
  
  pushMatrix();
  translate(0, width/6);
  scale(1.2, 1);
  textAlign(CENTER, BOTTOM);
  textSize(width/5);
  fill(155, 150, 145);
  text("S N A K E S", 0, -5);
  fill(205, 200, 195);
  text("S N A K E S", 0, 0);
  fill(255, 250, 245);
  text("S N A K E S", 0, 5);
  popMatrix();

  sTemp2.draw();
  popMatrix();

}

void drawStartMenuBackground(){
  for(int i = 0; i < height; i ++){
    stroke(230, 230, 255, 255 * i / height);
    strokeWeight(1);
    line(0, i, width, i);
  }
}


/* MODE_SELECTION */
void displayModeSelection(){
  background(255);
  drawStartMenuBackground();
  drawTitle(width/2, 100);
  thirtySecondsButton.display();
  sixtySecondsButton.display();
  unlimitedTimeButton.display();
  backButton.display();
}

void mousePressedOfModeSelection(){
  if (backButton.isMouseOver()) {
    gameState = GameState.START_MENU;
    return;
  } else if (thirtySecondsButton.isMouseOver()) {
    timeState = TimeState.THIRTY_SECONDS;
    gameTime = 30;
  } else if (sixtySecondsButton.isMouseOver()) {
    timeState = TimeState.SIXTY_SECONDS;
    gameTime = 60;
  } else if (unlimitedTimeButton.isMouseOver()) {
    timeState = TimeState.UNLIMITED;
  }
  gameState = GameState.PLAYING;
  newGame();
}

/* GAME_OVER */
void displayGameOverScreen() {
  background(200, 200, 255);
  String str1 = "";
  String str2 = "";
  switch(gameResult){
    case TIME_IS_UP:
      str1 = "Time's Up";
      str2 = "Your score: " + score1;
      break;
    case GAME_OVER:
      str1 = "Game Over";
      str2 = "Your score: " + score1;
      break;
    case P1_WON:
      str1 = "Red Wins";
      str2 = "Red: " + score1 + "  Blue: " + score2;
      break;
    case P2_WON:
      str1 = "Blue Wins";
      str2 = "Red: " + score1 + "  Blue: " + score2;
      break;
    case DRAW:
      str1 = "Draw game";
      str2 = "Red: " + score1 + "  Blue: " + score2;
  }
  pushMatrix();
    translate(width/2, height/4);
    textAlign(CENTER, CENTER);
    textSize(height/8);
    fill(0);
    text(str1, -1, -height/20 - 1);
    text(str1, 1, -height/20 - 1);
    text(str1, -1, -height/20 + 1);
    text(str1, 1, -height/20 + 1);
    fill(255);
    text(str1, 0, -height/20);
    fill(255);
    textSize(height/15);
    text(str2, 0, height/20);
  popMatrix();

  playAgainButton.display();
  homeButton.display();
}

void mousePressedOfGameOver(){
  if (playAgainButton.isMouseOver()) {
    newGame();
  }
  if (homeButton.isMouseOver()) {
    gameState = GameState.START_MENU;
  }
}

/* PAUSED */
void displayPauseScreen(){
  background(255);
  drawTopBar();
  s1.draw();
  s2.draw();
  dotGenerator.drawDots();
  rectMode(CORNER);
  fill(0, 0, 0, 80);
  rect(0, 0, width, height);
  continueButton.display();
  quitButton.display();
}
