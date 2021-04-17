package flowers;

import avenyrh.Vector2;
import scenes.GameScene;
import h2d.Tile;

class Flower
{
    var scene : GameScene;

    public var tiles : Array<Tile>;

    public var gamesTiles : Array<Vector2>;

    public var directions : Array<Int>;

    public function new(scene : GameScene, tile : Tile)
    {
        this.scene = scene;
        
        tiles = tile.split(16);

        gamesTiles = [];
        directions = [];
    }

    public function grow(pos : Vector2, dir : Int)
    {
        gamesTiles.push(pos);
        directions.push(dir);
    }

    public function doNothing() {}

    public function applyWater() {}

    public function applyEarth() {}

    public function applyWind() {}

    public function applyFire() {}
}