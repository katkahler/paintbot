


class Column {
  ArrayList<Voxel> voxels = new ArrayList<Voxel>();
  int xPos;

  Column (int _xpos, color[] _myColors) {
    xPos = _xpos;
  
    for (int colorIndex = 0; colorIndex < _myColors.length; colorIndex++) {
      voxels.add(new Voxel(_myColors[colorIndex]));
    }
  }

  void displayColumn() {
    int pixelsDisplayed = 0;
    for (Voxel v : voxels){
      stroke(v.c);
      fill(v.c);
      square(xPos * voxelSize, pixelsDisplayed * voxelSize, voxelSize);
      pixelsDisplayed++;
    }
  }
}
