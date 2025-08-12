float distRGB(color c1, color c2) {
  float r = abs(red(c1) - red(c2));
  float g = abs(green(c1) - green(c2));
  float b = abs(blue(c1) - blue(c2));
  return sqrt((r * r) + (g * g) + (b * b));  
}
/*
float distHSL(color c1, color c2) {
  float h1 = hue(c1);
  float h2 = hue(c2);
  float s1 = saturation(c1);
  float s2 = saturation(c2);
  float b1 = brightness(c1);
  float b2 = brightness(c2);

  float dh = abs(h1 - h2);
  if (dh > 180) dh = 360 - dh; // cercle chromatique

  return dh * 0.6 + abs(s1 - s2) * 0.3 + abs(b1 - b2) * 0.1;
}


float distRGBclever(color c1, color c2) {
  float r1 = red(c1);
  float r2 = red(c2);
  float g1 = green(c1);
  float g2 = green(c2);
  float b1 = blue(c1);
  float b2 = blue(c2);
  
  float r = abs(r1 - r2);
  float g = abs(g1 - g2);
  float b = abs(b1 - b2);
  
  float dist = sqrt((r * r) + (g * g) + (b * b));
  
  float stdev1 = ecartTypeRGB(r1, g1, b1);
  float stdev2 = ecartTypeRGB(r2, g2, b2);
  //float stdevPenalty = constrain(abs(stdev1 - stdev2) / 40.0, 0, 1.5);
  float stdevPenalty = pow(constrain(abs(stdev1 - stdev2) / 40.0, 0, 1.5), 1.5);
  
  float h1 = hue(c1);
  float h2 = hue(c2);
  float s1 = saturation(c1);
  float s2 = saturation(c2);
  float huePenalty = 0;
  if (s1 > 10 && s2 > 10) {
    float dh = abs(h1 - h2);
    if (dh > 180) dh = 360 - dh;
    huePenalty = constrain(dh / 180.0, 0, 1.0);
  }
  
  float saturationPenalty = constrain(abs(s1 - s2) / 100.0, 0, 1.0);
  dist *= (1.0 + saturationPenalty * 1.5);

  dist *= (1.0 + stdevPenalty + huePenalty * 0.8);
  
  if ((stdev1 < 10 && stdev2 > 30) || (stdev2 < 10 && stdev1 > 30)) {
    dist *= 2.5; // ou plus si nécessaire
  }
  
  //if (abs(stdev1 - stdev2) > 20)
  //  dist *= 2.2;
  //dist *= (1 + constrain(abs(stdev1 - stdev2) / 40.0, 0, 1.5));
  
  //dist *= (1 + (abs(stdev1 - stdev2) / 2.0));
    
  return dist;  
}

float ecartTypeRGB(float r, float g, float b) {
  float mean = (r + g + b) / 3.0;
  return sqrt((sq(r - mean) + sq(g - mean) + sq(b - mean)) / 3.0);
}

// Conversion HSV → RGB
color RGBfromHSV(float h, float s, float v) {
  colorMode(HSB, 360, 100, 100);
  color c = color(h, s, v);
  colorMode(RGB, 255);
  return c;
}

float hueDiff(float h1, float h2) {
  float d = abs(h1 - h2);
  return min(d, 360 - d);
}

PVector rgbToLab(color c) {
  float r = red(c) / 255.0;
  float g = green(c) / 255.0;
  float b = blue(c) / 255.0;

  // sRGB → XYZ
  r = (r > 0.04045) ? pow((r + 0.055) / 1.055, 2.4) : r / 12.92;
  g = (g > 0.04045) ? pow((g + 0.055) / 1.055, 2.4) : g / 12.92;
  b = (b > 0.04045) ? pow((b + 0.055) / 1.055, 2.4) : b / 12.92;

  float x = (r * 0.4124 + g * 0.3576 + b * 0.1805) / 0.95047;
  float y = (r * 0.2126 + g * 0.7152 + b * 0.0722) / 1.00000;
  float z = (r * 0.0193 + g * 0.1192 + b * 0.9505) / 1.08883;

  x = (x > 0.008856) ? pow(x, 1.0/3.0) : (7.787 * x) + (16.0 / 116.0);
  y = (y > 0.008856) ? pow(y, 1.0/3.0) : (7.787 * y) + (16.0 / 116.0);
  z = (z > 0.008856) ? pow(z, 1.0/3.0) : (7.787 * z) + (16.0 / 116.0);

  float L = (116 * y) - 16;
  float A = 500 * (x - y);
  float B = 200 * (y - z);

  return new PVector(L, A, B);
}

PVector rgbToLab2(color c) {
  // Normalisation RGB
  float r = red(c) / 255.0;
  float g = green(c) / 255.0;
  float b = blue(c) / 255.0;

  // Correction gamma
  r = (r > 0.04045) ? pow((r + 0.055) / 1.055, 2.4) : r / 12.92;
  g = (g > 0.04045) ? pow((g + 0.055) / 1.055, 2.4) : g / 12.92;
  b = (b > 0.04045) ? pow((b + 0.055) / 1.055, 2.4) : b / 12.92;

  // RGB → XYZ
  float x = r * 0.4124 + g * 0.3576 + b * 0.1805;
  float y = r * 0.2126 + g * 0.7152 + b * 0.0722;
  float z = r * 0.0193 + g * 0.1192 + b * 0.9505;

  // Normalisation D65
  x /= 0.95047;
  y /= 1.00000;
  z /= 1.08883;

  // XYZ → Lab
  x = (x > 0.008856) ? pow(x, 1.0/3.0) : (7.787 * x) + (16.0 / 116.0);
  y = (y > 0.008856) ? pow(y, 1.0/3.0) : (7.787 * y) + (16.0 / 116.0);
  z = (z > 0.008856) ? pow(z, 1.0/3.0) : (7.787 * z) + (16.0 / 116.0);

  float L = (116.0 * y) - 16.0;
  float a = 500.0 * (x - y);
  float bLab = 200.0 * (y - z);

  return new PVector(L, a, bLab);
}

float distLab(color c1, color c2) {
  PVector lab1 = rgbToLab(c1);
  PVector lab2 = rgbToLab(c2);
  return dist(lab1.x, lab1.y, lab1.z, lab2.x, lab2.y, lab2.z);
}

float distLabWeighted(color c1, color c2) {
  // Convertir les couleurs RGB en Lab
  PVector lab1 = rgbToLab(c1);
  PVector lab2 = rgbToLab(c2);

  float dL = lab1.x - lab2.x;
  float da = lab1.y - lab2.y;
  float db = lab1.z - lab2.z;

  // Pondération : moins de poids sur la luminance
  return sqrt(0.5 * dL * dL + 1.5 * da * da + 1.5 * db * db);
}

class CompareX implements Comparator<PVector>
{
  //@Override
  int compare(PVector v1, PVector v2) {
    return int(v1.x - v2.x);
  }
}


// Distance HSV (Hue circulaire)
//float distHSV(PVector a, PVector b) {
//  float dh = min(abs(a.x - b.x), 360 - abs(a.x - b.x));
//  float ds = abs(a.y - b.y);
//  float dv = abs(a.z - b.z);
//  return sqrt(dh*dh + ds*ds + dv*dv);
//}


float distHSV(PVector a, PVector b) {
  float dh = min(abs(a.x - b.x), 360 - abs(a.x - b.x));
  float ds = abs(a.y - b.y);
  float dv = abs(a.z - b.z);
  float weight = 1 + (a.y + b.y) / 200.0; // plus saturé = plus sensible à la teinte
  return sqrt(weight * dh * dh + ds * ds + dv * dv);
  //return sqrt(dh*dh + 2*ds*ds + 2*dv*dv); // pondération pour favoriser les couleurs éclatantes
}

color[] kMeansQuantizeHSV(ArrayList<PVector> pixelsHSV, int k, int maxIter) {
  // Initialisation aléatoire des centres
  PVector[] centers = new PVector[k];
  Random rnd = new Random();
  for (int i = 0; i < k; i++) {
    centers[i] = pixelsHSV.get(rnd.nextInt(pixelsHSV.size())).copy();
  }

  // Boucle K-Means
  for (int iter = 0; iter < maxIter; iter++) {
    ArrayList<PVector>[] clusters = new ArrayList[k];
    for (int i = 0; i < k; i++) clusters[i] = new ArrayList<PVector>();

    // Assignation
    for (PVector pix : pixelsHSV) {
      int bestIndex = 0;
      float bestDist = distHSV(pix, centers[0]);
      for (int i = 1; i < k; i++) {
        float d = distHSV(pix, centers[i]);
        if (d < bestDist) {
          bestDist = d;
          bestIndex = i;
        }
      }
      clusters[bestIndex].add(pix);
    }

    // Mise à jour des centres
    for (int i = 0; i < k; i++) {
      if (clusters[i].isEmpty()) {
        centers[i] = pixelsHSV.get(rnd.nextInt(pixelsHSV.size())).copy();
        continue;
      }
      float sumCos = 0, sumSin = 0, sumS = 0, sumV = 0;
      for (PVector pix : clusters[i]) {
        float rad = radians(pix.x);
        sumCos += cos(rad);
        sumSin += sin(rad);
        sumS += pix.y;
        sumV += pix.z;
      }

      float avgHue = degrees(atan2(sumSin, sumCos));
      if (avgHue < 0) avgHue += 360; // Corriger les teintes négatives
      float avgS = sumS / clusters[i].size();
      float avgV = sumV / clusters[i].size();

      centers[i].set(avgHue, avgS, avgV);
    }
  }

  // Construction de la palette finale
  colorMode(HSB, 360, 100, 100);
  color[] palette = new color[k];
  for (int i = 0; i < k; i++) {
    palette[i] = color(centers[i].x, centers[i].y, centers[i].z);
  }
  colorMode(RGB, 255); // Revenir au mode RGB
  return palette;
}

// ===================

color[] kMeansQuantizeImage(PImage img, int k, int maxIter) {
  
  boolean onHSV = false;
  
  if (onHSV) 
    colorMode(HSB, 360, 100, 100);
  
  ArrayList<PVector> pixelsArrayList = new ArrayList<PVector>();
  for (int i = 0; i < img.pixels.length; i++) {
    color c = img.pixels[i];
    
    if (onHSV) {
      if (brightness(c) > 5 && saturation(c) > 5)
        pixelsArrayList.add(new PVector(hue(c), saturation(c), brightness(c))); 
    } else {
      pixelsArrayList.add(new PVector(red(c), green(c), blue(c))); 
    }
  }
  
  colorMode(RGB, 255);
  
  if (onHSV)
    return kMeansQuantizeHSV(pixelsArrayList, k, maxIter);

  return kMeansQuantize(pixelsArrayList, k, maxIter);
}
*/


