import avenyrh.AMath;
import avenyrh.engine.Process;
import h2d.Object;
import h2d.Bitmap;
import scenes.GameScene;

class GameTime extends Process
{
    var holder : Object;
    var bg : Bitmap;
    var border : Bitmap;

    var speedMultiplier : Float = 12;
    var currentTime : Float;

    public override function new(scene : GameScene)
    {
        super("GameTime", scene);

        holder = new Object(scene.ui);
        holder.scale(2);
        scene.ui.getProperties(holder).align(Top, Left);
        scene.ui.getProperties(holder).offsetX = 100;
        scene.ui.getProperties(holder).offsetY = 100;
        
        bg = new Bitmap(hxd.Res.images.GameTimeBg.toTile(), holder);
        bg.tile.dx = -32;
        bg.tile.dy = -32;

        border = new Bitmap(hxd.Res.images.GameTimeBorder.toTile(), holder);
        border.tile.dx = -32;
        border.tile.dy = -32;

        currentTime = 0;
    }

    override function update(dt:Float) 
    {
        super.update(dt);

        currentTime -= dt * speedMultiplier;

        var angle : Float = AMath.toRad(currentTime);

        bg.rotation = angle;
    }
}