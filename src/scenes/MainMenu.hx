package scenes;

import avenyrh.engine.Engine;
import avenyrh.engine.Scene;

class MainMenu extends Scene
{
    override public function new() 
    {
        super("Main Menu");    
    }

    override function added() 
    {
        Engine.instance.addScene(new GameScene());
        //Engine.instance.addScene(new TestScene());
    }
}