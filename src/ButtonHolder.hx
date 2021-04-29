import avenyrh.engine.Inspector;
import h2d.Object;
import avenyrh.gameObject.GameObject;

class ButtonHolder extends GameObject
{
    override public function new(parent : Object) 
    {
        super("ButtonHolder", parent);
    }

    override function drawInfo() 
    {
        super.drawInfo();

        for(i in 0 ... 5)
        {
            var c : Object = getChildAt(i);
            var pos : Array<Float> = [c.x, c.y];
            Inspector.dragFields("Position" + i, uID, pos, 0.1);
            c.x = pos[0];
            c.y = pos[1];
        }
    }
}