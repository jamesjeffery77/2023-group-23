class SnakeObj {

    ArrayList<SnakeVertex> vertexList = new ArrayList<SnakeVertex>();

    int matrixWid = 500;
    int matrixHei = 500;
    Dir currentDir;
    float speed = 2;
    SnakeVertex head, tail;
    float len = 0;
    float wid;
    float r = 0;
    float g = 0;
    float b = 0;

    SnakeObj (float len, float wid) {
        head = new SnakeVertex(0, 0);
        currentDir = Dir.DirRight;
        tail = new SnakeVertex(-len, 0, currentDir, currentDir);
        this.len = len;
        this.wid = wid;
    }

    void setMatrixSize(int wid, int hei){
        matrixWid = wid;
        matrixHei = hei;
    }

    void move (){
        moveVertex(head, currentDir, speed);

        if (vertexList.isEmpty()){
            moveVertex(tail, currentDir, speed);
            return;
        }

        float diff;
        float dist = speed;
        while ((diff = calcDist(tail, vertexList.get(0))) <= dist) {
            dist -= diff;
            SnakeVertex v = vertexList.get(0);
            tail = new SnakeVertex(v.x, v.y, v.to);
            vertexList.remove(0);
            if (vertexList.isEmpty()){
                moveVertex(tail, tail.to, dist);
                return;
            }
        }
        moveVertex(tail, tail.to, dist);
    }

    void moveVertex(SnakeVertex v, Dir d, float l){
        switch (d){
            case DirUp :
                v.y -= l;
                break;
            case DirDown :
                v.y += l;
                break;
            case DirLeft :
                v.x -= l;
                break;
            case DirRight :
                v.x += l;
                break;
        }
    }
    
    void turn (Dir d){
        if (currentDir == d || getOppo(currentDir) == d){
            return;
        }
        SnakeVertex v = new SnakeVertex(head.x, head.y, currentDir, d);
        if (vertexList.size() > 0 
            && calcDist(v, vertexList.get(vertexList.size() - 1)) < wid * 1.1){
            return;
        }
        vertexList.add(v);
        currentDir = d;
    }

    void draw (){
        float tempLen = 0;
        pushMatrix();
        //strokeCap(SQUARE);
        smooth();
        noFill();
        stroke(r, g, b);
        strokeWeight(wid);
        beginShape();
        vertex(head.x, head.y);
        for (int i = vertexList.size() - 1; i >= 0; i--){
            SnakeVertex v = vertexList.get(i);
            drawRoundCorner(v, wid/2);
        }
        vertex(tail.x, tail.y);
        endShape();
        
        drawHead();
        drawTail();
        popMatrix();
    }

    void grow (float len){
        this.len += len;
    }

    float calcDist(SnakeVertex a, SnakeVertex b){
        if (a.x != b.x && a.y != b.y){
            return -1;
        }
        return (a.x == b.x) ? abs(a.y - b.y) : abs(a.x - b.x);
    }

    void drawRoundCorner(SnakeVertex v, float size){
        float x = v.x;
        float y = v.y;

        float xBiasF = 0;
        float yBiasF = 0;
        float xBiasT = 0;
        float yBiasT = 0;

        switch (v.from){
            case DirUp :
                yBiasF += size;
                break;
            case DirDown :
                yBiasF -= size;
                break;
            case DirLeft :
                xBiasF += size;
                break;
            case DirRight :
                xBiasF -= size;
                break;
        }
        switch (v.to){
            case DirUp :
                yBiasT -= size;
                break;
            case DirDown :
                yBiasT += size;
                break;
            case DirLeft :
                xBiasT -= size;
                break;
            case DirRight :
                xBiasT += size;
                break;
        }

        vertex(x + xBiasT, y + yBiasT);
        bezierVertex(
            x, y,
            x, y,
            x + xBiasF, y + yBiasF);
        vertex(x + xBiasF, y + yBiasF);

    }

    void drawHead(){
        pushMatrix();
        translate(head.x, head.y);
        switch (currentDir){
            case DirUp :
                rotate(-PI/2);
                break;
            case DirDown :
                rotate(PI/2);
                break;
            case DirLeft :
                rotate(-PI);
                break;
            case DirRight :
                break;
        }
        smooth();
        fill(r, g, b);
        noStroke();
        beginShape();
        //vertex(wid, 0);
        
        vertex(-wid, 0);
        bezierVertex(-wid, wid, 0, wid, wid, 0);
        vertex(wid, 0);
        bezierVertex(0, -wid, -wid, -wid, -wid, 0);
        endShape();
        fill(0);
        ellipse(0, -wid/4, wid/4, wid/4);
        ellipse(0, wid/4, wid/4, wid/4);
        popMatrix();
    }

    void drawTail(){
        pushMatrix();
        translate(tail.x, tail.y);
        switch (tail.to){
            case DirUp :
                rotate(-PI/2);
                break;
            case DirDown :
                rotate(PI/2);
                break;
            case DirLeft :
                rotate(-PI);
                break;
            case DirRight :
                break;
        }
        smooth();
        fill(r, g, b);
        noStroke();
        beginShape();
        vertex(0, -wid/2);
        bezierVertex(-wid/2, -wid/2, -wid*3/4, -wid/2, -wid, 0);
        bezierVertex(-wid*3/4, wid/2, -wid/2, wid/2, 0, wid/2);
        vertex(0, wid/2);
        vertex(0, -wid/2);
        endShape();
        popMatrix();
    }

    void setColour(float r, float g, float b){
        this.r = r;
        this.g = g;
        this.b = b;
    }

}
