# paintbot
Using k-means to create a paint-by-number visual and table of integers to later use for a robot that creates art with a paintball gun.


A Point consists of an RGB triplet, and each centroid is just a Point in an array. In setup, the first Points are made as a 2D array. The array of centroids is created with its own color as well at random.

The function assign holds and returns a boolean to assign a point to a centroid based on distance in the color space (the distance between the point in the 2d array's r, g, and b coordinates in the color space and the rgb coordinates of each color centroid. This function happens in setup to initially assign points to the newly created centroids. 

As draw occurs, the array of points is displayed with every point's color corresponding to their position on the image. 
Then, k-means is applied: 
Finding the means relies on the sums of the red values, green values, and blue values of each point based on their centroid, then averages them out to find the means. 

This would occur normally by resetting the pixels on an image, but I wanted this to work for a robot that would be painting very low-resolution recreations of these images colored by the algorithm. 

To do this, I had to be able to change the resolution to any level I wanted. 
To make a lower-resolution image without changing the image is simple. There are width or height/voxelSize (xMax, yMax) Voxels on this square resized image. In draw, an array of Voxel colors, creates a new column, and they are displayed as well. 

