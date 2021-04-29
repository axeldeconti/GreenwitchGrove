package animators;

import avenyrh.animation.Animation;
import h2d.Tile;
import avenyrh.animation.Animator;

class BGAnimator extends Animator
{
    override function init() 
    {
        super.init();

        addAnimation(new BgIdle("BgIdle", this, true), true);
    }
}

class BgIdle extends Animation
{
    override function init() 
    {
        super.init();

        var tiles : Array<Tile> = hxd.Res.images.Background.toTile().split(12);
        var step : Float = 0.5;

        for(i in 0 ... 11)
            addEvent(i * step, () -> gameObject.changeTile(tiles[i]));

        addEvent(12 * step, () -> gameObject.changeTile(tiles[0]));
    }
}