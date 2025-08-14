float distRGB(color c1, color c2) {
  float r = abs(red(c1) - red(c2));
  float g = abs(green(c1) - green(c2));
  float b = abs(blue(c1) - blue(c2));
  return sqrt((r * r) + (g * g) + (b * b));  
}

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
