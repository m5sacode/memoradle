import g4p_controls.*;
import controlP5.*;
import java.util.Arrays;

String consola;
String[] palabras = {}; //Se pueden añadir más pero de momento está así :)

String[] defs = {};
ControlP5 cp5;

boolean description = false;

int squaresize = 60;

int    chosenindex;
String chosenword;
int    chosenwordlen;
int    boardlength;
char[] boardchars;
int[]  boardtypes;

String outputword;

String writtenword;

void loadWordsFromFile(String filepath) {
  String[] lines = loadStrings(filepath);
  if (lines == null || lines.length == 0) {
    println("⚠️ ERROR: Could not load or read " + filepath);
    exit();
  }

  ArrayList<String> wordList = new ArrayList<String>();
  ArrayList<String> defList = new ArrayList<String>();

  for (String line : lines) {
    if (line.contains("::")) {
      String[] parts = split(line, "::");
      if (parts.length >= 2) {
        wordList.add(parts[0].trim().toUpperCase());
        defList.add(join(subset(parts, 1), "::").trim());
      }
    }
  }

  if (wordList.size() > 0 && wordList.size() == defList.size()) {
    palabras = wordList.toArray(new String[0]);
    defs = defList.toArray(new String[0]);
    println("✅ Loaded " + palabras.length + " words.");
  } else {
    println("❌ Mismatch or empty word/definition lists.");
    exit();
  }
}




int attempt = 0;

void setup() {
  loadWordsFromFile("words.txt");
  
  chosenindex   = int(random(palabras.length));
  chosenword    = palabras[chosenindex];
  chosenwordlen = chosenword.length();
  boardlength   = chosenwordlen * 5;
  boardchars    = new char[boardlength];
  boardtypes    = new int [boardlength];
  for (int i = 0; i < boardlength; i++) {
    boardchars[i] = ' ';
    boardtypes[i] = 0;
  }
  
  String[] fontList = PFont.list();
  //printArray(fontList);
  fullScreen();
  cp5 = new ControlP5(this);
  cp5.addTextfield("")
     .setPosition(width/2-width/6, 100)
     .setSize(width/3, 60)
     .setAutoClear(false)
     .setFont(createFont("Comic Sans MS" , 50))
     .setColorValue(#ffffff)
     .setColorActive(0xff00ff00)
     .setColorBackground(0000);
  cp5.addBang("PROBAR")
     .setPosition(width/2-width/8, 180)
     .setSize(width/8-10, 60)
     .setFont(createFont("times new roman", 30))
     .setColorValue(0xff00ff00)
     .setColorBackground(0xff00ff00)
     .setColorActive(color(0,122,0))
     .setColorForeground(0xff00ff00);
  cp5.addBang("DEFINICION")
     .setPosition(width/2+10, 180)
     .setSize(width/8-10, 60)
     .setFont(createFont("times new roman", 30))
     .setColorValue(color(200,0,0))
     .setColorBackground(color(200,0,0))
     .setColorActive(color(122,0,0))
     .setColorForeground(color(200,0,0));
  cp5.addTextarea("Descripcion")
     .setPosition(width/2-width/4, height-300)
     .setSize(width/2, 200)
     .setFont(createFont("Comic Sans MS" , 20));
  if(defs.length != palabras.length) println("Comprueba q están todas las definiciones bro");
}

void draw () {
  background(0);
  DRAWBOARD(boardchars, boardtypes, chosenwordlen, width/2, height/3);
  writtenword = (cp5.get(Textfield.class, "").getText());
  textSize(60);
  stroke(0,250,0);
  text(str(writtenword.length()-chosenwordlen), 20, 100);
  if (description) {
    cp5.get(Textarea.class, "Descripcion").setText(defs[chosenindex]);
  } else {
    cp5.get(Textarea.class, "Descripcion").setText("...");
  }
}

void keyPressed() {
  if (keyCode == ENTER){
    PROBAR();
  }
}

void PROBAR() {
  outputword = (cp5.get(Textfield.class, "").getText());
  // print("Sale esto: ");
  // print(outputword);
  if(outputword.length() == chosenwordlen){
    // println();
    cp5.get(Textfield.class, "").clear();
    char[] outarray = outputword.toUpperCase().toCharArray();
    char[] chosenarray = chosenword.toCharArray();
    boolean[] wordused = new boolean[chosenwordlen];
    for(int i = 0; i < chosenwordlen; i++) {                                               // Consigue las verdes
      int arraypos = (attempt * chosenwordlen) + i;
      boardchars[arraypos] = outarray[i];
      if(outarray[i] == chosenarray[i]){
        boardtypes[arraypos] = 2;
        wordused[i] = true;
      }
      else{
        wordused[i] = false;
      }
    }
    for(int i = 0; i < chosenwordlen; i++) {
      int arrayposI = (attempt * chosenwordlen) + i;
      for(int ii = 0; ii < chosenwordlen; ii++) {
        if(outarray[i] == chosenarray[ii]) {
          if(!wordused[ii] && boardtypes[arrayposI] != 2){
            boardtypes[arrayposI] = 1;
            wordused[ii] = true;
            break;
          }
        }
      }
    }
    attempt++;
  }
}

void DEFINICION() {
  description = !description;
}

void DRAWLETTER(char letter, int fill, float x, float y) {
  strokeWeight(2);
  if (fill == 0) {
   stroke(240);
   noFill();
   square(x,y,squaresize);
   fill(250);
  }
  else {
   stroke(0);
   if (fill == 1)fill(252, 186, 3);
   else fill(0,240,0);
   square(x,y,squaresize);
   fill(0);
  }
  textSize(60);
  text(letter, x+15, y+50);
}

void DRAWBOARD(char[] letters, int[] types, int columns,int x0,int y0){
  float bwidth = (columns*squaresize) + (10*(columns-1));
  float x0l = x0 - (bwidth/2);
  for(int i = 0; i < 5; i++) {
    for(int ii = 0; ii < columns; ii++){
      int arrayindex = (i)*columns + (ii);
      DRAWLETTER(boardchars[arrayindex], boardtypes[arrayindex], x0l + (ii * (squaresize + 10)), y0 + (i * (squaresize + 20)));
    }
  }
}
