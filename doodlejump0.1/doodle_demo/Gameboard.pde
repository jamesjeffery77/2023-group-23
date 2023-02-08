import java.util.*;

public class Gameboard{
    private LinkedList<Block> q = new LinkedList<Block>();
    private float bd_LTx;
    private float bd_LTy;
    private float bd_wid;
    private float bd_hei;
    private float zero_x;
    private float zero_y;
    private float bias;

    private float last_y;
    private float bias_speed;
    private float bias_target;

    public Gameboard(float ltx, float lty, float wid, float hei, float zero_x, float zero_y){
        this.bd_LTx = ltx;
        this.bd_LTy = lty;
        this.bd_wid = wid;
        this.bd_hei = hei;
        this.zero_x = zero_x;
        this.zero_y = zero_y;
        this.last_y = -1;
    }

    public void set_bias_speed(Guy g){
        float jmx = g.get_jumpmax();
        float acc = g.get_acc();
        float t = sqrt(2 * jmx / acc);
        bias_speed = jmx / t;
    }


    public void remove_block(){
        float bottom = win2bd_y(bd_LTy + bd_hei);
        while(q.getFirst().y < bottom){
            q.poll();
        }
    }

    public float move_board(){
        if (bias < bias_target){
            bias += bias_speed;
        }
        return bias;
    }

    public void gen_block(float x, float y){
        Block b = new Block(x, y);
        q.add(b);
    }

    public void show(){
        stroke(0);
        for(Block b : q){
            if(b.y < win2bd_y(bd_LTy)){
                show_block(b);
            }
        }
    }

    public void bd_rect(float x, float y, float wid, float hei){
        float rx = bd2win_x(x);
        float ry = bd2win_y(y);
        rect(rx, ry, wid, hei);
    }


    public float touch(Guy g){
        float gy = win2bd_y(g.get_centre_y());
        if(g.get_jump_state() != -1){
            last_y = gy;
            return -1;
        }
        float gx = win2bd_x(g.get_centre_x());
        
        for (Block b : q){
            if(     b.left < gx + g.wid/2 
                &&  b.left + b.wid > gx - g.wid/2
                &&  this.last_y >= b.y 
                &&  gy <= b.y)
            {
                //println("by: " + b.y + ", last_y: " + this.last_y + ", " + "gy: " + gy);
                last_y = gy;
                g.reset_jump(b.y - bias);
                bias_target = b.y;
                return b.y;
            }
        }
        last_y = gy;
        return -1;
    }

    public void gen_game(float dist, int num, float threshold){
        Block b = q.getLast();
        if (b.y < win2bd_y(bd_LTy) + threshold){
            gen_game(dist, num);
        }
    }

    public void gen_game(float dist, int num){
        if (num == 0){
            return;
        }
        Block b = q.getLast();
        float left;
        float y;
        float l_edge = win2bd_x(bd_LTx);
        float r_edge = win2bd_x(bd_LTx + bd_wid);
        float angle;
        float d;

        do{
            angle = random(0, PI);
            d = random(b.wid * 1.5, dist);
            left = b.left + d * cos(angle);
        }while(left < l_edge || left + b.wid > r_edge);
        //println(angle + ", " + d);

        y = b.y + d * sin(angle);
        gen_block(left + b.wid/2, y);
        gen_game(dist, num-1);
    }


    private void show_block(Block b){
        fill(200, 200, 230);
        bd_rect(b.left, b.y, b.wid, b.hei);
    }

    private float win2bd_x(float x){
        return x - this.zero_x;
    }
    private float win2bd_y(float y){
        return this.zero_y + this.bias - y;
    }
    private float bd2win_x(float x){
        return this.zero_x + x;
    }
    private float bd2win_y(float y){
        return this.zero_y + this.bias - y;
    }
}
