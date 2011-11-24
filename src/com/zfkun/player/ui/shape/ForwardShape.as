package com.zfkun.player.ui.shape {
	
	import flash.display.Shape;
	
	public class ForwardShape extends Shape {
		
		private var _color:uint;
		
		public function ForwardShape(color:uint = 0xffffff) {
			_color = color;
			draw()
		}
		
		private function draw():void {
			graphics.beginFill(_color);
			graphics.drawRect(0, 0, 1, 7);
			graphics.drawRect(1, 1, 1, 5);
			graphics.drawRect(2, 2, 1, 3);
			graphics.drawRect(3, 3, 1, 1);
			graphics.drawRect(5, 0, 1, 7);
			graphics.endFill();			
		}
		
	}
	
}