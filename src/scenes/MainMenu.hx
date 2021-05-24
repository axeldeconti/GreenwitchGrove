package scenes;

import avenyrh.Color;
import h2d.HtmlText;
import h2d.Text;
import avenyrh.engine.Inspector;
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
    var amplitude : Float = 1.5;
    var origin : Float = -20;

    var playButton : Button;
    var creditsButton : Button;
    var creditsHolder : GameObject;
    var quitButton : Button;

    var gameJam : GameObject;

    override function added() 
    {
        //Engine.instance.addScene(new GameScene());
        //Engine.instance.addScene(new TestScene());

        camera.zoom = 4.4;

        AudioManager.init();

        new Wand(scroller);

        bg = new GameObject("Bg", scroller);
        bg.changeTile(hxd.Res.images.Titlescreen.toTile());
        bg.setPosition(0, 37.6);
        title = new GameObject("Title", bg);
        title.changeTile(hxd.Res.images.Title.toTile());
        title.setPosition(0, origin);
        a = 0;

        var t : Tile = hxd.Res.images.playbutton.toTile();
        playButton = new Button(scroller, t.width, t.height);
        scroller.addChildAt(playButton, 3);
        playButton.setPosition(-120, 40);
        playButton.useColor = false;
        playButton.idle.customTile = t;
        playButton.hover.customTile = t;
        playButton.hold.customTile = t;
        playButton.press.customTile = t;
        playButton.onClick = (e) -> {AudioManager.playSfx(hxd.Res.sounds.Clic);Engine.instance.addScene(new GameScene());};
        playButton.onOver = (e) -> playButton.alpha = 0.6;
        playButton.onOut = (e) -> playButton.alpha = 1;

        t = hxd.Res.images.creditsbutton.toTile();
        creditsButton = new Button(scroller, t.width, t.height);
        scroller.addChildAt(creditsButton, 3);
        creditsButton.setPosition(-40, 40);
        creditsButton.useColor = false;
        creditsButton.idle.customTile = t;
        creditsButton.hover.customTile = t;
        creditsButton.hold.customTile = t;
        creditsButton.press.customTile = t;
        creditsButton.onClick = (e) -> 
        {
            creditsHolder.visible = !creditsHolder.visible;
            title.visible = !title.visible;
            AudioManager.playSfx(hxd.Res.sounds.Clic);
        };
        creditsButton.onOver = (e) -> creditsButton.alpha = 0.6;
        creditsButton.onOut = (e) -> creditsButton.alpha = 1;
        creditsHolder = new GameObject("Credits", scroller);
        scroller.addChildAt(creditsHolder, 3);
        creditsHolder.setPosition(-34, -64);
        creditsHolder.scale(0.5);
        creditsHolder.changeTile(Tile.fromColor(Color.iBLACK, 1, 1, 0));
        creditsHolder.visible = false;
        var txt : Text = new Text(hxd.res.DefaultFont.get(), creditsHolder);
        txt.setPosition(-100, 0);
        txt.text = "Axel de Conti\n\nCamille Berring\n\nBenjamin Gobbé\n\nMartin Ringot";
        txt = new Text(hxd.res.DefaultFont.get(), creditsHolder);
        txt.setPosition(28, 0);
        txt.text = "Programmation, Game Design, Pixel Art\n\nPixel art, Sound Design, Sorcellerie\n\nSoundtrack, Sound Design\n\nGame & Level Design, Pixel Art, Texte";

        t = hxd.Res.images.QuitButton.toTile();
        quitButton = new Button(scroller, t.width, t.height);
        scroller.addChildAt(quitButton, 3);
        quitButton.setPosition(50, 40);
        quitButton.useColor = false;
        quitButton.idle.customTile = t;
        quitButton.hover.customTile = t;
        quitButton.hold.customTile = t;
        quitButton.press.customTile = t;
        quitButton.onClick = (e) -> Boot.instance.exit();
        quitButton.onOver = (e) -> quitButton.alpha = 0.6;
        quitButton.onOut = (e) -> quitButton.alpha = 1;

        gameJam = new GameObject("GameJam", scroller);
        gameJam.changeTile(hxd.Res.images.gamejamreconstruction2021.toTile());
        gameJam.setPosition(80, 137);
    }

    override function update(dt : Float) 
    {
        super.update(dt);

        a += (dt * speed) % 360;
        title.setPosition(0, origin + Math.cos(a) * amplitude);
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