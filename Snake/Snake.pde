enum Dir{
    DirUp,
    DirDown,
    DirLeft,
    DirRight,
    DirErr,
}

SnakeObj s;
boolean pause = false;

void setup() {
    size(500, 500);
    
    s = new SnakeObj(120, 20);
    s.setColour(230, 220, 220);
}

void draw() {
    if(!pause){
        background(255);
        s.move();
        s.draw();
    }
    
}

Dir getOppo (Dir d){
    switch (d) {
        case DirUp :
            return Dir.DirDown;
        case DirDown :
            return Dir.DirUp;
        case DirLeft :
            return Dir.DirRight;
        case DirRight :
            return Dir.DirLeft;
        default :
            return Dir.DirErr;
    }
}

void keyPressed(){
    if (!pause){
        switch (keyCode){
            case LEFT:
                s.turn(Dir.DirLeft);
                break;
            case RIGHT:
                s.turn(Dir.DirRight);
                break;
            case UP:
                s.turn(Dir.DirUp);
                break;
            case DOWN:
                s.turn(Dir.DirDown);
                break;
        }
    }
    
    if (key == ' '){
        pause = !pause;
    }
}
