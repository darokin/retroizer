
public void setPixelize(int _val) {
  render.pixelSize = _val;
  if (render.pixelSize <= 0)
    render.pixelSize = 1;
  render.recalcPixels();
  render.calc();
}

public void setPixelizeOut(int _val) {
  render.outputPixelSize = _val;
  if (render.outputPixelSize <= 0)
    render.outputPixelSize = 1;
  render.calc();
}

public void setBrightness(int _val) {
  render.brightness = _val;
  render.recalcPixels();
  render.calc();
}

public void setContrast(int _val) {
  render.contrast = _val;
  render.recalcPixels();
  render.calc();
}

public void setGamma(int _val) {
  render.gamma = _val;
  render.recalcPixels();
  render.calc();
}

public void setColorLimit(boolean _val) {
  if (_val && render.grayscale) {
    leftBar.ctrlToggleGrayscale.setState(false);
    render.grayscale = false;
  }
  if (_val && render.customPalette) {
    leftBar.ctrlToggleCustomPalette.setState(false);
    render.customPalette = false;
  }
  render.colorLimit = _val;
  leftBar.updatePalette();
  render.recalcPixels();
  leftBar.updateUI();
  render.calc();
}

public void setColors(int _val) {
  render.colors = _val;
  if (render.colors <= 2)
    render.colors = 2;
  leftBar.updatePalette();
  render.recalcPixels();
  leftBar.updateUI();
  render.calc();
}

public void setCustomPalette(boolean _val) {
  if (_val && render.grayscale) {
    leftBar.ctrlToggleGrayscale.setState(false);
    render.grayscale = false;
  }
  if (_val && render.colorLimit) {
    leftBar.ctrlToggleColorLimit.setState(false);
    render.colorLimit = false;
  }
  if (leftBar.ctrlDropdownPalette == null)
    return;
  if (render.paletteInd == -1) {
    render.paletteInd = 0;
    leftBar.ctrlDropdownPalette.setValue(0);
  }
  render.customPalette = _val;
  leftBar.updatePalette();
  render.recalcPixels();
  leftBar.updateUI();
  render.calc();
}

public void setPalette(int _val) {
  render.paletteInd = _val;
  leftBar.updatePalette();
  render.recalcPixels();
  leftBar.updateUI();
  render.calc();
}

public void setGrayscale(boolean _val) {
  if (_val && render.colorLimit) {
    leftBar.ctrlToggleColorLimit.setState(false);
    render.colorLimit = false;
  }
  if (_val && render.customPalette) {
    leftBar.ctrlToggleCustomPalette.setState(false);
    render.customPalette = false;
  }
  render.grayscale = _val;
  render.recalcPixels();
  leftBar.updateUI();
  render.calc();
}

public void setDithering(boolean _val) {
  if (leftBar.ctrlDropdownDithering == null)
    return;
  if (render.ditheringType == -1) {
    render.ditheringType = 0;
    leftBar.ctrlDropdownDithering.setValue(0);
  }
  render.dithering = _val;
  render.recalcPixels();
  render.calc();
}

public void setDitheringType(int _val) {
  render.ditheringType = _val;
  render.recalcPixels();
  render.calc();
}

public void setDitheringNoise(float _val) {
  render.ditheringNoise = _val;
  render.recalcPixels();
  render.calc();
}

public void setScanline(boolean _val) {
  if (leftBar.ctrlDropdownScanline == null)
    return;
  if (render.scanlineType == -1) {
    render.scanlineType = 0;
    leftBar.ctrlDropdownScanline.setValue(0);
  }
  render.scanline = _val;
  render.calc();
}

public void setScanlineType(int _val) {
  render.scanlineType = _val;
  render.calc();
}

public void setScanlineOpacity(int _val) {
  render.scanlineOpacity = floor(map(_val, 0, 100, 0, 255));
  render.calc();
}

public void setGlow(boolean _val) {
  render.glow = _val;
  render.calc();
}

public void setOverlayMode(int _val) {
  render.overlayMode = _val;
  render.calc();
}

public void setOverlayColor(color _val) {
  render.overlayColor = _val;
  render.calc();
}

public void setOverlayOpacity(int _val) {
  render.overlayOpacity = _val;
  render.calc();
}

