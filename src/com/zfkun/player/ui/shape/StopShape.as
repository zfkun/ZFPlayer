package com.zfkun.player.ui.shape {

	import flash.display.Shape;
	import flash.display.Sprite;
		
	public class StopShape extends Sprite {
		
		private var _color:uint;
		
		public function StopShape(color:uint = 0xffffff) {
			_color = color;
			draw();
		}
		
		private function draw():void {
			var shape:Shape = new Shape();
			shape.graphics.beginFill(_color);
			shape.graphics.drawRect(0, 0, 11, 11);
			shape.graphics.endFill();
			addChild(shape);
		}
		
	}
	
}