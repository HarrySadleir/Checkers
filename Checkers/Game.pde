class Game {
  private ArrayList<Piece> white;
  private ArrayList<Piece> black;
  private boolean blackTurn;
  private int phase;
  private final int select = 0;
  private final int valDests = 1;
  private final int destSel = 2;

  private Piece selected;

  Game() {
    setBoard();
    blackTurn = true;
    phase = select;
  }

  public void playing() {
    showAll(); 

    if (phase == select || phase == valDests) {
      if (blackTurn) selectPiece(black); 
      else selectPiece(white);
    }

    if (phase == valDests) {
      ArrayList<PVector> dests = genValDests();

      for (PVector p : dests) {
        strokeWeight(4);
        fill(255, 255, 0);
        rect(p.x*w, p.y*w, w, w);
      }
    }
  }

  private void showAll() {
    stroke(0);
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if ((i+j)%2 == 1) fill(255);
        else fill(0);
        rect(w*i, w*j, w, w);
      }
    }

    for (Piece p : white) p.show();
    for (Piece p : black) p.show();

    if (selected != null) {
      stroke(255, 255, 0);
      noFill();
      ellipse(selected.getX(), selected.getY(), selected.getD()*1.1, selected.getD()*1.1);
    }
  }

  private void selectPiece(ArrayList<Piece> pieces) {
    if (mousePressed) {
      for (Piece p : pieces) {
        if (dist(mouseX, mouseY, p.getX(), p.getY()) < p.getD()/2) selected = p;
      }
      
      if(selected != null) phase = valDests;
    }
  }

  private ArrayList<PVector> genValDests() {
    int x = selected.getGX();
    int y = selected.getGY();
    PVector c = null;
    ArrayList<PVector> result = new ArrayList<PVector>();


    c = check(1, -1);
    if (c != null) result.add(c);

    c = check(-1, -1);
    if (c != null) result.add(c);

    println(result);
    return result;
  }

  private PVector check(int x, int y) {
    int x_ = selected.getGX();
    int y_ = selected.getGY();
    boolean white = selected.getWhite();

    if (occupied(x_+x, y_+y) != null) {
      if (occupied(x_+2*x, y_+2*y) == null && occupied(x+x_, y+y_).getWhite() != white)
        return new PVector(x_+2*x, y_+2*y);
      else return null;
    } else return new PVector(x_+x, y_+y);
  }

  private Piece occupied(int x, int y) {
    Piece result = null;
     
    if (x < 8 && x >= 0 && y < 8 && y >= 0) {
      for (Piece p : white) {
        if (p.getGX() == x && p.getGY() == y) result = p;
      }
      for (Piece p : black) {
        if (p.getGX() == x && p.getGY() == y) result = p;
      }
    }
    return result;
  }

  private void setBoard() {
    white = new ArrayList<Piece>();
    black = new ArrayList<Piece>();
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if      (j == 0 && (i%2) == 1) white.add(new Piece(i, j, true));
        else if (j == 1 && (i%2) == 0) white.add(new Piece(i, j, true));
        else if (j == 2 && (i%2) == 1) white.add(new Piece(i, j, true));
        else if (j == 5 && (i%2) == 0) black.add(new Piece(i, j, false));
        else if (j == 6 && (i%2) == 1) black.add(new Piece(i, j, false));
        else if (j == 7 && (i%2) == 0) black.add(new Piece(i, j, false));
      }
    }
    
    white.add(new Piece(3, 4, true));
  }
}