public void debug() {
  //color[] pal = kMeansQuantizeHSV(render.pixelsArrayHSV, 8); 
  //println("====================");
  //for (int j = 0; j < pal.length; j++)
  //  println("pal[" + j + "] = (" + red(pal[j]) + ", " + green(pal[j]) + ", " + blue(pal[j]) + ")");
  //color bluee = color(78, 97, 163);
  //float dist = render.nearestColor(bluee);
}

class SideBar {
  final public int leftMenuWidth = 240;
  final int colorPaletteSquareSize = 25;
  color[] palette;
  int uiStartY;
  final int uiStartX = 20;
  PImage originalImage;
  final int maxOriginalHeight = 720;
  final int sliderDefaultWidth = 134;
  
  final int decYpixelize = 50;
  final int decYbrightness = 80;
  final int decYcontrast = 110;
  final int decYgamma = 140;
  final int decYcolorLimit = 170;
  final int decYcustomPalette = 200;
  final int decYgrayscale = 230;
  final int decYdithering = 260;
  final int decYditheringNoise = 290;
  final int decYscanline = 320;
  final int decYscanlineOpacity = 350;
  final int decYglow = 380;
  final int decYoverlay = 410;
  final int decYoverlayOpacity = 490;
  
  Controller ctrlButtonMain;
  Controller ctrlButtonSave;
  Controller ctrlSlidePixelize;
  Controller ctrlSlideBrightness;
  Controller ctrlSlideContrast;
  Controller ctrlSlideGamma;
  Toggle ctrlToggleColorLimit;
  Controller ctrlSlideColors;
  Toggle ctrlToggleCustomPalette;
  Controller ctrlLabelCustomPalette;
  Controller ctrlDropdownPalette;
  Toggle ctrlToggleGrayscale;
  Controller ctrlLabelGrayscale;
  Controller ctrlToggleDithering;
  Controller ctrlSlideDitheringNoise;
  Controller ctrlDropdownDithering;
  Toggle ctrlToggleScanline;
  Controller ctrlLabelScanline;
  Controller ctrlDropdownScanline;
  Controller ctrlSlideScanlineOpacity;
  Controller ctrlDropdownOverlay;
  ColorPicker ctrlColorPickerOverlay;
  Controller ctrlSlideOverlay;
  Toggle ctrlToggleGlow;
  Controller ctrlLabelGlow;
  Controller ctrlSlidePixelOutput;
  Controller ctrlLabelColorLimit;
  Controller ctrlLabelDithering;
  
  Controller ctrlLabelImagePath;
  
  SideBar() {
    uiStartY = logoTool.height + 10;
  }

