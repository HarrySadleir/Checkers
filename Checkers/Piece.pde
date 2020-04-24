// a checkers piece
class Piece {
  
  // coordinates on the board
  private int x;
  private int y;
  
  // diamater on the board
  private float d;
  
  // whether it's been kinged or not
  private boolean king;
  
  // whether it's white (or black)
  private boolean white;
  
  // make non-king piece at x, y of colour according to white variable
  Piece(int x, int y, boolean white) {
    king = false;
    this.x = x;
    this.y = y;
    d = .8;
    this.white = white;
  }

  // RESTRICTION: destination must be valid
  public void move(int x, int y) {
    this.x += x;
    this.y += y;
  }
  
  // draw as an ellipse of appropriate colour, with grey center if kinged
  public void show() {
    if (white) fill(255);
    else fill(0);
    stroke(0);
    strokeWeight(4);
    ellipse(getX(), getY(), w*d, w*d);
    
    if(king) {
      fill(120);
      strokeWeight(0);
      ellipse(getX(), getY(), w*.6*d, w*.6*d);
    }
  }
  
  // get x on the screen
  public float getX() {
    return (x+.5)*w;
  }
  
  // get x on the board
  public int getGX() {
    return x;
  }
  
  // get y on the screen
  public float getY() {
    return (y+.5)*w;
  }
  
  // get y on the board
  public int getGY() {
    return y;
  }
  
  // get piece's colour 
  public boolean getWhite() {
    return white;
  }
  
  // get piece's diamter
  public float getD() {
    return w*d;
  }
  
  // turn piece into a king
  public void kingMe() {
    king = true;
  }
  
  // checks if piece is a king
  public boolean getKing() {
    return king;
  }
}