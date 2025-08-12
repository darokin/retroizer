

class RenderZone {
  private int border = 4;
  private int renderX;
  private int renderY;
  private int renderWidth;
  private int renderHeight;
  
  private int baseImgWidth;
  private int baseImgHeight;
  private int renderImgWidth;
  private int renderImgHeight;
  private PImage renderImage;
  private PGraphics renderGfx;

  private int imgX, imgY;
  private int nbPixelsX;
  private int nbPixelsY;
  private int decX;
  private int decY;
  ArrayList<PVector> pixelsArray;
  public ArrayList<PVector> pixelsArrayHSV;
  
  public int brightness;
  public int contrast;
  public int gamma;
  public boolean colorLimit;
  public int colors;
  public boolean customPalette;
  public int paletteInd;
  public boolean scanline;
  public int scanlineType;
  public int scanlineOpacity;
  public boolean grayscale;
  public int pixelSize;
  public int outputPixelSize;
  public boolean dithering;
  public int ditheringType;
  public float ditheringNoise;
  public boolean glow;
  public color overlayColor;
  public int overlayMode;
  public int overlayOpacity;

  RenderZone(int _startX, int _startY, int _width, int _height) {
    renderX = _startX + border;
    renderY = _startY + border;
    renderWidth = _width - (border * 2);
    renderHeight = _height - (border * 2);

    brightness = 0;
    contrast = 0;
    gamma = 0;
    grayscale = false;
    pixelSize = 1;
    outputPixelSize = 1;
    dithering = false;
    ditheringType = -1;
    ditheringNoise = .0;
    colorLimit = false;
    colors = 0;
    customPalette = false;
    paletteInd = -1;
    scanline = false;
    scanlineType = -1;
    scanlineOpacity = 50;
    glow = false;
    overlayColor = color(255, 0, 255);
    overlayMode = 0;
    overlayOpacity = 50;
    pixelsArray = new ArrayList<PVector>();
    pixelsArrayHSV = new ArrayList<PVector>();
  }

  public void addRenderImage(String _fullPath) {
    renderImage = loadImage(_fullPath);
    
    baseImgWidth = renderImage.width;
    baseImgHeight = renderImage.height;
    
    // == calculer dimensions optimales
    float ratioW = (float)renderWidth / renderImage.width;
    float ratioH = (float)renderHeight / renderImage.height;
    float maxRatio;
    if (ratioW > ratioH)
      maxRatio = ratioH;
    else
      maxRatio = ratioW;
    //println("renderZone  [" + renderWidth + " , " + renderHeight + "]  render image [" + renderImage.width + " , " + renderImage.height + "]  ratioW='"+ratioW+"' ratioH'"+ratioH+"'");
    renderImgWidth = floor(maxRatio * renderImage.width);
    renderImgHeight = floor(maxRatio * renderImage.height);
    // == calculer positions
    imgX = renderX + (renderWidth / 2) - (renderImgWidth / 2);
    imgY = renderY + (renderHeight / 2) - (renderImgHeight / 2);

    leftBar.setOriginalImage(renderImage);
    leftBar.setImagePath(_fullPath);
    
    this.recalcPixels();
    this.calc();

    println("END");
  }
  
  public void recalcPixels() {
    if (renderImage == null)
      return;
    
    println("== RECALC ========================== pixelSize = " + pixelSize);
    println("nbPixel [" + nbPixelsX + ", " + nbPixelsY + "] => " + (nbPixelsX * nbPixelsY) + " Pixel array size = " + pixelsArray.size()); 
    
    nbPixelsX = floor(baseImgWidth / pixelSize);
    nbPixelsY = floor(baseImgHeight / pixelSize);
    decX = floor(((baseImgWidth) - (nbPixelsX * pixelSize)) / 2);
    decY = floor(((baseImgHeight) - (nbPixelsY * pixelSize)) / 2);
    
    pixelsArray.clear();

    int r, g, b, n;
    color c;
    for (int y = 0; y < nbPixelsY; y++) {
      for (int x = 0; x < nbPixelsX; x++) {
        r = g = b = n = 0;
        for (int yy = floor(y * pixelSize) + decY; yy < floor(y * pixelSize) + decY + pixelSize; yy++) {
          for (int xx = floor(x * pixelSize) + decX; xx < floor(x * pixelSize) + decX + pixelSize; xx++) {
            if (xx >= baseImgWidth || yy >= baseImgHeight) 
              continue;
            c = renderImage.pixels[(yy * baseImgWidth) + xx];
            r += red(c);
            g += green(c);
            b += blue(c);
            n++;
          }
        }
        if (n == 0) 
          continue;
        c = color(floor(r / n), floor(g / n), floor(b / n));
        c = treatPixel(c, x, y);
        if (this.colorLimit || this.customPalette)
          c = nearestColor(c);
        pixelsArray.add(new PVector(red(c), green(c), blue(c)));
        pixelsArrayHSV.add(new PVector(hue(c), saturation(c), brightness(c)));
      }
    }
  }
  
