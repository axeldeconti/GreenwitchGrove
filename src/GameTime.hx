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

    public static var loopTime : Float = 10;
    var currentTime : Float;
    var isDaytime : Bool;

    var started : Bool = false;

    public var play : Bool = true;

    public override function new(scene : GameScene)
    {
        super("GameTime", scene);

        this.scene = scene;

        holder = new Object(scene.ui);
        holder.scale(2);
        scene.ui.getProperties(holder).align(Top, Left);
        
        bg = new Bitmap(hxd.Res.images.GameTimeBg.toTile(), holder);
        bg.tile.dx = -32;
        bg.tile.dy = -32;

        border = new Bitmap(hxd.Res.images.GameTimeBorder.toTile(), holder);
        border.tile.dx = -32;
        border.tile.dy = -32;

        currentTime = -loopTime / 4;
        isDaytime = true;
    }

    function start()
    {
        scene.ui.getProperties(holder).offsetX = 310;
        scene.ui.getProperties(holder).offsetY = 190;
    }

    override function update(dt:Float) 
    {
        super.update(dt);

        if(!started)
            start();

        if(!play)
            return;

        currentTime += dt;

        var angle : Float = -2 * AMath.PI * currentTime / loopTime;
        var degAngle : Float = AMath.toDeg(angle) % 360;

        bg.rotation = angle;

        if(isDaytime && degAngle < -90 && degAngle > -270)
        {
            isDaytime = false;
            scene.lockButtons();
            trace("Night time");
        }
        else if(!isDaytime && degAngle < -270)
        {
            isDaytime = true;
            scene.triggerEffect();
            trace("Day time");
        }
    }

    public function reset()
    {
        currentTime = -loopTime / 4;
        isDaytime = true;
    }

    override function drawInfo() 
    {
        super.drawInfo();

        play = Inspector.checkbox("Play", uID, play);

        var lt : Array<Float> = [loopTime];
        Inspector.dragFields("Loop time", uID, lt, "%.1f");
        loopTime = lt[0];

        var ct : Array<Float> = [currentTime];
        Inspector.dragFields("Current time", uID, ct);
        currentTime = ct[0];

        isDaytime = Inspector.checkbox("Is Daytime", uID, isDaytime);

        var pos : Array<Int> = [scene.ui.getProperties(holder).offsetX, scene.ui.getProperties(holder).offsetY];
        Inspector.dragFields("Position", uID, pos, 1);
        scene.ui.getProperties(holder).offsetX = pos[0];
        scene.ui.getProperties(holder).offsetY = pos[1];
    }
}