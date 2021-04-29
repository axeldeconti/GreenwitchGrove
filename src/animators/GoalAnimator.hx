package animators;

import avenyrh.animation.Animation;
import h2d.Tile;
import avenyrh.animation.Animator;

class GoalAnimator extends Animator
{
    override function init() 
    {
        super.init();

        addAnimation(new GoalIdle("GoalIdle", this, true), true);
    }
}

class GoalIdle extends Animation
{
    override function init() 
    {
        super.init();

        var max : Int = 8;
        var tiles : Array<Tile> = hxd.Res.images.GameGoal.toTile().split(max);
        var step : Float = 0.3;

        for(i in 0 ... max)
            addEvent(i * step, () -> gameObject.changeTile(tiles[i]));

        addEvent(max * step, () -> gameObject.changeTile(tiles[0]));
    }
}