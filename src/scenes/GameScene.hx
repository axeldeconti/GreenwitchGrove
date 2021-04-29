package scenes;

import animators.*;
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

    var bg : GameObject;
    var frame : GameObject;

    var currentEffect : Effect;
    var buttonHolder : ButtonHolder;
    var effectButtons : Array<GameButton>;

    public function new() 
    {
        super("Game Scene");    
    }

    override function added() 
    {
        camera.zoom = 3;

        bg = new GameObject("Background", scroller, 0);
        bg.setPosition(48.8, 0.8);
        bg.addComponent(new BGAnimator(bg, "BgAnimator"));

        frame = new GameObject("Frame", scroller, 1);
        frame.setPosition(0, 94);
        frame.addComponent(new FrameAnimator(frame, "FrameAnimator"));

        #if debug
        var level : Tile = hxd.Res.images.level.test.toTile();
        #else
        var level : Tile = hxd.Res.images.level.Level.toTile();
        #end

        ColorCoding.groundTiles = hxd.Res.images.groundTile.toTile().split(15);
        ColorCoding.junkTiles = hxd.Res.images.junkTile.toTile().split(15);

        buildLevel(level);

        armoise = new Armoise(this, hxd.Res.images.Armoise.toTile());
        currentFlower = armoise;

        currentDirection = 1;
        windDirection = 1;
        currentPosition = new Vector2(5, 10);
        setNewTile();
        currentFlower.grow(currentPosition, currentDirection);

        new GameTime(this);
        
        buttonHolder = new ButtonHolder(scroller);
        buttonHolder.changeTile(Tile.fromColor(Color.rgbaToInt({r : 0, g : 0, b : 0, a : 0})));
        buttonHolder.setPosition(-120, 30);
        effectButtons = [];
        effectButtons.push(new GameButton(buttonHolder, this, None));
        effectButtons.push(new GameButton(buttonHolder, this, Water));
        effectButtons.push(new GameButton(buttonHolder, this, Earth));
        effectButtons.push(new GameButton(buttonHolder, this, Wind));
        effectButtons.push(new GameButton(buttonHolder, this, Fire));
        effectButtons[0].isSelected = true;
        buttonHolder.getChildAt(0).setPosition(1.7, -23);
        buttonHolder.getChildAt(1).setPosition(-32.5, -7.6);
        buttonHolder.getChildAt(2).setPosition(-18, 22.6);
        buttonHolder.getChildAt(3).setPosition(18, 22.6);
        buttonHolder.getChildAt(4).setPosition(31, -7.6);
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
        gridHolder.setPosition(-39.4, -87);

        var pixels : Pixels = level.getTexture().capturePixels();

        for(x in 0 ... gridWidth)
        {
            for(y in 0 ... gridHeight)
            {
                var gt = new GameTile(gridHolder, x, y);
                gameTiles[x + gridWidth * y] = gt;
                gt.changeGameTile(ColorCoding.getTileFromColor(pixels, x, y), false);

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

        getGameTile(Std.int(oldPosition.x), Std.int(oldPosition.y)).changeGameTile(currentFlower.tiles[i - 1]);
    }

    function setNewTile()
    {
        getGameTile(Std.int(currentPosition.x), Std.int(currentPosition.y)).changeGameTile(currentFlower.tiles[currentDirection - 1]);
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
        for(b in effectButtons)
        {
            if(b.isSelected)
                b.isSelected = false;
        }

        effectButtons[0].isSelected = true;
    }

    public function selectEffect(effect : Effect)
    {
        currentEffect = effect;

        for(b in effectButtons)
        {
            if(b.effect != effect && b.isSelected)
                b.isSelected = false;
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