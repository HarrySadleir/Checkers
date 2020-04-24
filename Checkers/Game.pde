// playing the game itself
class Game extends GameState {
  // white and black's pieces respectively
  private ArrayList<Piece> white;
  private ArrayList<Piece> black;

  private ArrayList<PVector> dests;

  // tracks whose turn it is
  private boolean blackTurn;

  // tracks what phase of each turn it is
  private int phase;
  private final int select = 0;
  private final int chooseDest = 1;
  private final int doubleJump = 2;

  // tracks the piece selected by the player
  private Piece selected;

  Game() {
    // fill the starting board of standard checkers (on white squares)
    setBoard();

    // start's in the select phase of black's turn
    blackTurn = true;
    phase = select;
  }
  
  // fill the starting board of standard checkers (on white squares)
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

  public void act() {
    // show pieces, grid, and highlight selected piece
    showAll(); 

    // allows player to select a piece, and genValDests() once chosen
    if (blackTurn) selectPiece(black); 
    else selectPiece(white);

    // filter dests, pass turn when necessary, wait for selection
    if (phase == chooseDest || phase == doubleJump) {

      // filter for only secondary jumps if a jump has already been made
      if (phase == doubleJump) {
        filterJumps();
      }

      // if the above step leaves no valid jumps, move to next player's turn
      // else hightlight valid destinations, and wait for one of the destinations to be chosen
      if (dests.size() == 0 && phase == doubleJump) {
        phase = select;
        selected = null;
        blackTurn = !blackTurn;
      } else {
        checkPressed(dests);
      }
    }

    // check if white wins
    if (white.size() == 0) {
      gs = new GameOver(true);
      mode = winner;
    }

    // check if black wins
    if (black.size() == 0) {
      gs = new GameOver(false);
      mode = winner;
    }
  }

  // show pieces, board, highlight selected piece, and dests
  private void showAll() {
    // board
    stroke(0);
    strokeWeight(0);
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if ((i+j)%2 == 1) fill(255);
        else fill(0);
        rect(w*i, w*j, w, w);
      }
    }

    // pieces
    for (Piece p : white) p.show();
    for (Piece p : black) p.show();

    // highlight selected piece
    if (selected != null) {
      stroke(255, 255, 0);
      noFill();
      ellipse(selected.getX(), selected.getY(), selected.getD()*1.1, selected.getD()*1.1);
    }

    // highlight dests
    if (dests != null) {
      for (PVector p : dests) {
        stroke(255, 255, 0);
        strokeWeight(4);
        noFill();
        rect(p.x*w, p.y*w, w, w);
      }
    }
  }
  
  // remove all destinations in dests that do not jump a piece
  private void filterJumps() {
    for (int i = dests.size()-1; i>=0; i--) {
      if (abs(dests.get(i).x-selected.getGX()) != 2) {
        dests.remove(i);
      }
    }
  }

  //---------------------------------------------------------------------------------------
  // Piece Selection and Destination Generating

  // when an appropriately coloured piece is clicked, select it and getValDests
  private void selectPiece(ArrayList<Piece> pieces) {
    if (mousePressed) {
      for (Piece p : pieces) {
        if (dist(mouseX, mouseY, p.getX(), p.getY()) < p.getD()/2) selected = p;
      }

      if (selected != null) {
        if (phase == select) phase = chooseDest;
        dests = genValDests();
      }
    }
  }

  // generate all valid destinations for selected piece as PVectors
  private ArrayList<PVector> genValDests() {
    PVector c = null;
    ArrayList<PVector> result = new ArrayList<PVector>();

    // checks for black pieces and white kings
    if (!selected.getWhite() || selected.getKing()) {
      c = check(1, -1);
      if (c != null) result.add(c);

      c = check(-1, -1);
      if (c != null) result.add(c);
    }

    // checks for white pieces and black kings
    if (selected.getWhite() || selected.getKing()) {
      c = check(1, 1);
      if (c != null) result.add(c);

      c = check(-1, 1);
      if (c != null) result.add(c);
    }

    return result;
  }

  // check square xi+yj away from selected
  private PVector check(int x, int y) {
    int x_ = selected.getGX();
    int y_ = selected.getGY();
    boolean white = selected.getWhite();

    // if the square is occupied
    if (occupied(x_+x, y_+y) != null) {
      // if that square was the opposite colour and the square beyond is empty
      if (occupied(x+x_, y+y_).getWhite() != white && occupied(x_+2*x, y_+2*y) == null) {
        // then the square beyond is valid
        return new PVector(x_+2*x, y_+2*y);  
      } else {
        // otherwise return null
        return null;
      }
      // otherwise that square is valid
    } else return new PVector(x_+x, y_+y);
  }
  
  // checks if square is occupied, if so return occupant, otherwise return null
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
  
  //---------------------------------------------------------------------------------------
  // Destination Selection and Movement
  
  // On mouse click, if a destination from sqrs is clicked, move selected piece there, 
  // then check if the turn should end
  private void checkPressed(ArrayList<PVector> sqrs) {
    if (mousePressed) {
      for (PVector p : sqrs) {
        
        // check if sqrs element clicked on, if so move
        if (mouseX >= p.x*w && mouseX <= (p.x+1)*w 
          && mouseY >= p.y*w && mouseY <= (p.y+1)*w) {
          boolean dj = move((int) p.x, (int) p.y);
          
          // manage end of turn
          if (dj) {
            phase = doubleJump;
          } else {
            blackTurn = !blackTurn;
            selected = null;
            phase = select;
          }
        }
      }
    }
  }
  
  // moves selected piece to x, y; returns true and removes jumped piece if a piece was jumped
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
    
    // move it
    selected.move(x_d, y_d);
    
    // if in the appropriate end of the board, king the selected piece
    if ((selected.getWhite() && selected.getGY() == 7)
      || (!selected.getWhite() && selected.getGY() == 0)) {
      selected.kingMe();
    }
    
    // clear dests
    dests = null;

    return willDoubleJump;
  }
}