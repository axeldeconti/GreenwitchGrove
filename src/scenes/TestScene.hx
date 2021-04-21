package scenes;

import avenyrh.engine.Scene;

class TestScene extends Scene 
{
    override public function new() 
    {
        super("TestScene");    
    }

    override function added() 
    {
        super.added();

        camera.zoom = 3;

        var gt : GameTile = new GameTile(scroller, 0, 0);
    }
}