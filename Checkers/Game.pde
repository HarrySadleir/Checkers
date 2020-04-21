class Game {
  private ArrayList<Piece> white;
  private ArrayList<Piece> black;
  private boolean blackTurn;
  private int phase;
  private final int select = 0;
  private final int valDests = 1;
  private final int doubleJump = 2;

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

    if (phase == valDests || phase == doubleJump) {
      ArrayList<PVector> dests = genValDests();

      if (phase == doubleJump) {
        for (int i = dests.size()-1; i>=0; i--) {
          if (abs(dests.get(i).x-selected.getGX()) != 2) {
            dests.remove(i);
          }
        }
      }

      if (dests.size() == 0 && mode == doubleJump) {
        phase = select;
        selected = null;
        blackTurn = !blackTurn;
      } else {

        for (PVector p : dests) {
          strokeWeight(4);
          fill(255, 255, 0);
          rect(p.x*w, p.y*w, w, w);
        }

        checkPressed(dests);
      }
    }

    if (phase == doubleJump) {
      ArrayList<PVector> dests = genValDests();

      for (int i = dests.size()-1; i>=0; i--) {
        if (abs(dests.get(i).x-selected.getGX()) == 2) {
        }
      }
    }
  }

  private void showAll() {
    stroke(0);
    strokeWeight(0);
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

      if (selected != null) phase = valDests;
    }
  }

  private ArrayList<PVector> genValDests() {
    int x = selected.getGX();
    int y = selected.getGY();
    PVector c = null;
    ArrayList<PVector> result = new ArrayList<PVector>();

    if (!selected.getWhite() || selected.getKing()) {
      c = check(1, -1);
      if (c != null) result.add(c);

      c = check(-1, -1);
      if (c != null) result.add(c);
    }

    if (selected.getWhite() || selected.getKing()) {
      c = check(1, 1);
      if (c != null) result.add(c);

      c = check(-1, 1);
      if (c != null) result.add(c);
    }

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
    } else result = new Piece(-2, -2, false);
    return result;
  }

  private void checkPressed(ArrayList<PVector> sqrs) {
    if (mousePressed) {
      for (PVector p : sqrs) {

        if (mouseX >= p.x*w && mouseX <= (p.x+1)*w 
          && mouseY >= p.y*w && mouseY <= (p.y+1)*w) {
          boolean dj = move((int) p.x, (int) p.y);

          if (dj) {
            phase = doubleJump;

            println("we got here, we thriving");
          } else {
            blackTurn = !blackTurn;
            selected = null;
            phase = select;
          }
        }
      }
    }
  }

  private boolean move(int x, int y) {
    int x_d = x - selected.getGX();
    int y_d = y - selected.getGY();
    boolean willDoubleJump = false;

    // check if it jumped over something, if so remove it.
    if (abs(x_d) == 2) {
      if (selected.getWhite()) {
        for (int i = black.size()-1; i >= 0; i--) {
          Piece p = black.get(i);
          if (p.getGX() == selected.getGX() + x_d/2
            && p.getGY() == selected.getGY() + y_d/2) {
            black.remove(i);

            willDoubleJump = true;
          }
        }
      } else {
        for (int i = white.size()-1; i >= 0; i--) {
          Piece p = white.get(i);
          if (p.getGX() == selected.getGX() + x_d/2
            && p.getGY() == selected.getGY() + y_d/2) {
            white.remove(i);

            willDoubleJump = true;
          }
        }
      }
    }

    selected.move(x_d, y_d);

    if ((selected.getWhite() && selected.getGY() == 7)
      || (!selected.getWhite() && selected.getGY() == 0)) {
      selected.kingMe();
    }

    return willDoubleJump;
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
  }
}