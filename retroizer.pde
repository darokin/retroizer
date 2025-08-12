import java.io.File;
import java.util.*;   // List
import controlP5.*;   // import controlP5 library

byte unsignedByte(int val) { return (byte)( val > 127 ? val - 256 : val ); }

ControlP5 controlP5;
SideBar leftBar;
RenderZone render;

PImage logoTool, logoDar;

final int bottomDec = 60;
final int defaultPixelSize = 0;
final int defaultOutputPixelSize = 1;
final int renderPixelSize = 8;

// ====================================
// == BAYER matrices ==================
// ====================================
final float[][] bayer4 = { 
  {0, 2}, 
  {3, 1} 
};

final float[][] bayer16 = { 
  {0, 8, 2, 10}, 
  {12, 4, 14, 6},
  {3, 11, 1, 9},
  {15, 7, 13, 5}
};

final float[][] bayer64 = { 
  {0, 32, 8, 40, 2, 34, 10, 42}, 
  {48, 16, 56, 24, 50, 18, 58, 26},
  {12, 44, 4, 36, 14, 46, 6, 38},
  {60, 28, 52, 20, 62, 30, 54, 22},
  {3, 35, 11, 43, 1, 33, 9, 41},
  {51, 19, 59, 27, 49, 17, 57, 25},
  {15, 47, 7, 39, 13, 45, 5, 37},
  {63, 31, 55, 23, 61, 29, 53, 21}
};
//https://en.wikipedia.org/wiki/Ordered_dithering
//https://surma.dev/things/ditherpunk/

final float [][][] bayer = {bayer4, bayer16, bayer64};

// ====================================
// == COLOR PALETTES ==================
// ====================================
final color[] palCMYK = {
  #55FFFF, // bright CYAN
  #FF55FF, // bright MAGENTA
  #FFFFFF, // WHITE
  #FFFF00, // YELLOW
  #000000  // BLACK
};

final color[] palCGA4 = {
  #fc54fc, // magenta
  #54fcfc, // green / turquoise
  #ffffff, // white
  #000000  // black
};

final color[] palCGA16 = {
  #000000, #0000AA, #00AA00, #00AAAA, #AA0000, #AA00AA, #AA5500, #AAAAAA,
  #555555, #5555FF, #55FF55, #55FFFF, #FF5555, #FF55FF, #FFFF55, #FFFFFF
};

final color[] palGameBoy = {
  //#9bbc0f, #8bac0f, #306230, #0f380f
  #0F380F, #306230, #8BAC0F, #9BBC0F
};

final color[] palGameBoyLight = {
  #282828, #606060, #A0A0A0, #E0E0E0
};
final color[] palGameBoyPocket = {
  //#ffffff, #a9a9a9, #545454, #000000
  #212121, #555555, #999999, #DDDDDD
};

final color[] palMasterSystem = {
  #000000, #0000AA, #00AA00, #00AAAA, #AA0000, #AA00AA, #AA5500, #AAAAAA,
  #555555, #5555FF, #55FF55, #55FFFF, #FF5555, #FF55FF, #FFFF55, #FFFFFF,
  #000055, #0000FF, #005500, #0055FF, #550000, #5500FF, #555500, #5555AA,
  #005555, #00FF00, #00FFFF, #AA00FF, #AAFF00, #AAFFFF, #FF00AA, #FFAA00,
  #FFAAFF, #FF00FF, #FFAA55, #FFFFAA, #00AAFF, #AA0055, #AAFFAA, #FFAAAA,
  #0055AA, #55AA00, #55AAFF, #AA5500, #AA55FF, #55FFAA, #AAFF55, #FF55AA,
  #55AAAA, #AAAA55, #AA55AA, #55AA55, #FFAAFF, #AAFFFF, #FFFF55, #55FFFF,
  #FF55FF, #FF5555, #FF55AA, #55FF55, #55FF00, #00FF55, #00FFAA, #AAFF00
};

final color[] palNES = {
  #000000, #FCFCFC, #F8F8F8, #BCBCBC, #7C7C7C, #A4E4FC, #3CBCFC, #0078F8,
  #0000FC, #B8B8F8, #6888FC, #0058F8, #0000BC, #D8B8F8, #9878F8, #6844FC,
  #4428BC, #F8B8F8, #F878F8, #D800CC, #940084, #F8A4C0, #F85898, #E40058,
  #A80020, #F0D0B0, #F87858, #F83800, #A81000, #FCE0A8, #FCA044, #E45C10,
  #881400, #F8D878, #F8B800, #AC7C00, #503000, #D8F878, #B8F818, #00B800,
  #007800, #B8F8B8, #58D854, #00A800, #006800, #B8F8D8, #58F898, #00A844,
  #005800, #00FCFC, #00E8D8, #008888, #004058, #F8D8F8, #787878

};
final color[] palC64 = {
  #000000, #FFFFFF, #880000, #AAFFEE, #CC44CC, #00CC55, #0000AA, #EEEE77,
  #DD8855, #664400, #FF7777, #333333, #777777, #AAFF66, #0088FF, #BBBBBB
};
final color[] palZXspectrum = {
  // ntsc
  //#000000, #0000D8, #D80000, #D800D8, #00D800, #00D8D8, #D8D800, #D8D8D8,
  //#0000FF, #FF0000, #FF00FF, #00FF00, #00FFFF, #FFFF00, #FFFFFF
  // pal
  #000000, #0000D7, #D70000, #D700D7, #00D700, #00D7D7, #D7D700, #D7D7D7,
  #0000FF, #FF0000, #FF00FF, #00FF00, #00FFFF, #FFFF00, #FFFFFF
};

