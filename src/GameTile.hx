import h3d.mat.Texture;
import avenyrh.gameObject.ParticleComponent;
import avenyrh.AMath;
import avenyrh.Color;
import h2d.Tile;
import h2d.Interactive;
import h2d.Object;
import avenyrh.gameObject.GameObject;

class GameTile extends GameObject
{
    var size : Int = 16;

    //var inter : Interactive;

    var particles : ParticleComponent;

    override public function new(parent : Object, x : Int, y : Int) 
    {
        super('GameTile[$x,$y]', parent);

        setPosition(size * x, size * y);

        tile = Tile.fromColor(AMath.irandRange(0, Color.iBLACK), size, size);

        particles = cast addComponent(new ParticleComponent(this, "TileParticle", Texture.fromColor(0xFF2d3c2b)));
        particles.loop = false;
        particles.stop();

        //inter = new Interactive(size, size, this);
    }

    public function changeGameTile(t : Tile, playParticles : Bool = true) 
    {
        changeTile(t);

        if(t == null)
            alpha = 0;
        else
        {
            alpha = 1;

            if(playParticles)
                particles.play();
        }
    }
}