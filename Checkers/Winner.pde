class GameOver {
  boolean white;
  String s;
  color c;
  color b;
  GameOver(boolean white) {
    this.white = white;

    if (white) {
      s = "WHITE";
      b = color(255);
      c = color(0);
    } else {
      s = "BLACK";
      b = color(0);
      c = color(255);
    }
  }

  void show() {
    background(b);
    
    fill(c);
    textSize(60);
    text(s+" WINS!", 2*w, height/2);

    if (mousePressed) {
      i = new Intro();
      mode = startup;
    }
  }
}