import processing.video.*;

int radius = 100000;
int row = 0;
int column = 0;

int dark = int(random(0, 100));
int light = int(random(100, 255));

color c1 = color(dark, dark, dark);
color c2 = color(light, light, light);

//int startH = 100;

Capture camera;

//brightness = grayscale of 0 to 255
//int threshold = 20;

void setup() {
  size(1280, 700);

  String[] cameras = Capture.list();
  //println(cameras);  

  if (cameras.length == 0) {
    println("No cameras");
    exit();
  } else {
    println("Available Cameras: ");
    //println(cameras);
  }

  camera = new Capture(this, cameras[0]);
  camera.start();
}

void draw() {
  
  int k = height/2;
  int h = width/2;
  int threshhold = 255/2;
  
  if (camera.available()) {
    randomSeed(1);
    camera.read();

    //make a copy of the PImage - same size as original
    //output = createImage(camera.width, camera.height, RGB);
    
    //draw an ellipse in the center of the screen
    ellipse(k, h, radius, radius);

   
    
    //for (int x = 0; x < width; x++) {
    //    for (int y = 0; y < height; y++) {
    //      int index = x + y*width;
    //      if (brightness(unsorted[index]) < threshhold){
    //        //negative[index] = color(0,0,0);
    //        start = index;
    //      } else { 
    //        negative[index] = color(255, 255, 255);
    //      }
    //    }
    //}
    
    color[] copy = new color[camera.pixels.length];
    copy = sort(camera.pixels);
    
    
    //equation of circle
    //(x – h)^2 + (y – k)^2 = r2
    // (h, k) is center point of circle
    
    for( int i = 0; i < camera.pixels.length; i++){
      
      // get the brightness of the current pixel (the red value)
      float bright = camera.pixels[i] >> 16 & 0xFF;
      
      // lerpColor wants values 0-1, so divide by 255
      bright /= 255.0;
      
      // create a new color for the pixel that's somewhere between
      // the two colors we specified
      color newColor = lerpColor(c1, c2, bright);
    
      // set the current pixel
      camera.pixels[i] = newColor;
      
    }


    //iterate through screen 
    //https://stackoverflow.com/questions/14487322/get-all-pixel-array-inside-circle
    for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
            int index = x + y * width;
            double dx = x - h;
            double dy = y - k;
            double distanceSquared = dx * dx + dy * dy;
    
            if (distanceSquared <= (radius^2)){
                camera.pixels[index] = copy[index];
            }
        
       //color[] sorted = new color[int(3.14*(radius^2))];
       //sorted = sort(circle);
   
       //for (int i = 0; i < circle.length; i++) {
       //  camera.pixels[x + (y+i) * width] = sorted[i];
       //}
     }
   }

    camera.loadPixels();

  
    camera.updatePixels();
    image(camera, 0, 0);
  }
}

      
      