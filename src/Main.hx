package;

import motion.Actuate;
import motion.easing.Linear;
import openfl.events.Event;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.Assets;

class Main extends Sprite
{
	// private var _player:Spr

	public function new()
	{
		super();

		addEventListener(Event.ADDED_TO_STAGE, init);
		stage.frameRate = 120;
	}

	private function init(e:Event):Void
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);
		doBenchmark(1000, 2);
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

		addChild(new openfl.display.FPS());
	}
}