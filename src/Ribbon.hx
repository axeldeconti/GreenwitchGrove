import avenyrh.Color;
import h2d.Interactive;
import h2d.Tile;
import h2d.Object;
import avenyrh.gameObject.GameObject;

class Ribbon extends GameObject
{
    var cb : Void -> Void;

    override public function new(parent : Object, name : String, tile : Tile, cb : Void -> Void) 
    {
        super(name, parent);

        this.cb = cb;
        this.tile = tile;

        this.tile.dx = -tile.width / 2;

        var inter : Interactive = new Interactive(tile.width, tile.height, this);
        inter.setPosition(-tile.width / 2, 0);
        inter.onPush = onPushCb; 
    }

    function onPushCb(e : hxd.Event)
    {
        cb();
    }
}