/*
color[] kMeansQuantizeHSV(ArrayList<PVector> pixelsHSV, int k, int maxIter) {

  PVector[] centers = new PVector[k];
  float hueSpacing = 360.0 / float(k);
  
  // == Setup centers for clustering
  float bestDiff;
  for (int i = 0; i < k; i++) {
    bestDiff = -1;
    centers[i] = new PVector(0, 0, 0);
    for (PVector hsv : pixelsHSV) {
      if (bestDiff == -1 || hueDiff(hsv.x, (i * hueSpacing)) < bestDiff) {
        bestDiff = abs(hsv.x - (i * hueSpacing));
        centers[i].x = hsv.x;
        centers[i].y = hsv.y;
        centers[i].z = hsv.z;
      }
    }
  }
  
  // == Converge values to centers
  while (maxIter-- > 0) {
    ArrayList<PVector>[] clusters = new ArrayList[k];
    for (int j = 0; j < k; j++)
      clusters[j] = new ArrayList<PVector>();
    // == We put each pickels in their right clusters (from the nearest center)
    for (PVector hsv : pixelsHSV) {
      int bestCenterIndex = -1;
      float bestHSVdiff = -1;
      float curHSVidff;
      for (int j = 0; j < k; j++) {
        curHSVidff = abs(distHSV(centers[j], hsv));
        if (bestHSVdiff == -1 || (curHSVidff < bestHSVdiff)) {
          bestHSVdiff = curHSVidff;
          bestCenterIndex = j;
        }
      }
      clusters[bestCenterIndex].add(new PVector(hsv.x, hsv.y, hsv.z));
    }
    
    // == Each pixel is in their cluster, we sum up each cluster to refresh the clusters centers
    for (int j = 0; j < k; j++) {
      if (clusters[j].size() == 0)
        continue;
      float sumCosH = 0, sumSinH = 0, sumS = 0, sumV = 0;
      for (PVector pix : clusters[j]) {
         float rad = radians(pix.x);
         sumCosH += cos(rad);
         sumSinH += sin(rad);
         sumS += pix.y;
         sumV += pix.z;
      }
      centers[j].x = degrees(atan2(sumSinH / clusters[j].size(), sumCosH / clusters[j].size()));
      centers[j].y = sumS / clusters[j].size();
      centers[j].z = sumV / clusters[j].size();
    }
    
    for (int j = 0; j < 3; j++)
      println(maxIter + " => Clusters[s][" + j + "] = " + clusters[0].get(j));
  }
  
  for (int j = 0; j < k; j++)
    println("centers[" + j + "] = (" + centers[j].x + ", " + centers[j].y + ", " + centers[j].z + ")");
  
  Arrays.sort(centers, new CompareX());
  
  color[] pal = new color[k];
  for (int j = 0; j < k; j++)
    pal[j] = RGBfromHSV(centers[j].x, centers[j].y, centers[j].z);
  return pal;
}
*/

