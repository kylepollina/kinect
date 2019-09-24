import org.openkinect.processing.*;

Kinect kinect;
PGraphics canvas;
int minThreshold;
int maxThreshold;

void setup() {
    size(640, 480);
    kinect = new Kinect(this);

    minThreshold = 0;
    maxThreshold = 700;

    kinect.initDepth();
    kinect.enableMirror(true);
    canvas = createGraphics(kinect.width, kinect.height);
    colorMode(HSB, 100);
}

void draw() {
    background(0);

    depth();
}

void depth() {
    kinect.enableColorDepth(false);
    int[] rawDepth = kinect.getRawDepth();

    canvas.beginDraw();
    canvas.loadPixels();

    for(int x = 0; x < kinect.width; x++) {
        for(int y = 0; y < kinect.height; y++) {
            int index = x + y * kinect.width;
            int depth = rawDepth[index];

            color col = canvas.pixels[index];
            canvas.pixels[index] = color(hue(col), saturation(col), brightness(col) - 1);

            if(minThreshold < depth && depth < maxThreshold) {
                canvas.pixels[index] = color(frameCount/2 % 100, 100, 100);
            }
        }
    }

    canvas.updatePixels();
    canvas.endDraw();
    image(canvas, 0, 0);
}

void keyPressed() {
    if(keyCode == 32) {
        canvas.clear();
    }
}

