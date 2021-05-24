import hxd.snd.effect.LowPass;
import hxd.snd.effect.ReverbPreset;
import hxd.snd.effect.Reverb;
import scenes.GameScene.Effect;
import hxd.res.Sound;

class AudioManager
{
    public static var baseChanel : Null<hxd.snd.Channel>;
    public static var waterChanel : Null<hxd.snd.Channel>;
    public static var earthChanel : Null<hxd.snd.Channel>;
    public static var fireChanel : Null<hxd.snd.Channel>;
    public static var windChanel : Null<hxd.snd.Channel>;

    public static var musicVolume : Float = 1;

    public static var musicMute : Bool = false;

    public static var sfxChanel : Null<hxd.snd.Channel>;

    public static var sfxVolume (default, set) : Float = 1;

    public static var sfxMute (default, set) : Bool = false;

    static var currentEffect = None;

    static var fadeIn : Float = 1;

    static var fadeOut : Float = 1;

    public static function init()
    {
        baseChanel = hxd.Res.sounds.Ben.Musique_Base.play(true, 1);
        waterChanel = hxd.Res.sounds.Ben.Musique_eau.play(true, 1);
        waterChanel.volume = 0.01;
        earthChanel = hxd.Res.sounds.Ben.Musique_terre.play(true, 1);
        earthChanel.volume = 0.01;
        fireChanel = hxd.Res.sounds.Ben.Musique_feu.play(true, 1);
        fireChanel.volume = 0.01;
        windChanel = hxd.Res.sounds.Ben.Musique_vent.play(true, 1);
        windChanel.volume = 0.01;
    }

    public static function playMusic(effect : Effect)
    {
        if(effect == currentEffect)
            return;

        switch (currentEffect)
        {
            case None :
                baseChanel.fadeTo(0.01, fadeOut);
            case Water : 
                waterChanel.fadeTo(0.01, fadeOut);
            case Earth : 
                earthChanel.fadeTo(0.01, fadeOut);
            case Fire : 
                fireChanel.fadeTo(0.01, fadeOut);
            case Wind : 
                windChanel.fadeTo(0.01, fadeOut);
        }

        switch (effect)
        {
            case None :
                baseChanel.fadeTo(1, fadeIn);
            case Water : 
                waterChanel.fadeTo(1, fadeIn);
            case Earth : 
                earthChanel.fadeTo(1, fadeIn);
            case Fire : 
                fireChanel.fadeTo(1, fadeIn);
            case Wind : 
                windChanel.fadeTo(1, fadeIn);
        }

        currentEffect = effect;
    }

    public static function playSfx(sfx : Sound, loop : Bool = false)
    {
        sfxChanel = sfx.play(loop, sfxVolume);
        sfxChanel.mute = sfxMute;
    }

    public static function dispose()
    {
        if(baseChanel != null)
            baseChanel.stop();

        if(waterChanel != null)
            waterChanel.stop();

        if(earthChanel != null)
            earthChanel.stop();

        if(baseChanel != null)
            baseChanel.stop();

        if(fireChanel != null)
            fireChanel.stop();
        
        if(windChanel != null)
            windChanel.stop();

        hxd.snd.Manager.get().dispose();
    }

    //-------------------------------
    //#region Getters & Setters
    //-------------------------------
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