  void setupUI() {
    
    // == SELECT IMAGE
    ctrlButtonMain = controlP5.addButton("mainImageButton")
      .setPosition(uiStartX, uiStartY)
      .setSize(leftMenuWidth - (uiStartX * 2), 20)
      .setCaptionLabel("Add image to process")
      .setColorCaptionLabel(color(255, 255, 0));

    // == PIXELIZE
    ctrlSlidePixelize = controlP5.addSlider("setPixelize")
     .setPosition(uiStartX, uiStartY + decYpixelize)
     .setSize(sliderDefaultWidth, 10)
     .setRange(1, 20)
     .setNumberOfTickMarks(20)
     .setSliderMode(Slider.FLEXIBLE)
     .setLabel("pixelize")
     .setValue(defaultPixelSize);
    
    // == BRIGHTNESS
    ctrlSlideBrightness = controlP5.addSlider("setBrightness")
     .setPosition(uiStartX, uiStartY + decYbrightness)
     .setSize(sliderDefaultWidth, 10)
     .setRange(-128, 128)
     .setLabel("brightness")
     .setValue(0);

    // == CONTRAST
    ctrlSlideContrast = controlP5.addSlider("setContrast")
     .setPosition(uiStartX, uiStartY + decYcontrast)
     .setSize(sliderDefaultWidth, 10)
     .setRange(-128, 128)
     .setLabel("contrast")
     .setValue(0);
    
    // == GAMMA CORRECTION
    ctrlSlideGamma = controlP5.addSlider("setGamma")
     .setPosition(uiStartX, uiStartY + decYgamma)
     .setSize(sliderDefaultWidth, 10)
     .setRange(-10, 10)
     .setLabel("Gamma")
     .setValue(0);
    
    // == COLOR LIMIT
    ctrlToggleColorLimit = controlP5.addToggle("setColorLimit")
     .setPosition(uiStartX, uiStartY + decYcolorLimit)
     .setSize(10, 10)
     .setValue(false)
     .setLabel("");
    ctrlLabelColorLimit = controlP5.addTextlabel("labelColorLimit")
     .setText("COLOR LIMIT")
     .setPosition(uiStartX + 14, uiStartY + decYcolorLimit);
    
    ctrlSlideColors = controlP5.addSlider("setColors")
     .setPosition(uiStartX + 80, uiStartY + decYcolorLimit)
     .setSize(50, 10)
     .setRange(2, 32)
     .setLabel("colors")
     .setValue(8);
     
    // == OVERLAY
    List listOverlayModes = Arrays.asList("No Overlay", "Add overlay", "Multiplay overlay", "Overlay overlay ;)", "Screen overlay");
    ctrlDropdownOverlay = controlP5.addScrollableList("setOverlayMode")
     .setPosition(uiStartX, uiStartY + decYoverlay - 5)
     .setSize(90, 120)
     .setBarHeight(20)
     .setItemHeight(20)
     .setLabel("Overlay")
     .addItems(listOverlayModes)
     .setOpen(false);
    ctrlColorPickerOverlay = controlP5.addColorPicker("setOverlayColor")
      .setPosition(uiStartX + 100, uiStartY + decYoverlay - 5)
      .setWidth(leftMenuWidth - uiStartX - 110)
      .setColorValue(color(255, 0, 255))
      .setLabel("Choisis une couleur");
    controlP5.getController("setOverlayColor-red").setSize(leftMenuWidth - uiStartX - 110, 10);   // largeur 200px, hauteur 10px
    controlP5.getController("setOverlayColor-green").setSize(leftMenuWidth - uiStartX - 110, 10);
    controlP5.getController("setOverlayColor-blue").setSize(leftMenuWidth - uiStartX - 110, 10);
    controlP5.getController("setOverlayColor-alpha").setSize(leftMenuWidth - uiStartX - 110, 10);
    /*
    ctrlSlideOverlay = controlP5.addSlider("setOverlayOpacity")
     .setPosition(uiStartX, uiStartY + decYoverlayOpacity)
     .setSize(sliderDefaultWidth, 10)
     .setRange(0, 100)
     .setLabel("Overlay opacity")
     .setValue(50);
    */
    
    // == GRAYSCALE
    ctrlToggleGrayscale = controlP5.addToggle("setGrayscale")
     .setPosition(uiStartX, uiStartY + decYgrayscale)
     .setSize(10, 10)
     .setValue(false)
     .setLabel("");
    ctrlLabelGrayscale = controlP5.addTextlabel("labelGrayscale")
     .setText("GRAYSCALE")
     .setPosition(uiStartX + 14, uiStartY + decYgrayscale);
    
    // == SCANLINES
    ctrlSlideScanlineOpacity = controlP5.addSlider("setScanlineOpacity")
     .setPosition(uiStartX, uiStartY + decYscanlineOpacity)
     .setSize(sliderDefaultWidth, 10)
     .setRange(0, 100)
     .setLabel("Scanlines opacity")
     .setValue(50);
    
    ctrlToggleScanline = controlP5.addToggle("setScanline")
     .setPosition(uiStartX, uiStartY + decYscanline)
     .setSize(10, 10)
     .setValue(false)
     .setLabel("");
    ctrlLabelScanline = controlP5.addTextlabel("labelScanline")
     .setText("SCANLINES")
     .setPosition(uiStartX + 14, uiStartY + decYscanline);

    List listScanlines = Arrays.asList(scanlinesNames);
    ctrlDropdownScanline = controlP5.addScrollableList("setScanlineType")
     .setPosition(uiStartX + 80, uiStartY + decYscanline - 5)
     .setSize(leftMenuWidth - (uiStartX * 2) - 80, 100)
     .setBarHeight(20)
     .setItemHeight(20)
     .setLabel("Scanline types")
     .addItems(listScanlines)
     .setOpen(false);
     
    // == DITHERING
    ctrlToggleDithering = controlP5.addToggle("setDithering")
     .setPosition(uiStartX, uiStartY + decYdithering)
     .setSize(10, 10)
     .setValue(false)
     .setLabel("");
    ctrlLabelDithering = controlP5.addTextlabel("labelDithering")
     .setText("DITHERING")
     .setPosition(uiStartX + 14, uiStartY + decYdithering);
    
    // == GLOW
    ctrlToggleGlow = controlP5.addToggle("setGlow")
     .setPosition(uiStartX, uiStartY + decYglow)
     .setSize(10, 10)
     .setValue(false)
     .setLabel("");
    ctrlLabelGlow = controlP5.addTextlabel("labelGlow")
     .setText("GLOW")
     .setPosition(uiStartX + 14, uiStartY + decYglow);
     
    // == DITHERING NOISE
    ctrlSlideDitheringNoise = controlP5.addSlider("setDitheringNoise")
     .setPosition(uiStartX, uiStartY + decYditheringNoise)
     .setSize(sliderDefaultWidth, 10)
     .setRange(.0, 50)
     .setLabel("Dithering noise")
     .setValue(0);
     
    List listDithering = Arrays.asList(ditheringNames);
    ctrlDropdownDithering = controlP5.addScrollableList("setDitheringType")
     .setPosition(uiStartX + 80, uiStartY + decYdithering - 5)
     .setSize(leftMenuWidth - (uiStartX * 2) - 80, 100)
     .setBarHeight(20)
     .setItemHeight(20)
     .setLabel("Dithering type")
     .addItems(listDithering)
     .setOpen(false);
     
    // == CUSTOM PALETTE
    // == palette should be displayed after dithering (for z position)
    ctrlToggleCustomPalette = controlP5.addToggle("setCustomPalette")
     .setPosition(uiStartX, uiStartY + decYcustomPalette)
     .setSize(10, 10)
     .setValue(false)
     .setLabel("");
    ctrlLabelCustomPalette = controlP5.addTextlabel("labelCustomPalette")
     .setText("PALETTE")
     .setPosition(uiStartX + 14, uiStartY + decYcustomPalette);

    List listPalette = Arrays.asList(palettesNames);
    ctrlDropdownPalette = controlP5.addScrollableList("setPalette")
     .setPosition(uiStartX + 80, uiStartY + decYcustomPalette - 5)
     .setSize(leftMenuWidth - (uiStartX * 2) - 80, 200)
     .setBarHeight(20)
     .setItemHeight(20)
     .setLabel("Palettes")
     .addItems(listPalette)
     .setOpen(false);
    
    // == PIXEL ZOOM FACTOR FOR EXPORT
    ctrlSlidePixelOutput = controlP5.addSlider("setPixelizeOut")
     .setPosition(uiStartX, height - bottomDec - 30)
     .setSize(sliderDefaultWidth - 20, 10)
     .setRange(0, 20)
     .setScrollSensitivity(2)
     .setCaptionLabel("Pixel zoom factor")
     .setValue(defaultPixelSize);
    
    // == EXPORT BUTTON
    ctrlButtonSave = controlP5.addButton("saveImageButton")
      .setPosition(uiStartX, height - bottomDec)
      .setSize(leftMenuWidth - (uiStartX * 2), 20)
      .setCaptionLabel("Save render")
      .setColorCaptionLabel(color(255, 255, 0));
      
    ctrlLabelImagePath = controlP5.addTextlabel("labelImagePath")
     .setText("Start bu selecting an image to process")
     .setSize(leftMenuWidth - (uiStartX * 2), 10)
     .setWidth(leftMenuWidth - (uiStartX * 2))
     .setPosition(uiStartX, uiStartY + 25);
     
    controlP5.addButton("debug")
      .setPosition(uiStartX, height - bottomDec - 70)
      .setSize(leftMenuWidth - (uiStartX * 2), 20)
      .setCaptionLabel("DEBUG")
      .setColorCaptionLabel(color(255, 255, 0));  
  }
  
