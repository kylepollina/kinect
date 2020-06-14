import org.openkinect.processing.*;

Kinect kinect;

void setup() {
    // Kinect camera is 640x480
    size(640, 480);
    /* fullScreen(); */
    kinect = new Kinect(this);

    kinect.initDepth();
    kinect.initVideo();
}

void draw() {
    background(0);

    depth();
    /* depthColor(); */
    /* infrared(); */
    /* RGB(); */
}

void depth() {
    kinect.enableColorDepth(false);
    PImage depth = kinect.getDepthImage();
    int[] rawDepth = kinect.getRawDepth();
    image(depth, 0, 0, width, height);
}

void depthColor() {
    kinect.enableColorDepth(true);
    PImage depth = kinect.getDepthImage();
    int[] rawDepth = kinect.getRawDepth();
    image(depth, 0, 0);
}

void infrared() {
    kinect.enableIR(true);
    PImage infrared = kinect.getVideoImage();
    image(infrared, 0, 0);
}

void RGB() {
    kinect.enableIR(false);
    PImage video = kinect.getVideoImage();
    image(video, 0, 0);
}

