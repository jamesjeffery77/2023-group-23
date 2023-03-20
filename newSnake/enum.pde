enum GameState {
  START_MENU,
  ONE_PLAYER,
  TWO_PLAYER,
  MODE_SELECTION,
  PAUSED,
  GAME_OVER
}


GameState gameState = GameState.START_MENU;

class Button {
  float x, y, w, h;
  String label;

  Button(float x, float y, float w, float h, String label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
  }

  boolean isMouseOver() {
    return mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h;
  }

  void display() {
    if (isMouseOver()) {
      fill(180);
    } else {
      fill(200);
    }
    rect(x, y, w, h);
    fill(0);
    textAlign(CENTER, CENTER);
    text(label, x + w / 2, y + h / 2);
  }
}
