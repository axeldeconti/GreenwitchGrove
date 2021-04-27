import avenyrh.engine.Inspector;
import avenyrh.AMath;
import avenyrh.engine.Process;
import h2d.Object;
import h2d.Bitmap;
import scenes.GameScene;

class GameTime extends Process
{
    var scene : GameScene;

    var holder : Object;
    var bg : Bitmap;
    var border : Bitmap;

    var loopTime : Float = 10;
    var currentTime : Float;
    var isDaytime : Bool;

    public override function new(scene : GameScene)
    {
        super("GameTime", scene);

        this.scene = scene;

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

        currentTime = -loopTime / 4;
        isDaytime = true;
    }

    override function update(dt:Float) 
    {
        super.update(dt);

        currentTime += dt;

        var angle : Float = -2 * AMath.PI * currentTime / loopTime;
        var degAngle : Float = AMath.toDeg(angle) % 360;

        bg.rotation = angle;

        if(isDaytime && degAngle < -90 && degAngle > -270)
        {
            isDaytime = false;
            trace("Night time");
        }
        else if(!isDaytime && degAngle < -270)
        {
            isDaytime = true;
            scene.triggerEffect();
            trace("Day time");
        }
    }

    override function drawInfo() 
    {
        super.drawInfo();

        var lt : Array<Float> = [loopTime];
        Inspector.dragFields("Loop time", uID, lt, "%.1f");
        loopTime = lt[0];

        var ct : Array<Float> = [currentTime];
        Inspector.dragFields("Current time", uID, ct);
        currentTime = ct[0];

        isDaytime = Inspector.checkbox("Is Daytime", uID, isDaytime);
    }
}