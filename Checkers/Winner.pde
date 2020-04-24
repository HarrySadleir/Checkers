// the game over screen
class GameOver extends GameState {
  // whether white won (or black)
  boolean white;
  
  // "WHITE" or "BLACK"
  String s;
  
  // colour of text
  color c;
  
  // colour of background
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
 
  // show screen, go to intro screen on mouse click
  void act() {
    background(b);
    
    fill(c);
    textSize(60);
    text(s+" WINS!", 1.8*w, height/2);

    if (mousePressed) {
      gs = new Intro();
      mode = intro;
    }
  }
}