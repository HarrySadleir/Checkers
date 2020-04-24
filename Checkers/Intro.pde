public class Intro extends GameState{
  
  // nothing apparently necessary
  Intro() {}
  
  // show intro screen and check for click on new game
  void act() {
    background(100);
    textSize(80);
    text("CHECKERS", width/2-2.65*w, height/2-w);

    textSize(45);
    text("NEW GAME", width/2-1.6*w, height/2+w);

    if (mousePressed && mouseX > 2.5*w && mouseX < 5.5*w 
      && mouseY > 4.6*w && mouseY < 5.1*w) {
      gs = new Game();
      mode = game;
    }
  }
}