  public color nearestColor(color c) {
    float bestDist = -1;
    float curDist;
    int bestPaletteInd = 0;
    
    if (leftBar.palette.length == 0)
      return c;
    
    for (int i = 0; i < leftBar.palette.length; i++) {
      curDist = distRGB(leftBar.palette[i], c);
      if (bestDist == -1 || curDist < bestDist) {
        bestDist = curDist;
        bestPaletteInd = i;
      }
    }
    
    return leftBar.palette[bestPaletteInd];
  }
  
   // ===========================================================
  
  private color treatPixel(color _c, int _x, int _y) {
    int _r,_g,_b;
    _r = (int)red(_c);
    _g = (int)green(_c);
    _b = (int)blue(_c);
    
    // == BRIGHTNESS
    if (brightness != 0) {
      _r += brightness;
      _g += brightness;
      _b += brightness;
      _r = constrain(_r, 0, 255);
      _g = constrain(_g, 0, 255);
      _b = constrain(_b, 0, 255);
    }
    
    // == CONTRAST
    if (contrast != 0) {
      float _contrastFactor = (259 * float(contrast + 255)) / (255 * float(259 - contrast));
      _r = floor(_contrastFactor * float(_r - 128) + 128);
      _g = floor(_contrastFactor * float(_g - 128) + 128);
      _b = floor(_contrastFactor * float(_b - 128) + 128);
      _r = constrain(_r, 0, 255);
      _g = constrain(_g, 0, 255);
      _b = constrain(_b, 0, 255);
    }
    
    if (gamma != 0) {
      float _gammaCorrection = 1.0 / map(gamma, -10.0, 10.0, .01, 1.99);
      _r = floor(255.0 * pow((float)_r / 255.0, _gammaCorrection)); 
      _g = floor(255.0 * pow((float)_g / 255.0, _gammaCorrection));
      _b = floor(255.0 * pow((float)_b / 255.0, _gammaCorrection));
    }
    
    // == GRAYSCALE
    if (grayscale) {
      float _l;
      // == grayscale based on lumiscence
      //_l = (0.2126 * _r + 0.7152 * _g + 0.0722 * _b);
      // == grayscale "pondéré" // https://www.dfstudios.co.uk/articles/programming/image-programming-algorithms/image-processing-algorithms-part-3-greyscale-conversion/
      _l = (0.299 * _r + 0.587 * _g + 0.114 * _b);
      _l = constrain(_l, 0, 255);
      
      if (dithering) {
        if (ditheringNoise != 0) {
          _l += random(-ditheringNoise / 10.0, ditheringNoise / 10.0);
        }
        //_l = applyDithering(ditheringType, _l, _x, _y);
        _l += getBayer(ditheringType, _x, _y);
        if (_l > 128)
          _l = 255;
        else
          _l = 0;
      }
      
      _r = floor(_l);
      _g = floor(_l);
      _b = floor(_l);
    } else if (colorLimit || customPalette) {
      // == dithering avec palette de couleur limitée
      if (dithering) {
        float _bayer = getBayer(ditheringType, _x, _y);
        _r += _bayer;
        _g += _bayer;
        _b += _bayer;
        if (ditheringNoise != 0) {
          _r += random(-ditheringNoise / 10.0, ditheringNoise / 10.0);
          _g += random(-ditheringNoise / 10.0, ditheringNoise / 10.0);
          _b += random(-ditheringNoise / 10.0, ditheringNoise / 10.0);
        }
        _r = constrain(_r, 0, 255);
        _g = constrain(_g, 0, 255);
        _b = constrain(_b, 0, 255);
      }
    }

    return color(_r, _g, _b);
  }
  
  
  public void calc() {
    if (renderImage == null)
      return;

    color c;

    renderGfx = createGraphics((int)ceil(nbPixelsX * renderPixelSize), (int)ceil(nbPixelsY * renderPixelSize));
    
    renderGfx.noSmooth();
    renderGfx.beginDraw();
    renderGfx.noStroke();
    renderGfx.background(0);

    PVector _px;
    for (int y = 0; y < nbPixelsY; y++) {
      for (int x = 0; x < nbPixelsX; x++) {
        _px = pixelsArray.get((y * nbPixelsX) + x);    
        c = color(_px.x, _px.y, _px.z);
        renderGfx.fill(c);
        renderGfx.rect(x * renderPixelSize, y * renderPixelSize, renderPixelSize, renderPixelSize);
        if (scanline) {
          switch (scanlineType) {
            case 0:
              renderGfx.fill(0, scanlineOpacity);
              break;
            case 1:
              renderGfx.fill(0, 255, 255, scanlineOpacity);
              break;
            case 2:
              renderGfx.fill(0, 255, 0, scanlineOpacity);
          }
          renderGfx.rect(x * renderPixelSize, y * renderPixelSize - (renderPixelSize / 2), renderPixelSize, renderPixelSize - (renderPixelSize / 2));
        }
      }
    }
    
    if (overlayMode > 0) {
      renderGfx.blendMode(blendModes[overlayMode]);
      renderGfx.fill(overlayColor);
      renderGfx.rect(0, 0, renderGfx.width, renderGfx.height);
      renderGfx.blendMode(BLEND);
    }

    renderGfx.endDraw();
    this.draw();
  }

