import hxd.Pixels;
import h2d.Tile;
import scenes.GameScene.TileState;

class ColorCoding 
{
    public static var groundTiles : Array<Tile>;

    public static var junkTiles : Array<Tile>;

    public static function getStateFromColor(c : Int) : TileState
    {
        switch (c)
        {
            case 0xFF663931 ://Brown
                return Obstable;
            case 0xFF5fcde4 ://Blue
                return Empty;
            case 0xFF595652 ://Grey
                return Obstable;
            case 0xFFfbf236 ://Yellow
                return Objective;
            case 0xFFac3232 ://Red
                return Start;
            default :
                return Empty;
        }
    }

    public static function getTileFromColor(pixels : Pixels, x : Int, y : Int) : Tile
    {
        var c : Int = pixels.getPixel(x, y);
        switch (c)
        {
            case 0xFF663931 ://Brown
                return groundTiles[getTileNb(pixels, c, x, y)];
            case 0xFF5fcde4 ://Blue
                return Tile.fromColor(0xFF5fcde4, 16, 16, 0);
            case 0xFF595652 ://Grey
                return junkTiles[getTileNb(pixels, c, x, y)];
            case 0xFFfbf236 ://Yellow
                return Tile.fromColor(0xFFfbf236, 16, 16);
            case 0xFFac3232 ://Red
                return Tile.fromColor(0xFFfbf236, 16, 16, 0);
            default :
                return Tile.fromColor(0xFFfbf236, 16, 16, 0);
        }
    }

    static function getTileNb(pixels : Pixels, c : Int, x : Int, y : Int) : Int
    {
        var up : Bool = false;
        var down : Bool = false;
        var left : Bool = false;
        var right : Bool = false;

        if(y < pixels.height && pixels.getPixel(x, y + 1) == c)
            up = true;
        if(y >= 1 && pixels.getPixel(x, y - 1) == c)
            down = true;
        if(x >= 1 && pixels.getPixel(x - 1, y) == c)
            left = true;
        if(x < pixels.width && pixels.getPixel(x + 1, y) == c)
            right = true;

        if(up && !down && !left && !right)//Up
            return 8;
        else if(!up && down && !left && !right)//Down
            return 6;
        else if(!up && !down && left && !right)//Left
            return 5;
        else if(!up && !down && !left && right)//Right
            return 3;
        else if(up && down && !left && !right)//Up down
            return 7;
        else if(!up && !down && left && right)//Left right
            return 4;
        else if(up && !down && left && !right)//Up left
            return 14;
        else if(!up && !down && !left && right)//Up left right
            return 13;
        else if(up && !down && !left && right)//Up right
            return 12;
        else if(!up && down && left && !right)//Down left
            return 11;
        else if(!up && down && left && right)//Down left right
            return 10;
        else if(!up && down && !left && right)//Down right
            return 9;
        else if(up && down && left && !right)//Left up down
            return 2;
        else if(up && down && !left && right)//Right up down
            return 0;
        else if(!up && down && !left && !right)//Up down left right
            return 1;

        return -1;
    }
}