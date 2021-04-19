package scenes;

import avenyrh.Color;
import h2d.Flow;
import flowers.*;
import h2d.Bitmap;
import avenyrh.engine.Engine;
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

    public var gridWidth : Int = 12;
    public var gridHeight : Int = 12;
    var gameTiles : Array<GameTile>;
    public var tileStates : Array<TileState>;
    var gridHolder : Object;

    var currentFlower : Flower;
    var armoise : Armoise;
    public var currentPosition : Vector2;
    public var currentDirection : Int;
    public var windDirection : Int;

    var sky : Bitmap;

    var currentEffect : Effect;
    var buttonFlow : Flow;
    var effectButtons : Array<GameButton>;

    public function new() 
    {
        super("Game Scene");    
    }

    override function added() 
    {
        camera.zoom = 3;

        sky = new Bitmap(Tile.fromColor(0xFF5fcde4, 300, height), scroller);
        sky.setPosition(-80, -height / 2);

        #if debug
        var level : Tile = hxd.Res.images.level.Level.toTile();
        #else
        var level : Tile = hxd.Res.images.level.Level.toTile();
        #end

        buildLevel(level);

        armoise = new Armoise(this, hxd.Res.images.Armoise.toTile());
        currentFlower = armoise;

        currentDirection = 1;
        windDirection = 1;
        currentPosition = new Vector2(5, 10);
        setNewTile();
        currentFlower.grow(currentPosition, currentDirection);

        var gameTime = new GameTime(this);

        //Buttons flow
        buttonFlow = new Flow(ui);
        ui.getProperties(buttonFlow).align(Middle, Left);
        ui.getProperties(buttonFlow).offsetX = 10;
        ui.getProperties(buttonFlow).offsetY = 40;
        buttonFlow.layout = Vertical;
        buttonFlow.verticalSpacing = 10;
        buttonFlow.backgroundTile = Tile.fromColor(Color.iBROWN);
        
        effectButtons = [];
        effectButtons.push(new GameButton(buttonFlow, this, None));
        effectButtons.push(new GameButton(buttonFlow, this, Water));
        effectButtons.push(new GameButton(buttonFlow, this, Earth));
        effectButtons.push(new GameButton(buttonFlow, this, Wind));
        effectButtons.push(new GameButton(buttonFlow, this, Fire));
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

    function buildLevel(level : Tile)
    {
        if(gridHolder != null)
            gridHolder.remove();

        gameTiles = [];
        tileStates = [];
        gridHolder = new Object(scroller);
        gridHolder.setPosition(-20, -80);

        var pixels : Pixels = level.getTexture().capturePixels();

        for(x in 0 ... gridWidth)
        {
            for(y in 0 ... gridHeight)
            {
                var gt = new GameTile(gridHolder, x, y);
                gameTiles[x + gridWidth * y] = gt;
                gt.changeTile(Tile.fromColor(pixels.getPixel(x, y), 16, 16));

                tileStates[x + gridWidth * y] = ColorCoding.getStateFromColor(pixels.getPixel(x, y));
            }
        }

        currentEffect = None;
    }

    public function moveFlowerDir(dir : Int)
    {
        switch(dir)
        {
            case 1 : 
                moveFlower(0, -1);
            case 5 : 
                moveFlower(1, 0);
            case 9 : 
                moveFlower(-1, 0);
            case 13 : 
                moveFlower(0, 1);
            default :
                return;
        }
    }

    public function moveFlower(dirX : Int, dirY : Int)
    {
        var newX : Int = Std.int(currentPosition.x) + dirX;
        var newY : Int = Std.int(currentPosition.y) + dirY;

        //Check if still in grid
        if(newX < 0 || newX >= gridWidth || newY < 0 || newY >= gridHeight)
            return;

        var nextTileState : TileState = getTileState(newX, newY);
        
        if(nextTileState == Obstable || nextTileState == Flower)
            return;
        else if(nextTileState == Objective)
            Engine.instance.addScene(new GameScene());
 
        var oldDir : Int = currentDirection;
        var oldPosition : Vector2 = currentPosition;
        
        setNewDirection(dirX, dirY);
        setOldTile(oldDir, oldPosition);
        setNewTile();
    }

    public function getGameTile(x : Int, y : Int) : GameTile
    {
        if(x < gridWidth && x >= 0 && y < gridHeight && y >= 0)
            return gameTiles[x + gridWidth * y];
        else 
            return null;
    }

    function getTileState(x : Int, y : Int) : TileState
    {
        if(x < gridWidth && x >= 0 && y < gridHeight && y >= 0)
            return tileStates[x + gridWidth * y];
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
        currentFlower.grow(currentPosition, currentDirection);
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

        getGameTile(Std.int(oldPosition.x), Std.int(oldPosition.y)).changeTile(currentFlower.tiles[i - 1]);
    }

    function setNewTile()
    {
        getGameTile(Std.int(currentPosition.x), Std.int(currentPosition.y)).changeTile(currentFlower.tiles[currentDirection - 1]);
        tileStates[Std.int(currentPosition.x) + gridWidth * Std.int(currentPosition.y)] = Flower;
    }

    public function triggerEffect()
    {
        switch(currentEffect)
        {
            case None :
                currentFlower.doNothing();
            case Water :
                currentFlower.applyWater();
            case Earth :
                currentFlower.applyEarth();
            case Wind :
                currentFlower.applyWind();
            case Fire :
                currentFlower.applyFire();
        }

        //Unselect current button
    }

    public function selectEffect(effect : Effect)
    {
        currentEffect = effect;

        for(b in effectButtons)
        {
            if(b.effect != effect)
                b.unSelect();
        }

        ui.needReflow = false;
    }
}

enum TileState
{
    Empty;
    Obstable;
    Flower;
    Objective;
}

enum Effect
{
    None;
    Water;
    Earth;
    Wind;
    Fire;
}