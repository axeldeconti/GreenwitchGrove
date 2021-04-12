import avenyrh.AMath;
import avenyrh.Color;
import h2d.Tile;
import h2d.Interactive;
import h2d.Object;
import avenyrh.gameObject.GameObject;

class GameTile extends GameObject
{
    var size : Int = 16;

    var inter : Interactive;

    override public function new(parent : Object, x : Int, y : Int) 
    {
        super('GameTile[$x,$y]', parent);

        setPosition((size + 1) * x, (size + 1) * y);

        tile = Tile.fromColor(AMath.irandRange(0, Color.iBLACK), size, size);

        inter = new Interactive(size, size, this);
    }
}