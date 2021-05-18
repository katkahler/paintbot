PImage img;
int pointCount = 100;
int centCount = 2;
int voxelSize = 20;

int xMax, yMax;

ArrayList<Column> columns;
Point[] centroids = new Point[centCount];
Point[][] points2d = new Point[500][500];
int[][] pbn;



void setup() {
  frameRate(1);
  size(500, 500);

  xMax = width/voxelSize;
  yMax = height/voxelSize;
  pbn = new int[xMax][yMax];

  img = loadImage("armin.jpg");
  img.resize(500, 0);

  for (int x = 0; x < 500; x++) { //creating the points
    for (int y = 0; y < 500; y++) {
      points2d[x][y] = new Point(red(img.get(x, y)), green(img.get(x, y)), blue(img.get(x, y)));
    }
  }

  for (int ce = 0; ce < centroids.length; ce++) { //creating the centroids
    int imgget = img.get(round(random(0, 500)), round(random(0, 500)));
    centroids[ce] = new Point(red(imgget), green(imgget), blue(imgget));
  }

  assign(); //initially assigning points to centroids
}

void draw() {

  //APPLYING K-MEANS
  for (int x = 0; x < 500; x++) {
    for (int y = 0; y < 500; y++) {
      points2d[x][y].display(x, y);
    }
  }

  for (int cent = 0; cent < centroids.length; cent++) {
    findMeans();
  }
  assign(); //reassign points to centroids


  //VOXELIZING
  columns = new ArrayList<Column>();
  int numRows = width / voxelSize;
  int numColumns = height / voxelSize;

  for (int x = 0; x < numColumns; x++) {
    color[] voxelList = new color[numRows];
    for (int y = 0; y < numRows; y++) {
      color voxelColor = get(x * voxelSize, y * voxelSize);
      voxelList[y] = voxelColor;
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

void assign() {
  for (int x = 0; x < 500; x++) {
    for (int y = 0; y <500; y++) {
      float id = 1000000;
      for (int c = 0; c < centroids.length; c++) {
        float d = dist(points2d[x][y].r, points2d[x][y].g, points2d[x][y].b, centroids[c].r, centroids[c].g, centroids[c].b);
        if (d < id) {
          points2d[x][y].myCentroidIndex = c;
          id = dist(points2d[x][y].r, points2d[x][y].g, points2d[x][y].b, centroids[c].r, centroids[c].g, centroids[c].b);
        }
      }
    }
  }
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
      
      color c = get(x * voxelSize, y * voxelSize);
      
      if (!hm.containsKey(c)) {
        colCount++;
        hm.put(c, colCount);
      }
      pbn[x][y] = hm.get(c);
    }
  }

  for (int y = 0; y < pbn.length; y++) {
    for (int x = 0; x < pbn[0].length; x++) {
      if (frameCount > 5 && colCount == centCount) {
        print(pbn[x][y] + " ");
      }
      else{
        println(colCount);
      }
    }
    println();
  }
  println();
}