  void setOriginalImage(PImage _img) {
     originalImage = _img.copy();
     float _ratio = float(leftMenuWidth - (uiStartX * 2)) / (float)originalImage.pixelWidth;
     if (originalImage.pixelHeight * _ratio > maxOriginalHeight)
       _ratio = (float)maxOriginalHeight / (float)originalImage.pixelHeight;
     originalImage.resize(floor(originalImage.pixelWidth * _ratio), floor(originalImage.pixelHeight * _ratio));
     this.updateUI();
  }
  
  void setImagePath(String _imagePath) {
     ctrlLabelImagePath.setValueLabel(_imagePath);
  }
  
  void updatePalette() {
    if (render.pixelsArray.isEmpty())
      return;
      
    // == Either color limitation or custom palette
    if (render.colorLimit) {
      this.palette = kMeansQuantize(render.pixelsArray, render.colors, 16);
      return;
    }
    
    // == Custom palette
    if (render.customPalette) {
      this.palette = palettesArray[render.paletteInd].clone();
    }
  }
  
  void updateUI() {
    
    // == Too early call to updateUI (while building UI, no need to call)
    // == TODO : mettre dans un arraylist composants et tous les tester ou mettre un flag boolean sur setupUIfinished
    if (ctrlSlideColors == null || ctrlToggleGrayscale == null || ctrlToggleCustomPalette == null)
      return;
    
    int oImgHeight = 0;
    
    if (originalImage != null)
      oImgHeight = originalImage.height;
     
     int _nbColors = (this.palette == null ? 0 : this.palette.length);
     int _nbPaletteLines = 0, _decYpalette = 0, _decYpaletteCustom = 0;
     if (ctrlToggleColorLimit.getState() == false && ctrlToggleCustomPalette.getState() == false)
       _nbColors = 0;
     if (_nbColors > 0) {
       _nbPaletteLines = floor((_nbColors - 1) / 8) + 1;
       if (render.colorLimit)
         _decYpalette = colorPaletteSquareSize * _nbPaletteLines;
       else 
         _decYpaletteCustom = colorPaletteSquareSize * _nbPaletteLines;
     }
       
     ctrlSlidePixelize.setPosition(ctrlSlidePixelize.getPosition()[0], uiStartY + oImgHeight + decYpixelize);
     ctrlSlideBrightness.setPosition(ctrlSlideBrightness.getPosition()[0], uiStartY + oImgHeight + decYbrightness);
     ctrlSlideContrast.setPosition(ctrlSlideContrast.getPosition()[0], uiStartY + oImgHeight + decYcontrast);
     ctrlSlideGamma.setPosition(ctrlSlideGamma.getPosition()[0], uiStartY + oImgHeight + decYgamma);
     ctrlToggleColorLimit.setPosition(ctrlToggleColorLimit.getPosition()[0], uiStartY + oImgHeight + decYcolorLimit);
     ctrlLabelColorLimit.setPosition(ctrlLabelColorLimit.getPosition()[0], uiStartY + oImgHeight + decYcolorLimit);    
     ctrlSlideColors.setPosition(ctrlSlideColors.getPosition()[0], uiStartY + oImgHeight + decYcolorLimit);
     
     ctrlToggleCustomPalette.setPosition(ctrlToggleCustomPalette.getPosition()[0], uiStartY + oImgHeight + decYcustomPalette + _decYpalette);
     ctrlLabelCustomPalette.setPosition(ctrlLabelCustomPalette.getPosition()[0], uiStartY + oImgHeight + decYcustomPalette + _decYpalette);
     ctrlDropdownPalette.setPosition(ctrlDropdownPalette.getPosition()[0], uiStartY + oImgHeight + decYcustomPalette - 5 + _decYpalette);
     
     ctrlToggleScanline.setPosition(ctrlToggleScanline.getPosition()[0], uiStartY + oImgHeight + decYscanline + _decYpalette + _decYpaletteCustom);
     ctrlLabelScanline.setPosition(ctrlLabelScanline.getPosition()[0], uiStartY + oImgHeight + decYscanline + _decYpalette + _decYpaletteCustom);
     ctrlDropdownScanline.setPosition(ctrlDropdownScanline.getPosition()[0], uiStartY + oImgHeight + decYscanline - 5 + _decYpalette + _decYpaletteCustom);
     ctrlSlideScanlineOpacity.setPosition(ctrlSlideScanlineOpacity.getPosition()[0], uiStartY + oImgHeight + decYscanlineOpacity + _decYpalette + _decYpaletteCustom);
     
     ctrlToggleGrayscale.setPosition(ctrlToggleGrayscale.getPosition()[0], uiStartY + oImgHeight + decYgrayscale + _decYpalette + _decYpaletteCustom);
     ctrlToggleDithering.setPosition(ctrlToggleDithering.getPosition()[0], uiStartY + oImgHeight + decYdithering + _decYpalette + _decYpaletteCustom);
     ctrlDropdownDithering.setPosition(ctrlDropdownDithering.getPosition()[0], uiStartY + oImgHeight + decYdithering - 5 + _decYpalette + _decYpaletteCustom);
     ctrlSlideDitheringNoise.setPosition(ctrlSlideDitheringNoise.getPosition()[0], uiStartY + oImgHeight + decYditheringNoise + _decYpalette + _decYpaletteCustom);
     ctrlLabelDithering.setPosition(ctrlLabelDithering.getPosition()[0], uiStartY + oImgHeight + decYdithering + _decYpalette + _decYpaletteCustom);
     ctrlLabelGrayscale.setPosition(ctrlLabelGrayscale.getPosition()[0], uiStartY + oImgHeight + decYgrayscale + _decYpalette + _decYpaletteCustom);
     
     ctrlDropdownOverlay.setPosition(ctrlDropdownOverlay.getPosition()[0], uiStartY + oImgHeight + decYoverlay + _decYpalette + _decYpaletteCustom);
     ctrlColorPickerOverlay.setPosition(ctrlColorPickerOverlay.getPosition()[0], uiStartY + oImgHeight + decYoverlay + _decYpalette + _decYpaletteCustom);
     //ctrlSlideOverlay.setPosition(ctrlSlideOverlay.getPosition()[0], uiStartY + oImgHeight + decYoverlayOpacity + _decYpalette + _decYpaletteCustom);
     
     ctrlToggleGlow.setPosition(ctrlToggleGlow.getPosition()[0], uiStartY + oImgHeight + decYglow + _decYpalette + _decYpaletteCustom);
     ctrlLabelGlow.setPosition(ctrlLabelGlow.getPosition()[0], uiStartY + oImgHeight + decYglow + _decYpalette + _decYpaletteCustom);
     
     this.draw();
  }
  
