import org.openkinect.processing.*;
import java.util.List;
import java.util.ArrayList;

Kinect kinect;
Towers towers;

void setup() {
    // Kinect camera is 640x480
    size(800, 600, P3D);

    kinect = new Kinect(this);

    kinect.initDepth();
    kinect.initVideo();

    int towerSideLength = 5;
    int kinectXMin = 221;
    int kinectXMax = 451;
    int kinectYMin = 83;
    int kinectYMax = 323;
    int kinectFloorDepth = 710;

    towers = new Towers(towerSideLength, kinectXMin, kinectXMax, kinectYMin, kinectYMax);
    towers.setFloorDepth(kinectFloorDepth);
}

void draw() {
    background(255);

    translate(width/8 - 20, height/4, 0);
    rotateX(radians(40));

    towers.show();
}

class Towers {
    private int towerSideLength;
    private int floorDepth;
    private int minTowerHeight;

    private int kinectXMin;
    private int kinectXMax;
    private int kinectYMin;
    private int kinectYMax;

    private List<Tower> towers;

    public Towers(int towerSideLength, int kinectXMin, int kinectXMax, int kinectYMin, int kinectYMax) {
        this.towerSideLength = towerSideLength;

        this.kinectXMin = kinectXMin;
        this.kinectXMax = kinectXMax;
        this.kinectYMin = kinectYMin;
        this.kinectYMax = kinectYMax;

        this.minTowerHeight = 10;

        this.towers = new ArrayList<Tower>();
        for(int x = kinectXMin; x < kinectXMax; x += towerSideLength) {
            for(int y = kinectYMin; y < kinectYMax; y += towerSideLength) {
                towers.add(new Tower(minTowerHeight));
            }
        }
    }

    public void show() {
        fill(255);
        stroke(0);

        int[] rawDepth = kinect.getRawDepth();

        for(int x = kinectXMin; x < kinectXMax; x += towerSideLength) {
            pushMatrix();

            for(int y = kinectYMin; y < kinectYMax; y += towerSideLength) {
                pushMatrix();
                
                int index = x + y * kinect.width;
                int depth = rawDepth[index];

                Tower tower = getCurrentTower(x, y);
                tower.setTargetHeight(generateTargetHeight(depth));
                tower.updateHeight();

                translate(x, y, tower.height / 2);
                box(towerSideLength, towerSideLength, tower.height);

                popMatrix();
            }

            popMatrix();
        }
    }

    private int generateTargetHeight(int depth) {
        if(floorDepth - depth > minTowerHeight) return floorDepth - depth;
        else return minTowerHeight;
    }

    public int getWidth() {
        return kinectXMax - kinectXMin;
    }

    public int getLength() {
        return kinectYMax - kinectYMin;
    }

    public void setFloorDepth(int floorDepth) {
        this.floorDepth = floorDepth;
    }

    private Tower getCurrentTower(int x, int y) {
        int i = (x - kinectXMin) / towerSideLength;        
        int j = (y - kinectYMin) / towerSideLength;

        int index = i + j * getNumTowerColumns();

        return towers.get(index);
    } 

    private int getNumTowerColumns() {
        return (kinectXMax - kinectXMax) / towerSideLength;
    }
}

class Tower {
    private int minTowerHeight;
    private float height;
    private int targetHeight;

    public Tower(int minTowerHeight) {
        this.minTowerHeight = minTowerHeight;
        this.height = minTowerHeight;
    }

    public void setTargetHeight(int targetHeight) {
        this.targetHeight = targetHeight;
    }

    public void updateHeight() {
        /* height = lerp(height, targetHeight, 0.9); */
        height = targetHeight;
        /* if(height > targetHeight) height--; */
        /* else height = targetHeight; */
    }
}