  void draw() {
    if (renderGfx != null) {
      image(renderGfx, imgX, imgY, renderImgWidth, renderImgHeight);
    }
    drawLogo();
  }
  
  void saveRenderImage() {
    int finalOutputPixelSize = (outputPixelSize == 0 ? 1 : outputPixelSize) * (scanline ? 2 : 1);
    PGraphics outputGfx = createGraphics((int)ceil(nbPixelsX * finalOutputPixelSize),(int)ceil(nbPixelsY * finalOutputPixelSize));
    outputGfx.beginDraw();
    outputGfx.noStroke();
    outputGfx.background(0);
    for (int y = 0; y < nbPixelsY; y++) {
      for (int x = 0; x < nbPixelsX; x++) {
        PVector colvec = pixelsArray.get((y * nbPixelsX) + x);
        color c = color(colvec.x, colvec.y, colvec.z);
        outputGfx.fill(c);
        outputGfx.rect(x * finalOutputPixelSize, y * finalOutputPixelSize, finalOutputPixelSize, finalOutputPixelSize);

        if (scanline) {
          switch (scanlineType) {
            case 0:
              outputGfx.fill(0, scanlineOpacity);
              break;
            case 1:
              outputGfx.fill(0, 255, 255, scanlineOpacity);
              break;
            case 2:
              outputGfx.fill(0, 255, 0, scanlineOpacity);
          }
          outputGfx.rect(x * finalOutputPixelSize, y * finalOutputPixelSize - (finalOutputPixelSize / 2), finalOutputPixelSize, finalOutputPixelSize - (finalOutputPixelSize / 2));
        }
      }
    }
    
    if (overlayMode > 0) {
      outputGfx.blendMode(blendModes[overlayMode]);
      outputGfx.fill(overlayColor);
      outputGfx.rect(0, 0, outputGfx.width, outputGfx.height);
      outputGfx.blendMode(BLEND);
    }
    
    outputGfx.endDraw();
    outputGfx.save("out.png");
  }
  
  private float getBayer(int _ditheringType, int x, int y) {
    if (_ditheringType < 0 || _ditheringType > 2)
      return 0;
    int bayerSize = bayer[_ditheringType][0].length;
    return (bayer[_ditheringType][x % bayerSize][y % bayerSize] / (bayerSize * bayerSize * bayerSize * bayerSize)) * 128.0;// 255.0
  }
}
