import scenes.GameScene;
import h2d.Bitmap;
import h2d.Flow;
import h2d.Tile;
import scenes.GameScene.Effect;
import h2d.Object;
import h2d.Interactive;

class GameButton extends Flow
{
    var scene : GameScene;

    public var effect : Effect;

    var bitmap : Bitmap;

    var onTile : Tile;

    var offTile : Tile;

    public var isSelected (default, set) : Bool;

    override public function new(parent : Object, scene : GameScene, effect : Effect) 
    {
        super(parent);

        this.scene = scene;

        this.effect = effect;
        var tiles : Array<Tile> = hxd.Res.images.GameButtons.toTile().split(10);

        switch(effect)
        {
            case Wind :
                offTile = tiles[0];
                onTile = tiles[1];
            case Water :
                offTile = tiles[2];
                onTile = tiles[3];
            case Fire :
                offTile = tiles[4];
                onTile = tiles[5];
            case Earth :
                offTile = tiles[6];
                onTile = tiles[7];
            case None :
                offTile = tiles[8];
                onTile = tiles[9];
            default :
                return;
        }

        bitmap = new Bitmap(offTile, this);
        getProperties(bitmap).align(Middle, Right);

        isSelected = false;

        var inter : Interactive = new Interactive(64, 64, bitmap);
        inter.onPush = onPushCb;
    }

    function onPushCb(e : hxd.Event)
    {
        if(isSelected)
        {
            if(effect == Wind)
            {
                var v : Bool = !bitmap.tile.xFlip;
                bitmap.tile.xFlip = v;
                bitmap.tile.dx = 0;
                scene.windDirection = v ? -1 : 1;
            }
            else
            {

            }
        }
        else
        {
            isSelected = true;
        }
    }

    public function unSelect()
    {
        isSelected = false;
    }

    function set_isSelected(v : Bool) : Bool
    {
        isSelected = v;

        if(isSelected)
        {
            bitmap.tile = onTile;
            scene.selectEffect(effect);

            if(effect == Wind)
            {
                var v : Bool = !bitmap.tile.xFlip;
                scene.windDirection = v ? 1 : -1;
            }
        }
        else 
        {
            if(effect == Wind)
            {
                var v : Bool = bitmap.tile.xFlip;
                bitmap.tile = offTile;
                bitmap.tile.xFlip = v;
                bitmap.tile.dx = 0;
            }
            else 
            {
                bitmap.tile = offTile;
            }
        }

        return isSelected;
    }
}