package;

import openfl.display.Sprite;

class Main extends Sprite
{
	// private var _player:Spr

	public function new()
	{
		doBenchmark(1000);

		super();
	}

	private function doBenchmark(amount:Int):Void
	{
		for (i in 0...amount) {
			var s:Sprite = new Sprite();
			s.graphics.beginFill(Std.int(Math.random() * 0xFFFFFF));
			s.graphics.drawRect(0, 0, Math.random() * 100, Math.random() * 100);
			s.x = Math.random() * stage.stageWidth;
			s.y = Math.random() * stage.stageHeight;
			addChild(s);
		}
	}
}