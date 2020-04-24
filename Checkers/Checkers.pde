/*
Checkers Instructions:
- Click on a piece to select it, then choose where you want to move it
- You can only click on a piece if it's your turn
- Black Moves First
*/

// scale factor
int w;

// mode framework
int mode = 0;
final int intro = 0;
final int game = 1;
final int winner = 2;
GameState gs;

void setup() {
  // screen setup
  size(600, 600);
  w = height/8;
  background(100);
  
  // instantiate gs
  if(mode == 0) {
    gs = new Intro();
  }
  if(mode == 1) {
    gs = new Game();
  }
  if(mode == 2) {
    gs = new GameOver(true);
  }
}

void draw() {
  gs.act();
}