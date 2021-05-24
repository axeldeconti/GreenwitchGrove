package flowers;

import avenyrh.Vector2;
import scenes.GameScene;
import h2d.Tile;

class Armoise extends Flower
{
    public var didNothingCount : Int;
    var countToPlow : Int = 4;

    override public function new(scene : GameScene, tile : Tile) 
    {
        super(scene, tile);
    }

    override function doNothing()
    {
        didNothingCount++;

        if(didNothingCount >= countToPlow && scene.currentDirection == 1)
        {
            didNothingCount = 0;

            //Plow
            //Go left or right
            scene.moveFlower(scene.windDirection, 0);
        }
        else
        {
            //Continu growing
            if(didNothingCount >= countToPlow && (scene.currentDirection == 5 || scene.currentDirection == 9))
            {
                //Go down
                scene.moveFlower(0, 1);
            }
            else
            {
                //Continu going down
                scene.moveFlowerDir(scene.currentDirection);
            }
        }
    }

    override function applyWater() 
    {
        didNothingCount = 0;

        if(scene.currentDirection == 13)
        {
            //Go left or right
            scene.moveFlower(scene.windDirection, 0);
        }
        else
        {
            //Go up
            scene.moveFlower(0, -1);
        }
    }

    override function applyEarth() 
    {
        didNothingCount = 0;

        //Continu growing x 2
        scene.moveFlowerDir(scene.currentDirection);
        scene.moveFlowerDir(scene.currentDirection);
    }

    override function applyWind() 
    {
        didNothingCount = 0;

        //Go left or right
        scene.moveFlower(scene.windDirection, 0);
    }

    override function applyFire()
    {
        didNothingCount = countToPlow;

        //Change last
        if(gamesTiles.length > 1)
        {
            //Remove current
            var currentPos : Vector2 = gamesTiles.pop();
            scene.getGameTile(Std.int(currentPos.x), Std.int(currentPos.y)).changeGameTile(null);
            scene.tileStates[Std.int(currentPos.x) + scene.gridWidth * Std.int(currentPos.y)] = Empty;
            directions.pop();

            var i : Int = gamesTiles.length - 1;
            var dir : Int = -1;
            currentPos = gamesTiles[i];
            var oldPos = gamesTiles[i - 1];
            if(oldPos == null)
                dir = 0;
            else
            {
                if(currentPos.x == oldPos.x && currentPos.y > oldPos.y)
                    dir = 12;
                else if(currentPos.x == oldPos.x && currentPos.y < oldPos.y)
                    dir = 0;
                else if(currentPos.x > oldPos.x && currentPos.y == oldPos.y)
                    dir = 4;
                else if(currentPos.x < oldPos.x && currentPos.y == oldPos.y)
                    dir = 8;
            }

            scene.getGameTile(Std.int(currentPos.x), Std.int(currentPos.y)).changeTile(tiles[dir]);
            scene.currentDirection = directions[i];
            scene.currentPosition = currentPos;
        }
        else
        {
            
        }
    }
}