PImage img;
int pointCount = 100;
int centCount = 5;
int voxelSize = 20;

int xMax, yMax;

ArrayList<Column> columns;
Point[] centroids = new Point[centCount];  // ARRAY of rgb triplets
Point[][] points2d = new Point[500][500];  // CONTAINS indices into centroids[] array
int[][] pbn;



void setup() {
  frameRate(1);
  size(500, 500);

  xMax = width/voxelSize;
  yMax = height/voxelSize;
  pbn = new int[xMax][yMax];

  img = loadImage("birb.jpg");
  img.resize(500, 0);

  for (int x = 0; x < 500; x++) { //creating the points
    for (int y = 0; y < 500; y++) {
      points2d[x][y] = new Point(red(img.get(x, y)), green(img.get(x, y)), blue(img.get(x, y)));
    }
  }

  for (int ce = 0; ce < centroids.length; ce++) { //creating the centroids
    color imgget = img.get(round(random(0, 500)), round(random(0, 500)));
    centroids[ce] = new Point(red(imgget), green(imgget), blue(imgget));
  }

  assign(); //initially assigning points to centroids
  noLoop();
}

void draw() {

  // pure display
  for (int x = 0; x < 500; x++) {
    for (int y = 0; y < 500; y++) {
      points2d[x][y].display(x, y);
    }
  }
  
  //APPLYING K-MEANS
  boolean changed = true;
  while (changed) {
    for (int cent = 0; cent < centroids.length; cent++) {  // recalculate centroid means
      findMeans();
    }
    changed = assign(); //reassign points to centroids
  }


  //VOXELIZING
  columns = new ArrayList<Column>();
  int numRows = width / voxelSize;
  int numColumns = height / voxelSize;

  for (int x = 0; x < numColumns; x++) {
    color[] voxelList = new color[numRows];
    for (int y = 0; y < numRows; y++) {
      int centroid = points2d[x * voxelSize][y * voxelSize].myCentroidIndex;
      color c = color(centroids[centroid].r, centroids[centroid].g, centroids[centroid].b);
      voxelList[y] = c;
    }
    Column c = new Column(x, voxelList);
    columns.add(c);
  }

  for (Column c : columns) {
    c.displayColumn(); //draw the columns of voxels
  }

  //building pbn
  PBN();
}

boolean assign() {
  boolean changed = false;
  for (int x = 0; x < 500; x++) {
    for (int y = 0; y <500; y++) {
      int oldCentroid = points2d[x][y].myCentroidIndex;
      float id = 1000000;
      for (int c = 0; c < centroids.length; c++) {
        float d = dist(points2d[x][y].r, points2d[x][y].g, points2d[x][y].b, centroids[c].r, centroids[c].g, centroids[c].b);
        if (d < id) {
          points2d[x][y].myCentroidIndex = c;
          id = dist(points2d[x][y].r, points2d[x][y].g, points2d[x][y].b, centroids[c].r, centroids[c].g, centroids[c].b);
        }
      }
      if (points2d[x][y].myCentroidIndex != oldCentroid)
        changed = true;
    }
  }
  return changed;
}

void findMeans() {
  float sumR[] = new float[centCount];
  float sumG[] = new float[centCount];
  float sumB[] = new float[centCount];
  float total[] = new float[centCount];

  for (int x = 0; x < 500; x++) {
    for (int y = 0; y < 500; y++) {
      Point pgp = points2d[x][y];
      sumR[pgp.myCentroidIndex] += pgp.r;
      sumG[pgp.myCentroidIndex] += pgp.g;
      sumB[pgp.myCentroidIndex] += pgp.b;
      total[pgp.myCentroidIndex] += 1;
    }
  }

  for (int c = 0; c < centroids.length; c++) {
    centroids[c].r = sumR[c] / total[c];
    centroids[c].g = sumG[c] / total[c];
    centroids[c].b = sumB[c] / total[c];
  }
}

void PBN() {
  int colCount = 0;
  HashMap<Integer, Integer> hm = new HashMap<Integer, Integer>();

  //for each voxel, making the HashMap
  for (int x = 0; x < xMax; x++) {
    for (int y = 0; y < yMax; y++) {
      
      // nothing about what's on the screen is reliable
      // find color of underlying point's CENTROID
      int centroid = points2d[x * voxelSize][y * voxelSize].myCentroidIndex;
      color c = color(centroids[centroid].r, centroids[centroid].g, centroids[centroid].b);
      
      if (!hm.containsKey(c)) {
        hm.put(c, colCount);
        colCount++;
      }
      pbn[x][y] = hm.get(c);
    }
  }

  for (int y = 0; y < pbn.length; y++) {
    for (int x = 0; x < pbn[0].length; x++) {
      //if (frameCount > 5 && colCount == centCount) {
        print(pbn[x][y] + " ");
      //}
    }
    println();
  }
  println();
}
