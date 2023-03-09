public class SnakeVertex {

    float x;
    float y;
    Dir from;
    Dir to;

    public SnakeVertex (float x, float y, Dir from, Dir to) {
        this.x = x;
        this.y = y;
        this.from = from;
        this.to = to;
    }

    public SnakeVertex (float x, float y) {
        this.x = x;
        this.y = y;
    }

    public SnakeVertex (float x, float y, Dir d) {
        this.x = x;
        this.y = y;
        this.from = d;
        this.to = d;
    }

}
