public class Guy{

    private float jumpmax;
    private float acc;
    private float x;
    private float y;
    private float ini_x;
    private float ini_y;
    private int jump_state = 1; // '1' for upward, '-1' for downward
    private float speed = 0;
    private int LEFT_EDGE;
    private int RIGHT_EDGE;
    private float wid;
    private float ini_speed;
    private float xspeed = 0;

    public Guy(float x, float y, int left_edge, int right_edge, float wid, float jumpmax, float acc){
        this.x = x;
        this.ini_y = y;
        this.y = 0;
        this.LEFT_EDGE = left_edge;
        this.RIGHT_EDGE = right_edge;
        this.wid = wid;
        this.jumpmax = jumpmax;
        this.acc = acc;
        this.ini_speed = sqrt(2 * jumpmax * acc);
        this.speed = ini_speed;
    }

    public Guy(float x, float y, int left_edge, int right_edge, float wid){
        this(x, y, left_edge, right_edge, 10, 60, 0.1);
    }

    public Guy(float x, float y, int left_edge, int right_edge){
        this(x, y, left_edge, right_edge, 10, 60, 0.1);
    }

    public void set_jumpmax(float jumpmax){
        this.jumpmax = jumpmax;
        this.ini_speed = sqrt(2 * jumpmax * acc);
        this.speed = ini_speed;
    }

    public void set_acc(float acc){
        this.acc = acc;
    }

    public void jump(){
        if(speed < 0){
            jump_state = -1;
        }
        speed -= acc;
        y += speed;
    }

    public void reset_jump(float y){
        jump_state = 1;
        this.y = y;
        speed = (y <= 0) ? sqrt(2 * (jumpmax - y) * acc) : -speed;
    }

    public void set_xspeed(float dir){
        xspeed = dir;
    }

    public void move(float dir){
        x += dir;
        if (x < LEFT_EDGE){
            x = RIGHT_EDGE;
        }
        if (x > RIGHT_EDGE){
            x = LEFT_EDGE;
        }
    }

    public void update(){
        jump();
        move(xspeed);
        fill(200);
        stroke(0);
        ellipse(x, trans_pos(y), wid, wid);
    }

    public int get_jump_state(){
        return jump_state;
    }

    public float get_centre_x(){
        return x;
    }

    public float get_centre_y(){
        return trans_pos(y) + wid/2;
    }

    public float get_jumpmax(){
        return jumpmax;
    }

    public float get_acc(){
        return acc;
    }

    private float trans_pos(float y){
        return ini_y - y;
    }
}
