class Point {
  float r;
  float g;
  float b;
  int myCentroidIndex;

  Point(float _r, float _g, float _b) {
    r = _r;
    g = _g;
    b = _b;
  }

  void display(int _x, int _y) {
    color col = color(centroids[myCentroidIndex].r, centroids[myCentroidIndex].g, centroids[myCentroidIndex].b);
    stroke(col);
    point(_x, _y);
  }
}
