import hxd.res.Sound;

class AudioManager 
{
    public static var musicChanel : Null<hxd.snd.Channel>;

    public static var musicVolume (default, set) : Float = 1;

    public static var musicMute (default, set) : Bool = false;

    public static var sfxChanel : Null<hxd.snd.Channel>;

    public static var sfxVolume (default, set) : Float = 1;

    public static var sfxMute (default, set) : Bool = false;

    public static function playMusic(music : Sound, loop : Bool = true)
    {
        var t : Float = 0;

        if(musicChanel != null && musicChanel.sound != null)
        {
            t = musicChanel.position;
            trace(t);
            musicChanel.stop();
        }

        musicChanel = music.play(loop, musicVolume);
        musicChanel.position = t;
        musicChanel.mute = musicMute;
    }

    public static function playSfx(sfx : Sound, loop : Bool = false)
    {
        sfxChanel = sfx.play(loop, sfxVolume);
        sfxChanel.mute = sfxMute;
    }

    public static function dispose()
    {
        if(musicChanel != null)
            musicChanel.stop();
        
        if(sfxChanel != null)
            sfxChanel.stop();

        hxd.snd.Manager.get().dispose();
    }

    //-------------------------------
    //#region Getters & Setters
    //-------------------------------
    static function set_musicVolume(value : Float) : Float
    {
        musicVolume = value;

        if(musicChanel != null)
            musicChanel.volume = musicVolume;

        return musicVolume;
    }

    static function set_musicMute(value : Bool) : Bool
    {
        musicMute = value;

        if(musicChanel != null)
            musicChanel.mute = musicMute;

        return musicMute;
    }

    static function set_sfxVolume(value : Float) : Float
    {
        sfxVolume = value;

        if(sfxChanel != null)
            sfxChanel.volume = sfxVolume;

        return sfxVolume;
    }

    static function set_sfxMute(value : Bool) : Bool
    {
        sfxMute = value;

        if(sfxChanel != null)
            sfxChanel.mute = sfxMute;

        return sfxMute;
    }
    //#endregion
}