final color[] palAtari2600 = {
  #000000, #FFFFFF, #FF0000, #00FF00, #0000FF, #FFFF00, #FF00FF, #00FFFF
};

final color[] palAppleII = {
  #000000, #FFFFFF, #FF0000, #00FF00, #0000FF, #FFFF00, #00FFFF, #FF00FF
};

final color[] palBBCmicro = {
  #000000, #FF0000, #00FF00, #FFFF00, #0000FF, #FF00FF, #00FFFF, #FFFFFF
};

final color[] palAtariST = {
  #000000, #880000, #00AA00, #AAAA00, #0000AA, #AA00AA, #00AAAA, #AAAAAA,
  #555555, #FF0000, #00FF00, #FFFF00, #0000FF, #FF00FF, #00FFFF, #FFFFFF
};

final color[] palAmstradCPC = {
  #000000, #0000FF, #FF0000, #FF00FF, #00FF00, #00FFFF, #FFFF00, #FFFFFF,
  #000080, #800000, #800080, #008000, #008080, #808000, #808080, #C0C0C0
};

final color[] palMSX1 = {
  #000000, #0000FF, #00FF00, #00FFFF, #FF0000, #FF00FF, #FFFF00, #FFFFFF,
  #808080, #8080FF, #80FF80, #80FFFF, #FF8080, #FF80FF, #FFFF80, #C0C0C0
};

final color[] grayscale2 = {
  #FFFFFF, #000000
};

final color[] grayscale4 = {
  #FFFFFF, #AAAAAA, #555555, #000000
};

final color[] grayscale6 = {
  #FFFFFF, #CCCCCC, #999999, #666666, #333333, #000000
};

final color[] grayscale8 = {
  #FFFFFF, #DDDDDD, #BBBBBB, #999999, #777777, #555555, #333333, #000000
};

final color[] grayscale12 = {
  #FFFFFF, #E5E5E5, #CCCCCC, #B2B2B2, #999999, #7F7F7F, #666666, #4C4C4C, #333333, #191919, #080808, #000000
};

final color[] grayscale16 = {
  #FFFFFF, #EFEFEF, #DFDFDF, #CFCFCF, #BFBFBF, #AFAFAF, #9F9F9F, #8F8F8F, 
  #7F7F7F, #6F6F6F, #5F5F5F, #4F4F4F, #3F3F3F, #2F2F2F, #1F1F1F, #000000
};

final color[] grayscale24 = {
  #FFFFFF, #F5F5F5, #EBEBEB, #E1E1E1, #D7D7D7, #CDCDCD, #C3C3C3, #B9B9B9, 
  #AFAFAF, #A5A5A5, #9B9B9B, #919191, #878787, #7D7D7D, #737373, #696969, 
  #5F5F5F, #555555, #4B4B4B, #414141, #373737, #2D2D2D, #1A1A1A, #000000
};

final color[] grayscale32 = {
  #FFFFFF, #F7F7F7, #EFEFEF, #E7E7E7, #DFDFDF, #D7D7D7, #CFCFCF, #C7C7C7, 
  #BFBFBF, #B7B7B7, #AFAFAF, #A7A7A7, #9F9F9F, #979797, #8F8F8F, #878787, 
  #7F7F7F, #777777, #6F6F6F, #676767, #5F5F5F, #575757, #4F4F4F, #474747, 
  #3F3F3F, #373737, #2F2F2F, #272727, #1F1F1F, #171717, #0F0F0F, #000000
};

final String[] palettesNames = {
  "CMYK", "CGA 4", "CGA 16", "Gameboy", "Gameboy Light", "Gameboy Pocket", "NES", "Master System",
  "Atari 2600", "Apple II", "BBC Micro", "Commodore 64", "ZX Spectrum", "Atari ST", "Amstrad CPC", "MSX 1",
  "1bit", "2bit", "Grayscale 6", "Grayscale 8", "Grayscale 12", "Grayscale 16", "Grayscale 24", "Grayscale 32" 
};

final color[][] palettesArray = {
  palCMYK, palCGA4, palCGA16, palGameBoy, palGameBoyLight, palGameBoyPocket, palNES, palMasterSystem, 
  palAtari2600, palAppleII, palBBCmicro, palC64, palZXspectrum, palAtariST, palAmstradCPC, palMSX1,
  grayscale2, grayscale4, grayscale6, grayscale8, grayscale12, grayscale16, grayscale24, grayscale32
};

final String[] ditheringNames = {
  "Bayer 2x2", "Bayer 4x4", "Bayer 8x8"
};

final String[] scanlinesNames = {
  "1/2 horizontal black", "1/2 horizontal cyan", "1/2 horizontal green"
};

final int[] blendModes = {
  BLEND, ADD, MULTIPLY, OVERLAY, SCREEN
};
          


void settings() {
  fullScreen();
}

void setup()
{
  //noLoop();
  background(0);//200, 200, 200);
  noStroke();
  randomSeed(42); // so the dithering noise do the same each time
  
  logoTool = loadImage("pixert_logo.png");
  logoDar = loadImage("DAR_pixelart_x2_voile.png");
  
  leftBar   = new SideBar();
  render    = new RenderZone(leftBar.leftMenuWidth, 0, width - leftBar.leftMenuWidth, height);
  controlP5 = new ControlP5(this);
 
  leftBar.setupUI();
    
  println("INIT !");
}

void draw() {
  background(0); 
  leftBar.draw();
  render.draw();
  //controlP5.draw();
}

void drawLogo() {
  // == logo
  image(logoDar, width - logoDar.width, height - logoDar.height - bottomDec + 20);
}

void keyPressed() {
  if (key == 's') {
    saveFrame("Dither_shot_01.png");
  }
}
