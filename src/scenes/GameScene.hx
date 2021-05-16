package scenes;

import hxd.res.Sound;
import animators.*;
import avenyrh.Color;
import flowers.*;
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

    var gameTime : GameTime;

    public var gridWidth : Int = 12;
    public var gridHeight : Int = 12;
    var gameTiles : Array<GameTile>;
    public var tileStates : Array<TileState>;
    var gridHolder : Object;

    var levels : Array<Tile>;
    var currentLevel : Int;

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
    var resetRib : Ribbon;
    var windRib : Ribbon;

    public function new() 
    {
        super("Game Scene");    
    }

    override function added() 
    {
        camera.zoom = 3;

        gameTime = new GameTime(this);

        bg = new GameObject("Background", scroller, 0);
        bg.setPosition(48.8, 0.8);
        bg.addComponent(new BGAnimator(bg, "BgAnimator"));

        frame = new GameObject("Frame", scroller, 1);
        frame.setPosition(0, 94);
        frame.addComponent(new FrameAnimator(frame, "FrameAnimator"));

        //Get levels
        levels = [];
        var t : Tile = hxd.Res.images.level.Levels.toTile();
        var nb : Int = Std.int(t.width / 12);
        for(i in 0 ... nb)
            levels.push(t.sub(12 * i, 0, 12, 12));

        #if debug
        var level : Tile = hxd.Res.images.level.test.toTile();
        #else
        var level : Tile = levels[0];
        currentLevel = 0;
        #end

        new Wand(scroller);

        ColorCoding.groundTiles = hxd.Res.images.groundTile.toTile().split(15);
        ColorCoding.junkTiles = hxd.Res.images.junkTile.toTile().split(15);

        armoise = new Armoise(this, hxd.Res.images.Armoise.toTile());
        currentFlower = armoise;

        //Build level
        gridHolder = new Object(scroller);
        gridHolder.setPosition(-39.4, -87);
        buildLevel(level);
        windDirection = 1;
        
        //Ribbons
        var ribs : Array<Tile> = hxd.Res.images.ribbons.toTile().split(2);
        windRib = new Ribbon(frame, "WindRibbon", ribs[0], () -> 
        {
            windDirection *= -1; 
            windRib.tile.flipX();
            AudioManager.playSfx(hxd.Res.sounds.Changement_Vent);
        });
        windRib.setPosition(-91, -43);
        resetRib = new Ribbon(frame, "ResetRibbon", ribs[1], () -> 
        {
            buildLevel(levels[currentLevel]);
            AudioManager.playSfx(hxd.Res.sounds.Reset);
        });
        resetRib.setPosition(-127.7, -43);

        //Buttons
        buttonHolder = new ButtonHolder(scroller);
        buttonHolder.setPosition(-213, -122);
        effectButtons = [];
        effectButtons.push(new GameButton(buttonHolder, this, None));
        effectButtons.push(new GameButton(buttonHolder, this, Water));
        effectButtons.push(new GameButton(buttonHolder, this, Earth));
        effectButtons.push(new GameButton(buttonHolder, this, Wind));
        effectButtons.push(new GameButton(buttonHolder, this, Fire));
        effectButtons[0].isSelected = true;
        effectButtons[0].setPosition(75, 160);
        effectButtons[1].setPosition(61, 130);
        effectButtons[2].setPosition(94, 115);
        effectButtons[3].setPosition(124, 130);
        effectButtons[4].setPosition(111, 160);
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
        gridHolder.removeChildren();
        gameTime.reset();

        gameTiles = [];
        tileStates = [];

        var pixels : Pixels = level.getTexture().capturePixels();

        for(x in 0 ... gridWidth)
        {
            for(y in 0 ... gridHeight)
            {
                var gt = new GameTile(gridHolder, x, y);
                gameTiles[x + gridWidth * y] = gt;
                gt.changeGameTile(ColorCoding.getTileFromColor(pixels, x, y), false);

                tileStates[x + gridWidth * y] = ColorCoding.getStateFromColor(pixels.getPixel(x, y));

                if(tileStates[x + gridWidth * y] == Objective)
                    gt.addComponent(new GoalAnimator(gt, "GoalAnimator"));
                else if(tileStates[x + gridWidth * y] == Start)
                    currentPosition = new Vector2(x, y);
            }
        }

        currentEffect = None;
        currentDirection = 1;
        setNewTile();
        currentFlower.grow(currentPosition, currentDirection);
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
        {
            //Go to next level
            currentLevel++;
            if(currentLevel >= levels.length)
            {
                //Finish the game
            }
            else 
            {
                //Build next level
                buildLevel(levels[currentLevel]);
            }
        }

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

    public function lockButtons()
    {
        for(b in effectButtons)
            b.lock(true);
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

        //AudioManager.playSfx(getSFX_Effect());

        //Unselect current button
        for(b in effectButtons)
            b.lock(false);

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
    Start;
}

enum Effect
{
    None;
    Water;
    Earth;
    Wind;
    Fire;
}