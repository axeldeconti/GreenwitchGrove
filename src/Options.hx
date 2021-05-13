import hxd.Cursor;
import hxd.BitmapData;

class Options 
{
    public static function initOptions() 
    {
        //Inputs
        InputConfig.initInputs();

        //Load the database
        //Data.load(hxd.Res.data.entry.getText());

        //Resize font
        var font : h2d.Font = hxd.Res.fonts.pixel_normal.toFont();
        font.resizeTo(Std.int(font.size / 2));

        //Cursor
        var b : BitmapData = hxd.Res.images.Curseur2.toBitmap();
        var cursor : Cursor = Custom(new hxd.Cursor.CustomCursor([b], 0, 0, 0));
        hxd.System.setNativeCursor(cursor);
        hxd.System.setCursor = (c) -> hxd.System.setNativeCursor(cursor);
    }
}