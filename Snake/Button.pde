class Button {
  float x, y, w, h;
  String label;
  float textSize;

  Button(float x, float y, float w, float h, String label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
    this.textSize = w / 6;
  }

  Button(float x, float y, String label) {
    this.x = x;
    this.y = y;
    this.w = width/2;
    this.h = height/6;
    this.label = label;
  }

  boolean isMouseOver() {
    return mouseX >= x - w/2 && mouseX <= x + w/2 && mouseY >= y - h/2  && mouseY <= y + h/2;
  }

  void display() {
    strokeJoin(ROUND);
    strokeWeight(5);
    stroke(0, 0, 0, 100);
    if (isMouseOver()) {
      fill(230, 230, 230);
    } else {
      fill(250, 250, 250);
    }
    rectMode(CENTER);
    rect(x, y, w, h);
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(textSize);
    text(label, x, y - 0.2 * textSize); // -0.2*textSize is a correction to center alignment.
  }
}
