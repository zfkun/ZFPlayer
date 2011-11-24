package zfkun.ui.shape {

	import flash.display.Shape;
	
	public class LineBroder extends Shape {
		
		private var _color:uint = 0xffffff;
		private var _w:Number;
		private var _h:Number;
		private var _borderWidth:Number;
		
		public function LineBroder(w:Number=100, h:Number=100, bw:Number=1, c:uint=0xff0000) {
			super();
			
			_color = c;
			_w = w;
			_h = h;
			_borderWidth = bw;
			draw();
		}
		
		private function draw():void {
			graphics.clear();
			graphics.lineStyle(_borderWidth, _color);
			graphics.lineTo(0, 0);
			graphics.lineTo(_w, 0);
			graphics.lineTo(_w, _h);
			graphics.lineTo(0, _h);
			graphics.lineTo(0, 0);
            graphics.endFill();
		}
		
		public function set color(c:uint):void {
			_color = c;
			draw()
		}
		
		public function get color():uint {
			return _color;
		}
		
		override public function set width(value:Number):void {
			_w = value;
			draw();
		}
		
		override public function set height(value:Number):void {
			_h = value;
			draw();
		}

	}
	
}