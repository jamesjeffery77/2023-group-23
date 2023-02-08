public class Button{
    private float x;
    private float y;
    private float wid;
    private float hei;
    private String txt;

    public Button(float x, float y, float wid, float hei){
        this.x = x;
        this.y = y;
        this.wid = wid;
        this.hei = hei;
    }

    public Button(float x, float y){
        this(x, y, 10, 10);
    }

    public void set_pos(float x, float y, float wid, float hei){
        this.x = x;
        this.y = y;
        this.wid = wid;
        this.hei = hei;
    }

    public void set_pos(float x, float y){
        this.x = x;
        this.y = y;
    }

    public void set_size(float wid, float hei){
        this.wid = wid;
        this.hei = hei;
    }

    public void set_text(String str){
        this.txt = str;
    }

    public boolean on_touch(){
        return (    mouseX < x + wid
                &&  mouseX > x
                &&  mouseY < y + hei
                &&  mouseY > y
                );
    }

    public boolean on_click(){
        return (mousePressed && on_touch());
    }

    public void show(){
        if(!on_touch()){
            fill(230, 230, 230, 50);
        }
        else{
            fill(255, 255, 255, 95);
        }
        rect(x, y, wid, hei);
        fill(0);
        textSize(hei/2);
        textAlign(CENTER, BASELINE);
        text(txt, x + wid/2, y + hei * 2/3);
    }


}
