import avenyrh.Vector2;
import avenyrh.engine.Process;
import avenyrh.gameObject.ParticleComponent;
import h2d.Object;
import avenyrh.gameObject.GameObject;
import h3d.mat.Texture;

class Wand extends GameObject
{
    var particles : ParticleComponent;


    override public function new(parent : Object) 
    {
        super("Wand", parent, 6);

        particles = cast addComponent(new ParticleComponent(this, "WandParticles", Texture.fromColor(0xFFf79518)));
        alpha = 0;

        var newPos : Vector2 = new Vector2((Process.S2D.mouseX - 1280 / 2) / 3 + 8, (Process.S2D.mouseY - 720 / 2) / 3 + 8);
        setPosition(newPos.x, newPos.y);
    }

    override function postUpdate(dt : Float)
    {
        super.postUpdate(dt);

        var newPos : Vector2 = new Vector2((Process.S2D.mouseX - 1280 / 2) / 3 + 8, (Process.S2D.mouseY - 720 / 2) / 3 + 8);
        setPosition(newPos.x, newPos.y);
    }
}