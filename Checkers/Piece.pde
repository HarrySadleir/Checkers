class Piece {
  private int x;
  private int y;
  private float d;
  private boolean king;
  private boolean white;

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

  public void show() {
    if (white) fill(255);
    else fill(0);
    stroke(0);
    strokeWeight(4);
    ellipse((x+.5)*w, (y+.5)*w, w*d, w*d);
  }
  
  public float getX() {
    return (x+.5)*w;
  }
  
  public int getGX() {
    return x;
  }
  
  public float getY() {
    return (y+.5)*w;
  }
  
  public int getGY() {
    return y;
  }
  
  public boolean getWhite() {
    return white;
  }
  
  public float getD() {
    return w*d;
  }
}