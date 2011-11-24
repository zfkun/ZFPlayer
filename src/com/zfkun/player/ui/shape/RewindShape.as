package com.zfkun.player.ui.shape {
	
	import flash.display.Shape;
	
	public class RewindShape extends Shape {
	
		private var _color:uint;
	
		public function RewindShape(color:uint = 0xffffff) {
			_color = color;
			draw()
		}
	
		private function draw():void {
			graphics.beginFill(_color);
			graphics.drawRect(0, 0, 1, 7);
			graphics.drawRect(2, 3, 1, 1);
			graphics.drawRect(3, 2, 1, 3);
			graphics.drawRect(4, 1, 1, 5);
			graphics.drawRect(5, 0, 1, 7);
			graphics.endFill();			
		}
		
	}
	
}