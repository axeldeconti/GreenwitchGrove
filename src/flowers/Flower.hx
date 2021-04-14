package flowers;

import h2d.Tile;

class Flower
{
    public var tiles : Array<Tile>;

    public function new(tile : Tile)
    {
        tiles = tile.split(16);
    }

    public function doNothing() {}

    public function applyWater() {}

    public function applyEarth() {}

    public function applyWind(left : Bool) {}

    public function applyFire() {}
}