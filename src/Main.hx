package;

import motion.Actuate;
import motion.easing.Linear;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.Assets;

class Main extends Sprite
{
	private var _player:Sprite;

	private var _up:Bool = false;
	private var _down:Bool = false;
	private var _left:Bool = false;
	private var _right:Bool = false;

	private var _lastTime:Float = 0;

	public function new()
	{
		super();

#if flash
		var textField:openfl.text.TextField = new openfl.text.TextField();
		textField.width = stage.stageWidth;
		textField.height = stage.stageHeight;
		textField.mouseEnabled = false;
		stage.addChild(textField);

		haxe.Log.trace = function(value:Dynamic, ?infos:haxe.PosInfos):Void {
			textField.appendText(infos.fileName + ":" + infos.lineNumber + ": " + Std.string(value) + "\n");
		}
#end

		addEventListener(Event.ADDED_TO_STAGE, init);
		stage.frameRate = 120;
	}

	private function init(e:Event):Void
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);

		{ // Setup shaders
			MintShader.init(this);
			MintShader.compile("assets/shader/heroku.frag");
		}

		// doBenchmark(1000, 2);

		{ // Setup player
			_player = new Sprite();
			_player.graphics.beginFill(0x000088);
			_player.graphics.drawRect(0, 0, 20, 20);
			_player.x = 200;
			_player.y = 200;
			addChild(_player);
		}

		{ // Setup event
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			addEventListener(Event.ENTER_FRAME, update);
		}

		{ // Setup misc
			addChild(new openfl.display.FPS());
		}
	}

	private function keyDown(e:KeyboardEvent):Void
	{	
		if (e.keyCode == 38) _up = true
		else if (e.keyCode == 40) _down = true
		else if (e.keyCode == 37) _left = true
		else if (e.keyCode == 39) _right = true;
	}

	private function keyUp(e:KeyboardEvent):Void
	{
		if (e.keyCode == 38) _up = false
		else if (e.keyCode == 40) _down = false
		else if (e.keyCode == 37) _left = false
		else if (e.keyCode == 39) _right = false;
	}

	private function update(e:Event):Void
	{
		var delta:Float = getDelta();
		var speed:Float = 500 * delta;
		if (_up) _player.y -= speed;
		if (_down) _player.y += speed;
		if (_left) _player.x -= speed;
		if (_right) _player.x += speed;
	}

	private function doBenchmark(amount:Int, type:Int):Void
	{
		if (type == 1) {
			for (i in 0...amount) {
				var s:Sprite = new Sprite();
				s.graphics.beginFill(Std.int(Math.random() * 0xFFFFFF));
				s.graphics.drawRect(0, 0, Math.random() * 100, Math.random() * 100);
				s.x = Math.random() * stage.stageWidth;
				s.y = Math.random() * stage.stageHeight;
				addChild(s);

				Actuate.tween(s, 5 + Math.random() * .5, { rotation: s.rotation + (Math.random() > .5 ? 360 : -360) } ).ease(Linear.easeNone).repeat();
			}
		} else if (type == 2) {
			for (i in 0...amount) {
				var s:Bitmap = new Bitmap(Assets.getBitmapData("assets/img/benchmarkSquare.png"));
				s.x = Math.random() * stage.stageWidth;
				s.y = Math.random() * stage.stageHeight;
				addChild(s);

				Actuate.tween(s, 5 + Math.random() * .5, { rotation: s.rotation + (Math.random() > .5 ? 360 : -360) } ).ease(Linear.easeNone).repeat();
			}
		}
	}

	private function getDelta():Float
	{
#if flash
		var delta = (flash.Lib.getTimer() - _lastTime) / 1000;
		_lastTime = flash.Lib.getTimer();
		return delta;
#elseif cpp
		var delta = Sys.time() - _lastTime;
		_lastTime = Sys.time();
		return delta;
#end
	}
}