/*
TODO: 

- make abstract GameState class
- improve graphic for kinged
- allow pass on double jump i guess?
*/

int w;

int mode = 2;
final int startup = 0;
final int playing = 1;
final int gameOver = 2;
Game g;
Intro i;
GameOver gO;

void setup() {
  size(600, 600);
  w = height/8;
  
  background(100);
  
  
  if(mode == 0) {
    i = new Intro();
  }
  if(mode == 1) {
    g = new Game();
  }
  if(mode == 2) {
    gO = new GameOver(true);
  }
}

void draw() {
  //translate(width/2 - 4*w, 0);
  if(mode == startup) i.show();
  if(mode == playing) g.playing();
  if(mode == gameOver) gO.show();
}