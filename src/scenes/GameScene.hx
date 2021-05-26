package scenes;

import avenyrh.ui.Button;
import h2d.Bitmap;
import h2d.HtmlText;
import avenyrh.imgui.ImGui;
import avenyrh.engine.Inspector;
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

    var tutoHolder : GameObject;
    var tutoText : HtmlText;

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
        #end
        currentLevel = 0;

        new Wand(scroller);

        ColorCoding.groundTiles = hxd.Res.images.groundTile.toTile().split(15);
        ColorCoding.junkTiles = hxd.Res.images.junkTile.toTile().split(15);

        armoise = new Armoise(this, hxd.Res.images.Armoise.toTile());
        currentFlower = armoise;

        //Tuto
        tutoHolder = new GameObject("Tuto Holder", ui);
        tutoHolder.scale(3);
        ui.getProperties(tutoHolder).align(Bottom, Right);
        tutoHolder.changeTile(Tile.fromColor(Color.iBLACK, Std.int(1280 / 3) + 2, Std.int(720 / 3), 0.8));
        var b : Bitmap = new Bitmap(hxd.Res.images.textBoxWide.toTile(), tutoHolder);
        b.setPosition(-162, -150);
        tutoText = new HtmlText(hxd.res.DefaultFont.get(), b);
        tutoText.setPosition(10, 30);
        tutoText.textAlign = Left;
        var t : Tile = hxd.Res.images.OkButton.toTile().sub(0, 0, 32, 16);
        var button : Button = new Button(tutoHolder, t.width, t.height);
        button.setPosition(-16, -40);
        button.useColor = false;
        button.idle.customTile = t;
        button.hover.customTile = t;
        button.hold.customTile = hxd.Res.images.OkButton.toTile().sub(32, 0, 32, 16);
        button.press.customTile = hxd.Res.images.OkButton.toTile().sub(32, 0, 32, 16);
        button.onClick = (e) -> {gameTime.play = true; tutoHolder.visible = false; AudioManager.playSfx(hxd.Res.sounds.Clic);};
        tutoHolder.visible = false;

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
            if(windDirection == 1)
                AudioManager.playSfx(hxd.Res.sounds.WindR);
            else
                AudioManager.playSfx(hxd.Res.sounds.WindL);
        });
        windRib.setPosition(-91, -43);
        resetRib = new Ribbon(frame, "ResetRibbon", ribs[1], () -> 
        {
            buildLevel(levels[currentLevel]);
            AudioManager.playSfx(hxd.Res.sounds.Reset);
            armoise.didNothingCount = 0;
            if(windDirection == -1)
            {
                windDirection = 1;
                windRib.tile.flipX();
            }
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

        #if debug
        if(InputManager.getKeyDown("UpArrow"))
            moveFlower(0, -1);
        else if(InputManager.getKeyDown("DownArrow"))
            moveFlower(0, 1);
        else if(InputManager.getKeyDown("LeftArrow"))
            moveFlower(-1, 0);
        else if(InputManager.getKeyDown("RightArrow"))
            moveFlower(1, 0);
        #end

        if(InputManager.getKeyDown("Escape"))
            Engine.instance.addScene(new MainMenu());
    }

    function buildLevel(level : Tile)
    {
        gridHolder.removeChildren();
        gameTime.reset();
        currentFlower.gamesTiles = [];

        gameTiles = [];
        tileStates = [];

        var pixels : Pixels = level.getTexture().capturePixels(h2d.col.IBounds.fromValues(currentLevel * 12, 0, 12, 12));

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

        if(TutoText.texts.exists(currentLevel + 1))
        {
            gameTime.play = false;
            tutoHolder.visible = true;
            tutoText.text = TutoText.texts[currentLevel + 1];
        }
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
                Engine.instance.addScene(new MainMenu());
            }
            else 
            {
                //Build next level
                AudioManager.playSfx(hxd.Res.sounds.Goal);
                buildLevel(levels[currentLevel]);
                return;
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
                var a : Armoise = cast currentFlower;
                if(a.didNothingCount > a.countToPlow)
                    AudioManager.playSfx(hxd.Res.sounds.plant.POUSSE_EN_MANQUE_D_EAU);
                else 
                    AudioManager.playSfx(hxd.Res.sounds.plant.POUSSE_NORMALE_01);
            case Water :
                var dir : Int = currentDirection;
                currentFlower.applyWater();
                if(dir != currentDirection)
                    AudioManager.playSfx(hxd.Res.sounds.plant.POUSSE_Redresse_e_v2);
                else 
                    AudioManager.playSfx(hxd.Res.sounds.plant.POUSSE_NORMALE_01);
            case Earth :
                currentFlower.applyEarth();
                AudioManager.playSfx(hxd.Res.sounds.plant.POUSSE_ACC_L_R_E);
            case Wind :
                currentFlower.applyWind();
                AudioManager.playSfx(hxd.Res.sounds.plant.POUSSE_INFLUENC_E_PAR_LE_VENT);
            case Fire :
                currentFlower.applyFire();
                AudioManager.playSfx(hxd.Res.sounds.plant.POUSSE_INTERROMPUE);
        }

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

        AudioManager.playMusic(effect);

        ui.needReflow = false;
    }

    override function drawInfo() 
    {
        super.drawInfo();

        var cl : Array<Int> = [currentLevel];
        Inspector.dragFields("Current level", uID, cl, 0.1);
        currentLevel = cl[0];

        //ImGui.image(levels[currentLevel].getTexture().id, {x : 12, y : 12});
        Inspector.image(levels[currentLevel]);

        //'$name###$name$uID'
        var bc = new hl.NativeArray<Single>(1);
        bc[0] = AudioManager.baseChanel.position;
        ImGui.sliderFloat('Base channel###$name$uID', bc, 0, AudioManager.baseChanel.duration);

        Inspector.checkbox("Base mute", uID, AudioManager.baseChanel.mute);

        // var bcv = new hl.NativeArray<Single>(1);
        // bcv[0] = AudioManager.baseChanel.volume;
        // ImGui.sliderFloat('Base volume###$name$uID', bcv, 0, 1);

        ImGui.spacing();

        var wac = new hl.NativeArray<Single>(1);
        wac[0] = AudioManager.waterChanel.position;
        ImGui.sliderFloat('Water channel###$name$uID', wac, 0, AudioManager.waterChanel.duration);

        Inspector.checkbox("Water mute", uID, AudioManager.waterChanel.mute);

        // var wacv = new hl.NativeArray<Single>(1);
        // wacv[0] = AudioManager.waterChanel.volume;
        // ImGui.sliderFloat('Water volume###$name$uID', wacv, 0, 1);

        ImGui.spacing();

        var fc = new hl.NativeArray<Single>(1);
        fc[0] = AudioManager.fireChanel.position;
        ImGui.sliderFloat('Fire channel###$name$uID', fc, 0, AudioManager.fireChanel.duration);

        Inspector.checkbox("Fire mute", uID, AudioManager.fireChanel.mute);

        // var fcv = new hl.NativeArray<Single>(1);
        // fcv[0] = AudioManager.fireChanel.volume;
        // ImGui.sliderFloat('Fire volume###$name$uID', fcv, 0, 1);

        ImGui.spacing();

        var ec = new hl.NativeArray<Single>(1);
        ec[0] = AudioManager.earthChanel.position;
        ImGui.sliderFloat('Earth channel###$name$uID', ec, 0, AudioManager.earthChanel.duration);

        Inspector.checkbox("Earth mute", uID, AudioManager.earthChanel.mute);

        // var ecv = new hl.NativeArray<Single>(1);
        // ecv[0] = AudioManager.earthChanel.volume;
        // ImGui.sliderFloat('Earth volume###$name$uID', ecv, 0, 1);

        ImGui.spacing();

        var wic = new hl.NativeArray<Single>(1);
        wic[0] = AudioManager.windChanel.position;
        ImGui.sliderFloat('Wind channel###$name$uID', wic, 0, AudioManager.windChanel.duration);

        Inspector.checkbox("BWind mute", uID, AudioManager.windChanel.mute);

        // var wicv = new hl.NativeArray<Single>(1);
        // wicv[0] = AudioManager.windChanel.volume;
        // ImGui.sliderFloat('Wind volume###$name$uID', wicv, 0, 1);
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