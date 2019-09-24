import java.util.ArrayList;
import org.openkinect.processing.*;

Kinect kinect;
ArrayList<Flag> flags;
Cursor cursor;
boolean showPosition = false;

void setup() {
    // Kinect camera is 640x480
    size(640, 480);
    kinect = new Kinect(this);

    flags = new ArrayList<Flag>();
    cursor = new Cursor();

    kinect.initDepth();
}

void draw() {
    background(0);

    drawDepthImage();
    drawFlags();
    cursor.show();
}

void drawDepthImage() {
    kinect.enableColorDepth(false);
    PImage depth = kinect.getDepthImage();
    image(depth, 0, 0, width, height);
}

void drawFlags() {
    for(int i = 0; i < flags.size(); i++) {
        Flag flag = flags.get(i);
        flag.show();
    }
}

class Cursor {
    public int x;
    public int y;

    private int stepSize = 10;
    private int cursorSize = 50;

    public Cursor() {
        this.x = mouseX;
        this.y = mouseY;
    }
    
    public void show() {
        drawCursor();
        drawDepth();
    }

    private void drawCursor() {
        noFill();
        strokeWeight(2);
        stroke(255,0,0);
        rect(x - cursorSize / 2, y - cursorSize / 2, cursorSize, cursorSize);
        line(x, y, x + cursorSize / 4, y);
        line(x, y, x, y + cursorSize / 4);
    }

    private void drawDepth() {
        int[] rawDepth = kinect.getRawDepth();
        int index = x + y * kinect.width;
        int depth = rawDepth[index];

        noStroke();
        fill(255, 255, 255, 200);

        String depthString = "Depth: " + depth;
        textSize(18);
        text(depthString, x + cursorSize * 3/4, y);
    }

    public int getDepth() {
        int[] rawDepth = kinect.getRawDepth();
        int index = x + y * kinect.width;
        int depth = rawDepth[index];
        return depth;
    }

    public void updatePosition() {
        this.x = mouseX;
        this.y = mouseY;
    }

    public void moveUp() {
        if(y > 0) y -= stepSize;
    }

    public void moveDown() {
        if(y < height) y += stepSize;
    }

    public void moveLeft() {
        if(x > 0) x -= stepSize;
    }

    public void moveRight() {
        if(x < width) x += stepSize;
    }
}

void mouseMoved() {
    cursor.updatePosition();
}

void mouseClicked() {
    addFlag();
}

void addFlag() {
    Flag newFlag = new Flag(cursor.x, cursor.y);
    flags.add(newFlag);
}

void keyPressed() {
    if(keyCode == UP) {
        cursor.moveUp();
    }
    else if(keyCode == DOWN) {
        cursor.moveDown();
    }
    else if(keyCode == LEFT) {
        cursor.moveLeft();
    }
    else if(keyCode == RIGHT) {
        cursor.moveRight();
    }

    else if(keyCode == ENTER) {
        addFlag();        
    }

    if(key == 'c') {
        flags.clear();
    }
    else if(key == 'r') {
        if(showPosition == true) showPosition = false;
        else showPosition = true;
    }
}

class Flag {
    public int x;
    public int y;
    
    private int markerSize = 20;

    public Flag(int x, int y) {
        this.x = x;
        this.y = y;
    } 

    public void show() {
        drawCursor(); 
        drawDepth();
    }

    private void drawCursor() {
        stroke(255, 0, 0);
        strokeWeight(2);

        line(x, y, x + markerSize, y);
        line(x, y, x, y + markerSize);
    }

    private void drawDepth() {
        int[] rawDepth = kinect.getRawDepth();
        int index = x + y * kinect.width;
        int depth = rawDepth[index];

        noStroke();
        fill(255, 255, 255, 255);
        
        textSize(16);
        text(depth, x + markerSize, y + markerSize);

        if(showPosition) {
            String xpos = "x: " + x;
            String ypos = "y: " + y;
            text(xpos, x + markerSize, y + 2 * markerSize);
            text(ypos, x + markerSize, y + 3 * markerSize);
        }
    }
}
