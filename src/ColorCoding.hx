import h2d.Tile;
import scenes.GameScene.TileState;

class ColorCoding 
{
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
                return Empty;
            default :
                return Empty;
        }
    }

    public static function getTileFromColor(c : Int) : Tile
    {
        switch (c)
        {
            case 0xFF663931 ://Brown
                return Tile.fromColor(0xFF663931, 16, 16);
            case 0xFF5fcde4 ://Blue
                return Tile.fromColor(0xFF5fcde4, 16, 16, 0);
            case 0xFF595652 ://Grey
                return Tile.fromColor(0xFF595652, 16, 16);
            case 0xFFfbf236 ://Yellow
                return Tile.fromColor(0xFFfbf236, 16, 16);
            case 0xFFac3232 ://Red
                return Tile.fromColor(0xFFfbf236, 16, 16, 0);
            default :
                return Tile.fromColor(0xFFfbf236, 16, 16, 0);
        }
    }
}