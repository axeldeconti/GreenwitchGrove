package scenes;

import avenyrh.imgui.ImGui;
import avenyrh.engine.Inspector;
import avenyrh.AMath;
import avenyrh.utils.Tween;
import h2d.Tile;
import avenyrh.ui.Button;
import avenyrh.gameObject.GameObject;
import avenyrh.engine.Engine;
import avenyrh.engine.Scene;

class MainMenu extends Scene
{
    override public function new() 
    {
        super("Main Menu");    
    }

    var bg : GameObject;

    var title : GameObject;
    var a : Float;
    var speed : Float = 1;
    var amplitude : Float = 5;

    var button : Button;

    var gameJam : GameObject;

    override function added() 
    {
        //Engine.instance.addScene(new GameScene());
        //Engine.instance.addScene(new TestScene());

        camera.zoom = 4.4;

        new Wand(scroller);

        bg = new GameObject("Bg", scroller);
        bg.changeTile(hxd.Res.images.Titlescreen.toTile());
        bg.setPosition(0, 56);
        title = new GameObject("Title", bg);
        title.changeTile(hxd.Res.images.Title.toTile());
        title.setPosition(0, -20);
        a = 0;

        var t : Tile = hxd.Res.images.playbutton.toTile();
        button = new Button(scroller, t.width, t.height);
        scroller.addChildAt(button, 3);
        button.setPosition(-30, 40);
        button.useColor = false;
        button.idle.customTile = t;
        button.hover.customTile = t;
        button.hold.customTile = t;
        button.press.customTile = t;
        button.onClick = (e) -> Engine.instance.addScene(new GameScene());
        button.onOver = (e) -> button.alpha = 0.6;
        button.onOut = (e) -> button.alpha = 1;

        gameJam = new GameObject("GameJam", scroller);
        gameJam.changeTile(hxd.Res.images.gamejamreconstruction2021.toTile());
        gameJam.setPosition(80, 135);
    }

    override function update(dt : Float) 
    {
        super.update(dt);

        a += dt * speed;
        title.setPosition(0, -20 + Math.cos(a) * amplitude);
    }

    override function drawInfo() 
    {
        super.drawInfo();

        var s : Array<Float> = [speed];
        Inspector.dragFields("Speed", uID, s, 0.1);
        speed = s[0];

        var amp : Array<Float> = [amplitude];
        Inspector.dragFields("Amplitude", uID, amp, 0.1);
        amplitude = amp[0];
    }
}