/*
TODO: 

- intro screen
- victory screen
- improve graphic for kinged
- allow pass on double jump i guess?
*/

int w;

int mode = 1;
final int startup = 0;
final int playing = 1;
Game g;

void setup() {
  size(600, 600);
  w = height/8;
  
  background(100);
  
  //if(mode == 0) startupSet();
  if(mode == 1) {
    g = new Game();
  }
}

void draw() {
  //translate(width/2 - 4*w, 0);
  if(mode == 1) g.playing();
}