color[] kMeansQuantize(ArrayList<PVector> pixelsRGB, int k, int maxIter) {
  PVector[] centers = new PVector[k];
  Random rnd = new Random();
  
  // == Init centers
  for (int i = 0; i < k; i++)
    centers[i] = pixelsRGB.get(rnd.nextInt(pixelsRGB.size())).copy();

  // == Iteration "kmeans"
  while (maxIter-- > 0) {
    ArrayList<PVector>[] clusters = new ArrayList[k];
    for (int i = 0; i < k; i++) clusters[i] = new ArrayList<PVector>();

    for (PVector pix : pixelsRGB) {
      int bestI = 0;
      float bestD = Float.MAX_VALUE;
      for (int i = 0; i < k; i++) {
        float d = PVector.dist(pix, centers[i]);
        if (d < bestD) {
          bestD = d;
          bestI = i;
        }
      }
      clusters[bestI].add(pix);
    }

    // == Update centers
    boolean changed = false;
    for (int i = 0; i < k; i++) {
      ArrayList<PVector> cluster = clusters[i];
      if (cluster.isEmpty()) {
        centers[i] = pixelsRGB.get(rnd.nextInt(pixelsRGB.size())).copy();
        continue;
      }
      PVector mean = new PVector();
      for (PVector p : cluster) 
        mean.add(p);
      mean.div(cluster.size());
      if (!mean.equals(centers[i])) {
        centers[i] = mean;
        changed = true;
      }
    }
    if (!changed) break;
  }

  // == Final palette
  color[] pal = new color[k];
  for (int i = 0; i < k; i++) {
    pal[i] = color(centers[i].x, centers[i].y, centers[i].z);
  }
  
  return pal;
}
