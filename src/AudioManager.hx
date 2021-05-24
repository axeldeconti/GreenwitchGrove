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

    static var effectsMusics : Map<Effect, Sound>;

    public static function init()
    {
        effectsMusics = 
        [
            Water => hxd.Res.sounds.Ben.Musique_eau,
            Earth => hxd.Res.sounds.Ben.Musique_terre,
            Wind => hxd.Res.sounds.Ben.Musique_vent,
            Fire => hxd.Res.sounds.Ben.Musique_feu,
            None => hxd.Res.sounds.Ben.Musique_Base
        ];

        baseChanel = effectsMusics[None].play(true, 1);
        waterChanel = effectsMusics[Water].play(true, 1);
        waterChanel.mute = true;
        earthChanel = effectsMusics[Earth].play(true, 1);
        earthChanel.mute = true;
        fireChanel = effectsMusics[Fire].play(true, 1);
        fireChanel.mute = true;
        windChanel = effectsMusics[Wind].play(true, 1);
        windChanel.mute = true;
    }

    public static function playMusic(effect : Effect)
    {
        baseChanel.mute = true;
        waterChanel.mute = true;
        earthChanel.mute = true;
        fireChanel.mute = true;
        windChanel.mute = true;

        switch (effect)
        {
            case None : baseChanel.mute = false;
            case Water : waterChanel.mute = false;
            case Earth : earthChanel.mute = false;
            case Fire : fireChanel.mute = false;
            case Wind : windChanel.mute = false;
        }
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