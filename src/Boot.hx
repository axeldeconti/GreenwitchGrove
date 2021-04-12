import avenyrh.Color;
import hxd.Window;
import avenyrh.engine.Engine;
import avenyrh.engine.Process;
import avenyrh.InputManager;
import scenes.*;

class Boot extends hxd.App
{
    public static var instance (default, null) : Boot;
    public static var avenyrhEngine (default, null) : Engine;

    /**
     * Boot
     */
    static function main() 
    {
        new Boot();
    }

    /**
     * Initialize the engine
     */
    override function init() 
    {
        super.init();

        instance = this;

        //Pixel art settings
        //s2d.scaleMode = LetterBox(Const.TARGET_WIDTH, Const.TARGET_HEIGHT, false);
        s2d.filter = new h2d.filter.ColorMatrix();

        avenyrhEngine = new Engine(s2d, engine);

        engine.backgroundColor = Color.iBLACK;

        Options.initOptions();
        Window.getInstance().onClose = onClose;

        avenyrhEngine.addScene(new MainMenu());
    }

    override function update(dt : Float) 
    {
        super.update(dt);

        #if debug
        if(InputManager.getKeyDown("Tab"))
            exit();

        if(InputManager.getKeyDown("P"))
        {
            if(Window.getInstance().displayMode == Windowed)
                Window.getInstance().displayMode = Fullscreen;
            else if(Window.getInstance().displayMode == Fullscreen)
                Window.getInstance().displayMode = Windowed;
        }
        #end

        Process.updateAll(dt);
    }

    override function onResize() 
    {
        super.onResize();
        Process.resizeAll();
    }

    function onClose()
    {       
        //AudioManager.dispose();

        return true;
    }

    public function exit()
    {
        //AudioManager.dispose();
        hxd.System.exit();
    }
}