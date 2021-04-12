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
    }
}