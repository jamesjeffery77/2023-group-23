import java.util.Iterator;

enum Dir{
  DirUp,
  DirDown,
  DirLeft,
  DirRight,
  DirErr,
}

enum GameState {
  START_MENU,
  MODE_SELECTION,
  PAUSED,
  GAME_OVER,
  PLAYING
}

enum TimeState{
  THIRTY_SECONDS,
  SIXTY_SECONDS,
  UNLIMITED,
}

enum GameResult{
  DRAW,
  P1_WON,
  P2_WON,
  TIME_IS_UP,
  GAME_OVER
}


/***
 * 
 *  Global Variables
 * 
 ***/
GameState   gameState   = GameState.START_MENU;
TimeState   timeState;
GameResult  gameResult;
boolean     twoPlayers  = false;
Timer       gameTimer;
int         gameTime;

/***
 * 
 *  Game datas
 * 
 ***/
ArrayList<Timer> timerList    = new ArrayList<Timer>();
DotGenerator    dotGenerator;
float           dotSpeed      = 3;
int             score1        = 0;
int             score2        = 0;

/***
 * 
 *  Gameboard Bondary Parametres
 *  
 ***/
float leftBoundary;
float rightBoundary;
float topBoundary;
float bottomBoundary;

/***
 * 
 *  Buttons
 *    
 ***/
 /* Start Menu */
Button      onePlayerButton;
Button      twoPlayerButton;

/* Mode Selection */
Button      thirtySecondsButton;
Button      sixtySecondsButton;
Button      unlimitedTimeButton;
Button      backButton;

/* Pause */
Button      continueButton;
Button      quitButton;

/* End */
Button      playAgainButton;
Button      homeButton;

/***
 * 
 *  Snakes
 *
 *  Following parameters can be used to reset the snakes
 * 
 ***/
 
/* General Parameters */
// Its an initial length. The actual length may be changed during the game.
float       sLen          = 20; 
float       sWid          = 20;
float       growthLength  = 20;

/* Snake1 */
SnakeObj    s1;
PVector     s1InitPosition  = new PVector(100, 150);
Dir         s1InitD         = Dir.DirRight;
PVector     s1Colour        = new PVector(230, 220, 220);

/* Snake2 */
SnakeObj    s2;
PVector     s2InitPosition  = new PVector(600, 750);
Dir         s2InitD         = Dir.DirLeft;
PVector     s2Colour        = new PVector(220, 220, 230);

/* Temp Snakes */
//Used to decoration
SnakeObj sTemp1;
SnakeObj sTemp2;
SnakeObj sTemp3;
SnakeObj sTemp4;



void setup() {
  size(700, 800);

  leftBoundary = 0;
  rightBoundary = width;
  topBoundary = 100;
  bottomBoundary = height;
  
  /* Buttons */
  onePlayerButton = new Button(width / 2, height / 2, width / 2, height / 6, "One Player");
  twoPlayerButton = new Button(width / 2, height * 3 / 4, width / 2, height / 6, "Two Players");

  thirtySecondsButton = new Button(width / 2, height * 3.5 / 8, width / 2, height / 9.5, "30 Seconds");
  sixtySecondsButton = new Button(width / 2, height * 4.5 / 8, width / 2, height / 9.5, "60 Seconds");
  unlimitedTimeButton = new Button(width / 2, height * 5.5 / 8, width / 2, height / 9.5, "Unlimited Time");
  unlimitedTimeButton.textSize = unlimitedTimeButton.w / 7;
  backButton = new Button(width / 2, height * 6.5 / 8, width / 2, height / 9.5, "Back");

  continueButton = new Button(width / 2, height * 0.9 / 2, width / 3, height / 15, "Continue");
  quitButton = new Button(width / 2, height * 1.1 / 2, width / 3, height / 15, "Quit");

  playAgainButton = new Button(width / 2, height * 0.9 / 2, width / 3, height / 15, "Play Again");
  homeButton = new Button(width / 2, height * 1.1 / 2, width / 3, height / 15, "Home");
  
  /* Snake objects for the title */
  sTemp1 = new SnakeObj(width, height/25, -width/10, 0, Dir.DirRight);
  sTemp1.setColour(s1Colour);
  sTemp2 = new SnakeObj(width, height/25, width/10, height/9, Dir.DirLeft);
  sTemp2.setColour(s2Colour);

  /* Snake objects for the top bar */
  sTemp3 = new SnakeObj(width, topBoundary/3, -width/10, 0, Dir.DirRight);
  sTemp3.setColour(s1Colour);
  sTemp4 = new SnakeObj(width, topBoundary/3, width/10, 0, Dir.DirLeft);
  sTemp4.setColour(s2Colour);



}

void draw() {
  refreshTimers();
  switch (gameState){
    case START_MENU:
      displayStartMenu();
      break;
    case MODE_SELECTION:
      displayModeSelection();
      break;
    case GAME_OVER:
      displayGameOverScreen();
      break;
    case PAUSED:
      displayPauseScreen();
      break;
    case PLAYING:
      playingGame();
  }
}

/***
 * 
 *  Functions of Interaction
 * 
 ***/
void mousePressed() {
  switch (gameState){
    case START_MENU:
      mousePressedOfStartMenu();
      break;
    case MODE_SELECTION:
      mousePressedOfModeSelection();
      break;
    case GAME_OVER:
      mousePressedOfGameOver();
      break;
    case PAUSED:
      if (continueButton.isMouseOver()) {
        gameState = GameState.PLAYING;
      } else if (quitButton.isMouseOver()) {
        gameState = GameState.START_MENU;
      }
  }
}

void keyPressed(){
  if (gameState == GameState.PLAYING){
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
    if (gameState == GameState.PLAYING){
      gameState = GameState.PAUSED;
    } else if (gameState == GameState.PAUSED){
      gameState = GameState.PLAYING;
    }
  }
}


/***
 * 
 *  Helper Functions
 * 
 ***/
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

void refreshTimers(){
  Iterator<Timer> iter = timerList.iterator();
  while (iter.hasNext()) {
    Timer timer = (Timer) iter.next();
    timer.refresh();
    if (timer.canBeDeleted) {
      iter.remove();
    }
  }
}


