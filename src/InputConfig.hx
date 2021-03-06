import avenyrh.GamePad;
import avenyrh.InputManager;
import hxd.Key;

class InputConfig
{
    public static function initInputs() 
    {
        //Keyboard and mouse
        InputManager.addKeyboardKey("Right", Key.D);
        InputManager.addKeyboardKey("Left", Key.Q);
        InputManager.addKeyboardKey("Up", Key.Z);
        InputManager.addKeyboardKey("Down", Key.S);
        InputManager.addKeyboardKey("A", Key.A);
        InputManager.addKeyboardKey("E", Key.E);
        InputManager.addKeyboardKey("R", Key.R);
        InputManager.addKeyboardKey("P", Key.P);
        InputManager.addKeyboardKey("Mute", Key.M);
        InputManager.addKeyboardKey("Space", Key.SPACE);
        InputManager.addKeyboardKey("Escape", Key.ESCAPE);
        InputManager.addKeyboardKey("Tab", Key.TAB);
        InputManager.addKeyboardKey("Ctrl", Key.CTRL);
        InputManager.addKeyboardKey("Shift", Key.SHIFT);
        InputManager.addKeyboardKey("UpArrow", Key.UP);
        InputManager.addKeyboardKey("DownArrow", Key.DOWN);
        InputManager.addKeyboardKey("RightArrow", Key.RIGHT);
        InputManager.addKeyboardKey("LeftArrow", Key.LEFT);

        InputManager.addKeyboardKey("MouseLeft", Key.MOUSE_LEFT);
        InputManager.addKeyboardKey("MouseRight", Key.MOUSE_RIGHT);

        //Gamepad
        var gamePad : GamePad = new GamePad();
        InputManager.addGamePadKey("X", gamePad, GamePadKey.X);
        InputManager.addGamePadKey("Jump", gamePad, GamePadKey.A);
        InputManager.addKeyboardKey("Jump", Key.SPACE);

        InputManager.addKeyboardAxis("Horizontal", Key.D, Key.Q);
        InputManager.addGamePadJoystickAxis("Horizontal", gamePad, GamePadKey.AXIS_LEFT_X);

        InputManager.addKeyboardAxis("Vertical", Key.Z, Key.S);
        InputManager.addGamePadJoystickAxis("Vertical", gamePad, GamePadKey.AXIS_LEFT_Y);
    }
}