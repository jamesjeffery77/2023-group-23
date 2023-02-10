int winwid = 400;
int winhei = 400;
int ground = 250;
Guy g;
Gameboard bd;
Button restart;

void setup(){
    size(411, 501);
    frameRate(120);
    draw_bg();
    restart = new Button(10, winhei + 40, 100, 40);
    restart.set_text("RESTART");
    new_game();
}

void draw(){
    if (restart.on_click()){
        new_game();
    }
    draw_bg();
    strokeWeight(3);
    bd.touch(g);
    int score = floor(bd.move_board());
    bd.remove_block();
    //println(f);
    bd.show();
    g.update();
    bd.gen_game(80, 10, 100);
    show_score(score);
    restart.show();
}

void draw_bg(){
    int inix = 5;
    int iniy = 5;
    background(230, 240, 255);
    noStroke();
    fill(240, 255, 255);
    rect(inix, iniy, winwid, winhei);
    stroke(230, 240, 255);
    strokeWeight(1);
    for(int i = iniy; i < winhei; i+=20){
        line(inix, i, inix+winwid, i);
    }
    for(int i = inix; i < winwid; i+=20){
        line(i, iniy, i, iniy+winhei);
    }

}

void show_score(int score){
    textAlign(LEFT, BASELINE);
    textSize(20);
    fill(100, 150, 150);
    text("SCORE :" + score, 10, winhei + 30);
}

void new_game(){
    g = new Guy(205, 380, 0, 400);
    g.set_jumpmax(100);
    bd = new Gameboard(5, 5, winwid, winhei, 205, 380);
    bd.set_bias_speed(g);
    bd.gen_block(0, 0);
    bd.gen_game(80, 10);
}

void keyPressed(){
    if (keyCode == LEFT){
        g.set_xspeed(-1);
    }
    if (keyCode == RIGHT){
        g.set_xspeed(1);
    }
}

void keyReleased(){
    g.set_xspeed(0);
}
