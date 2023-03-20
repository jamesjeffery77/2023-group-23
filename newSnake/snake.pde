enum Dir{
    DirUp,
    DirDown,
    DirLeft,
    DirRight,
    DirErr,
}

Button onePlayerButton;
Button twoPlayerButton;
Button continueButton;
Button quitButton;
Button playAgainButton;
Button homeButton;
Button easyModeButton;
Button hardModeButton;
boolean hardMode = false;

SnakeObj s1;
SnakeObj s2;
boolean pause = false;

//dots
int score = 0;
int lastScore;
int timer = 30;
int dotTimer = 5;
float dotSize;
PVector dotPosition;
boolean dotActive = false;
long dotTimestamp;
float dotSpeed = 5;
float dotRadius = 10;
float dotX, dotY;
float dotVX = dotSpeed;
float dotVY = dotSpeed;

long gameTimestamp;

void setup() {
    size(500, 500);
    
    onePlayerButton = new Button(width / 2 - 100, height / 2 - 50, 200, 40, "One Player");
    twoPlayerButton = new Button(width / 2 - 100, height / 2 + 10, 200, 40, "Two Player");
    continueButton = new Button(width / 2 - 100, height / 2 - 50, 200, 40, "Continue");
    quitButton = new Button(width / 2 - 100, height / 2 + 10, 200, 40, "Quit");
    playAgainButton = new Button(width / 2 - 100, height * 2 / 3, 200, 50, "Play Again");
    homeButton = new Button(width / 2 - 100, height * 3 / 4, 200, 50, "Home");
    easyModeButton = new Button(width / 2 - 100, height / 2 + 70, 200, 40, "Easy Mode");
    hardModeButton = new Button(width / 2 - 100, height / 2 + 130, 200, 40, "Hard Mode");
  
    s1 = new SnakeObj(300, 20, 100, 100, Dir.DirRight);
    s1.setColour(230, 220, 220);
    s2 = new SnakeObj(300, 20, 300, 300, Dir.DirLeft);
    s2.setColour(220, 220, 230);
    
    dotSize = s1.wid * 0.8;
    dotPosition = new PVector();

    gameTimestamp = millis();
}

void draw() {
  if (gameState == GameState.START_MENU) {
    background(200, 200, 255);
    onePlayerButton.display();
    twoPlayerButton.display();
    easyModeButton.display();
    hardModeButton.display();
  } 
  else if (gameState == GameState.GAME_OVER) {
    displayGameOverScreen();
  }
  else {
    if (!pause) {
      background(255);

      if (gameState == GameState.ONE_PLAYER) {
        // Decrease timer by 1 every second
        if (millis() - gameTimestamp >= 1000 && timer > 0) {
          timer--;
          gameTimestamp = millis();
        }
        // Activate the dot after 5 seconds
        if (!dotActive && millis() - dotTimestamp >= 5000) {
          dotPosition.x = random(dotSize / 2, width - dotSize / 2);
          dotPosition.y = random(dotSize / 2, height - dotSize / 2);
          dotActive = true;
          dotTimestamp = millis();
        }
        if (dotActive) {
          fill(255, 0, 0);
          noStroke();
          ellipse(dotPosition.x, dotPosition.y, dotSize, dotSize);
      
          if (s1.headTouchesDot(dotPosition.x, dotPosition.y, dotSize)) {
            score++;
            dotActive = false;
          }      
          // Deactivate the dot after 5 seconds
          if (millis() - dotTimestamp >= 5000) {
            dotActive = false;
          }
        }
        // Game over when timer reaches 0
        if (timer <= 0) {
          lastScore = score;
          gameState = GameState.GAME_OVER;
          timer = 30;
          score = 0;
        }
      }
      s1.move();
      s1.draw();
      if (gameState == GameState.TWO_PLAYER) {
        s2.move();
        s2.draw();
      }
      
      // Display score and timer in the corners
      fill(0);
      textSize(20);
      textAlign(LEFT, TOP);
      text("Score: " + score, 10, 10);
      textAlign(RIGHT, TOP);
      text("Time: " + timer, width - 10, 10);
    } 
    else {
      // Display pause screen
      fill(0, 0, 0, 100);
      rect(0, 0, width, height);
      continueButton.display();
      quitButton.display();
    }
  }
}


void mousePressed() {
  if (gameState == GameState.START_MENU) {
    if (onePlayerButton.isMouseOver()) {
      gameState = GameState.MODE_SELECTION;
    } else if (twoPlayerButton.isMouseOver()) {
      gameState = GameState.TWO_PLAYER;
    } else if (easyModeButton.isMouseOver()) {
      gameState = GameState.ONE_PLAYER;
      hardMode = false;
    } else if (hardModeButton.isMouseOver()) {
      gameState = GameState.ONE_PLAYER;
      hardMode = true;
      dotX = random(dotRadius, width - dotRadius);
      dotY = random(dotRadius, height - dotRadius);
    }
  } 
  else if (gameState == GameState.GAME_OVER) {
    if (playAgainButton.isMouseOver()) {
      gameState = GameState.ONE_PLAYER;
      score = 0;
      timer = 30;
    }
    if (homeButton.isMouseOver()) {
      gameState = GameState.START_MENU;
      score = 0;
      timer = 30;
    }
  } else if (pause) {
    if (continueButton.isMouseOver()) {
      pause = !pause;
    } else if (quitButton.isMouseOver()) {
      gameState = GameState.START_MENU;
      pause = !pause;
    }
  }
}



Dir getOppo (Dir d){
    switch (d) {
        case DirUp :
            return Dir.DirDown;
        case DirDown :
            return Dir.DirUp;
        case DirLeft :
            return Dir.DirRight;
        case DirRight :
            return Dir.DirLeft;
        default :
            return Dir.DirErr;
    }
}

void keyPressed(){
    if (!pause){
        switch (keyCode){
            case LEFT:
                s1.turn(Dir.DirLeft);
                break;
            case RIGHT:
                s1.turn(Dir.DirRight);
                break;
            case UP:
                s1.turn(Dir.DirUp);
                break;
            case DOWN:
                s1.turn(Dir.DirDown);
                break;
        }
        switch (key){
            case 'A':
            case 'a':
                s2.turn(Dir.DirLeft);
                break;
            case 'D':
            case 'd':
                s2.turn(Dir.DirRight);
                break;
            case 'W':
            case 'w':
                s2.turn(Dir.DirUp);
                break;
            case 'S':
            case 's':
                s2.turn(Dir.DirDown);
                break;
        }
    }
    
    if (key == ' '){
        pause = !pause;
    }
}

void displayGameOverScreen() {
  background(200, 200, 255);
  textAlign(CENTER, CENTER);
  textSize(32);
  fill(0);
  text("Game Over", width / 2, height / 3);
  text("Your score: " + lastScore, width / 2, height / 2);

  playAgainButton.display();
  homeButton.display();
}
