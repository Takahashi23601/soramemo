class Point {
  float x, y;
  float weight = 25;

  Point (float x, float y) {
    this.x = x;
    this.y = y;
  }

  void rend() {
    strokeWeight(weight);
    point(x, y);
  }
}

class PointManager {
  Point[] point;
  final int MAX_POINTS = 50000;

  PointManager() {
    point = new Point[MAX_POINTS];
    for (int i = 0; i < MAX_POINTS; i++) {
      if (point[i] != null) {
        point[i] = null;
      }
    }
  }

  void makePoint(float x, float y) {
    for (int i = 0; i < MAX_POINTS; i++) {
      if (point[i] == null) {
        point[i] = new Point(x, y);
        break;
      }
    }
  }

  void rend() {
    for (int i = 0; i < MAX_POINTS; i++) {
      if (point[i] == null) {
        break;
      }
      point[i].rend();
    }
  }

  void reset() {
    for (int i = 0; i < MAX_POINTS; i++) {
      if (point[i] == null) {
        break;
      }
      point[i] = null;
    }
  }
}
