int w = 75;

int mode = 1;
final int startup = 0;
final int playing = 1;
Game g;

void setup() {
  size(600, 600);
  background(100);
  
  //if(mode == 0) startupSet();
  if(mode == 1) {
    g = new Game();
  }
}

void draw() {
  if(mode == 1) g.playing();
}