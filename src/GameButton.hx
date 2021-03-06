import hxd.res.Sound;
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

    var isLocked : Bool;

    override public function new(parent : Object, scene : GameScene, effect : Effect) 
    {
        super(parent);

        this.scene = scene;

        this.effect = effect;
        var tiles : Array<Tile> = hxd.Res.images.GameButtons.toTile().split(10);

        switch(effect)
        {
            case Wind :
                offTile = tiles[6];
                onTile = tiles[7];
            case Water :
                offTile = tiles[2];
                onTile = tiles[3];
            case Fire :
                offTile = tiles[4];
                onTile = tiles[5];
            case Earth :
                offTile = tiles[0];
                onTile = tiles[1];
            case None :
                offTile = tiles[8];
                onTile = tiles[9];
            default :
                return;
        }

        bitmap = new Bitmap(offTile, this);
        getProperties(bitmap).align(Middle, Right);

        isSelected = false;
        isLocked = false;

        var inter : Interactive = new Interactive(bitmap.tile.width, bitmap.tile.height, bitmap);
        inter.onPush = onPushCb;
    }

    function onPushCb(e : hxd.Event)
    {
        if(isLocked)
            return;

        if(isSelected)
        {

        }
        else
        {
            isSelected = true;
            AudioManager.playSfx(getSFX_Effect());
        }
    }

    public function lock(lock : Bool)
    {
        isLocked = lock;

        if(lock)
        {
            bitmap.tile = onTile;
        }
        else 
        {
            isSelected = false;
        }
    }

    public function unSelect()
    {
        isSelected = false;
    }

    function getSFX_Effect() : Sound
    {
        switch (effect)
        {
            case None : return hxd.Res.sounds.Annuler;
            case Water : return hxd.Res.sounds.Eau;
            case Wind : return hxd.Res.sounds.Air;
            case Earth : return hxd.Res.sounds.Terre;
            case Fire : return hxd.Res.sounds.Feu;
        }
    }

    function set_isSelected(v : Bool) : Bool
    {
        isSelected = v;

        if(isSelected)
        {
            bitmap.tile = onTile;
            scene.selectEffect(effect);
        }
        else 
        {
            bitmap.tile = offTile;
        }

        return isSelected;
    }
}