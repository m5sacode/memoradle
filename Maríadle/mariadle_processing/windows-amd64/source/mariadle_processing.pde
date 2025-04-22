import g4p_controls.*;
import controlP5.*;
import java.util.Arrays;

String consola;
String[] palabras = {
  "ANDREA",                                                          //0
  "ASTURIAS",                                                        //1
  "BARQUEAR",                                                        //2
  "CARACOBALLO",                                                     //3
  "CAGAR LIMPIO",                                                    //4
  "COCHIBARCO",                                                      //5
  "CULISIMO",                                                        //6
  "DESPANTALONARSE",                                                 //7
  "ENFANTAR",                                                        //8
  "GRU_GRU",                                                         //9
  "HACIBLE",                                                         //10
  "HUECO",                                                           //11
  "MARTA",                                                           //12
  "PTERODACTILO",                                                    //13
  "PMVCMNP",                                                         //14
  "PUNTO",                                                           //15
  "PERSIANA",                                                        //16
  "PERSONAR",                                                        //17
  "QUIEORER",                                                        //18
  "SABELO",                                                          //19
  "SOLETTE",                                                         //20
  "TEZACTLIPOCA",                                                    //21
  "TUOLAS",                                                          //22
  "WI"                                                               //23
}; //Se pueden añadir más pero de momento está así :)

String[] defs = {
  "Asturias, perfecta. La hermana melliza",                                                                               //0
  "Patria querida, Perfecta, tierra del Nano",                                                                            //1
  "Hacer de barco",                                                                                                       //2
  "Animal con cabeza de caballo y cuerpo de caracol",                                                                     //3 
  "Intentar hacer las cosas bien: Me gustas porque tiendes a cagar limpio y limpiarte bien el culo",                      //4
  "Vehículo anfibio capaz de barquear y cochear",                                                                         //5
  "Culo bonito. Superlativo del adjetivo culo",                                                                           //6
  "Quitarse los pantalones, solo socialmente acetable con dobles pantalones como en cierto vuelo de vueling",             //7
  "Encantar en gran medida",                                                                                              //8
  "Estar dormido/a, con cerebro al borde de lo disfuncional",                                                             //9
  "Que se puede hacer...",                                                                                                //10
  "Molar un ·····, molar en alta cantidad",                                                                               //11
  "Comunidad Autónoma y Provincia homónima al Norte de España, bañada por el mar Cantábrico y por definición Perfecta",   //12
  "Todo, osea si todo",                                                                                                   //13
  "Quiróptero, mamífero placentario cuyas extremidades superiores se desarrollan como alas",                              //14
  "Raya :)",                                                                                                              //15
  "Persona",                                                                                                              //16
  "Ser persona en todas capacidades",                                                                                     //17
  "Querer con prisa y sin mirar lo q escribes",                                                                           //18
  "Conjugación imperativa del verbo saber unida al pronombre 'lo'. Peculiar forma de dar información",                    //19
  "Estrella coquette, la mas cercana a la tierra. A y una chica fantastica pero dicho como si fuese tu abuela",           //20
  "El dios ese del espejo humeante. Buena suerte acordandote, me gusto la palabra",                                       //21
  "Contraccion de 'tu molas'",                                                                                            //22
  "Si en Francés",                                                                                                        //23
};
ControlP5 cp5;

boolean description = false;

int squaresize = 60;

int chosenindex = int(random(palabras.length));
String chosenword = palabras[chosenindex];
int chosenwordlen = chosenword.length();
int boardlength = chosenword.length() * 5;
char[] boardchars = new char[boardlength];
int[] boardtypes = new int[boardlength];

String outputword;

String writtenword;

int attempt = 0;
void setup() {
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
