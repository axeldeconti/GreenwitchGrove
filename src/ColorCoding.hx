import scenes.GameScene.TileState;

class ColorCoding 
{
    public static function getStateFromColor(c : Int) : TileState
    {
        switch (c)
        {
            case 0xFF663931 :
                return Obstable;
            case 0xFF5fcde4 :
                return Empty;
            case 0xFF595652 :
                return Obstable;
            case 0xFFfbf236 :
                return Objective;
            default :
                return Empty;
        }
    }
}