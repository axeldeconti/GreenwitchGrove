package scenes;

import avenyrh.InputManager;
import avenyrh.Vector2;
import hxd.Pixels;
import h2d.Tile;
import h2d.Object;
import avenyrh.gameObject.GameObject;
import avenyrh.engine.Scene;

class GameScene extends Scene
{
    var s2d : h2d.Scene;

    var gridWidth : Int = 12;
    var gridHeight : Int = 12;
    var gameTiles : Array<GameTile>;
    var tilesData : Array<Int>;
    var gridHolder : Object;

    var flowerTiles : Array<Tile>;
    var currentPosition : Vector2;
    var currentDirection : Int;

    public function new() 
    {
        super("Game Scene");    
    }

    override function added() 
    {
        gameTiles = [];
        tilesData = [];
        gridHolder = new Object(scroller);
        gridHolder.scale(2);
        gridHolder.setPosition(-200, -100);

        #if debug
        var level : Tile = hxd.Res.images.level.Level.toTile();
        #else
        var level : Tile = hxd.Res.images.level.Level.toTile();
        #end

        var pixels : Pixels = level.getTexture().capturePixels();

        for(x in 0 ... gridWidth)
        {
            for(y in 0 ... gridHeight)
            {
                var gt = new GameTile(gridHolder, x, y);
                gameTiles[x + gridWidth * y] = gt;
                gt.changeTile(Tile.fromColor(pixels.getPixel(x, y), 16, 16));
            }
        }

        flowerTiles = hxd.Res.images.Flowers.toTile().split(16);

        currentDirection = 1;
        currentPosition = new Vector2(5, 10);
        setNewTile();
    }

    override function update(dt : Float) 
    {
        super.update(dt);

        if(InputManager.getKeyDown("UpArrow"))
            moveFlower(0, -1);
        else if(InputManager.getKeyDown("DownArrow"))
            moveFlower(0, 1);
        else if(InputManager.getKeyDown("LeftArrow"))
            moveFlower(-1, 0);
        else if(InputManager.getKeyDown("RightArrow"))
            moveFlower(1, 0);
    }

    function moveFlower(dirX : Int, dirY : Int)
    {
        if(currentPosition.x + dirX < 0 && currentPosition.x + dirX >= gridWidth && 
            currentPosition.y + dirY < 0 && currentPosition.y + dirY >= gridHeight)
            return;

        var oldDir : Int = currentDirection;
        var oldPosition : Vector2 = currentPosition;
        
        setNewDirection(dirX, dirY);
        setOldTile(oldDir, oldPosition);
        setNewTile();
    }

    function getGameTile(x : Int, y : Int) : GameTile
    {
        if(x < gridWidth && y < gridHeight)
            return gameTiles[x + gridWidth * y];
        else 
            return null;
    }

    function setNewDirection(dirX : Int, dirY : Int)
    {
        //Set new direction
        if(dirX == 1 && dirY == 0)
            currentDirection = 5;
        else if(dirX == -1 && dirY == 0)
            currentDirection = 9;
        else if(dirX == 0 && dirY == 1)
            currentDirection = 13;
        else if(dirX == 0 && dirY == -1)
            currentDirection = 1;

        currentPosition = new Vector2(currentPosition.x + dirX, currentPosition.y + dirY);
    }

    function setOldTile(oldDir : Int, oldPosition : Vector2)
    {
        var i : Int = -1;

        switch(oldDir)
        {
            case 1 : 
                switch(currentDirection)
                {
                    case 1 : 
                        i = 2;
                    case 5 : 
                        i = 4;
                    case 9 :
                        i = 3;
                    default :
                        return;
                }
            case 5 : 
                switch(currentDirection)
                {
                    case 1 : 
                        i = 7;
                    case 5 : 
                        i = 6;
                    case 13 :
                        i = 8;
                    default :
                        return;
                }
            case 9 : 
                switch(currentDirection)
                {
                    case 1 : 
                        i = 11;
                    case 9 : 
                        i = 10;
                    case 13 :
                        i = 12;
                    default :
                        return;
                }
            case 13 : 
                switch(currentDirection)
                {
                    case 5 : 
                        i = 16;
                    case 9 : 
                        i = 15;
                    case 13 :
                        i = 14;
                    default :
                        return;
                }
            default : 
                return;
        }

        getGameTile(Std.int(oldPosition.x), Std.int(oldPosition.y)).changeTile(flowerTiles[i - 1]);
    }

    function setNewTile()
    {
        getGameTile(Std.int(currentPosition.x), Std.int(currentPosition.y)).changeTile(flowerTiles[currentDirection - 1]);
    }
}