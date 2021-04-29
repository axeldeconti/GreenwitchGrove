package animators;

import avenyrh.animation.Animation;
import h2d.Tile;
import avenyrh.animation.Animator;

class FrameAnimator extends Animator
{
    override function init() 
    {
        super.init();

        addAnimation(new FrameIdle("FrameIdle", this, true), true);
    }
}

class FrameIdle extends Animation
{
    override function init() 
    {
        super.init();

        var max : Int = 35;
        var tiles : Array<Tile> = hxd.Res.images.GamePannel.toTile().split(max);
        var step : Float = GameTime.loopTime / 5;

        for(i in 0 ... max)
            addEvent(i * step + GameTime.loopTime / 2, () -> gameObject.changeTile(tiles[i]));

        addEvent(0, () -> gameObject.changeTile(tiles[0]));
        addEvent(max * step + GameTime.loopTime / 2, () -> gameObject.changeTile(tiles[0]));
    }
}