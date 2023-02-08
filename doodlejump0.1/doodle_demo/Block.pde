public class Block{
    float left;
    float y;
    float wid;
    float hei;

    public Block(float left, float y, float wid, float hei){
        this.left = left;
        this.y = y;
        this.wid = wid;
        this.hei = hei;
    }

    public Block(float left, float y, float wid){
        this(left, y, wid, 5);
    }

    public Block(float x, float y){
        this(x - 20, y, 40, 10);
    }

}