  void draw() {
    fill(color(22, 22, 42));
    noStroke();
    rect(0, 0, leftMenuWidth, height);
    if (originalImage != null)
      if (originalImage.width < leftMenuWidth) // to be sure resize has been done, otherwise it could be shown fullsize for a split second
        image(originalImage, uiStartX, logoTool.height + 44);
   
    // == PALETTE
    // TODO : attention dans le timing des call on peut avoir le toggle qui call l'update ui et qui call le draw avant d'avoir build la palette...
    if ((ctrlToggleColorLimit.getState() || ctrlToggleCustomPalette.getState()) && palette != null) {
      int oImgHeight = 0;
      if (originalImage != null)
        oImgHeight = originalImage.height;
      int startPaletteY;
      if (render.colorLimit)
        startPaletteY = uiStartY + oImgHeight + decYcolorLimit + 18;
      else
        startPaletteY = uiStartY + oImgHeight + decYcustomPalette + 18;
      int _nbColors = palette.length;
      for (int _i = 0; _i < _nbColors; _i++) {
         fill(palette[_i]);
         stroke(255, 255, 255);
         rect(uiStartX + ((_i % 8) * colorPaletteSquareSize), startPaletteY + (floor(_i / 8) * colorPaletteSquareSize), colorPaletteSquareSize, colorPaletteSquareSize);  
       }
    }
    image(logoTool, 0, 10);
    controlP5.draw();
  }
}

public void mainImageButton() {
  selectInput("Select an image as main image to render:", "mainImageSelected");
}

public void saveImageButton() {
  println("Start SAVE");
  render.saveRenderImage();
  println("End SAVE");
}

void mainImageSelected(File _selection) {
  if (_selection == null) {
    println("Window was closed or the user hit cancel.");
  }
  else {
    println("User selected " + _selection.getAbsolutePath());
    render.addRenderImage(_selection.getAbsolutePath());
  }
}
