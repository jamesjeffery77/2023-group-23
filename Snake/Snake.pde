enum Dir{
    DirUp,
    DirDown,
    DirLeft,
    DirRight,
    DirErr,
}

SnakeObj s1;
SnakeObj s2;
boolean pause = false;

void setup() {
    size(500, 500);
    
    s1 = new SnakeObj(300, 20, 100, 100, Dir.DirRight);
    s1.setColour(230, 220, 220);
    s2 = new SnakeObj(300, 20, 300, 300, Dir.DirLeft);
    s2.setColour(220, 220, 230);
}

void draw() {
    if(!pause){
        background(255);
        s1.move();
        s1.draw();
        s2.move();
        s2.draw();
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
                s1.turn(Dir.DirLeft);
                break;
            case RIGHT:
                s1.turn(Dir.DirRight);
                break;
            case UP:
                s1.turn(Dir.DirUp);
                break;
            case DOWN:
                s1.turn(Dir.DirDown);
                break;
        }
        switch (key){
            case 'A':
            case 'a':
                s2.turn(Dir.DirLeft);
                break;
            case 'D':
            case 'd':
                s2.turn(Dir.DirRight);
                break;
            case 'W':
            case 'w':
                s2.turn(Dir.DirUp);
                break;
            case 'S':
            case 's':
                s2.turn(Dir.DirDown);
                break;
        }
    }
    
    if (key == ' '){
        pause = !pause;
    }
}
