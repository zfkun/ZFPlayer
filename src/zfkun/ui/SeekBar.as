package zfkun.ui {
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import zfkun.events.ui.SeekBarEvent;
	
	public class SeekBar extends Sprite {
		
		private var _progress:DisplayObject;	// 背景区域
		private var _assets:DisplayObject;		// 可经过的有效区域
		private var _outline:DisplayObject;	// 已经过区域
		private var _cursor:DisplayObject;		// 游标
		
		private var _width:Number;
		private var _height:Number;
		
		private var _isTracking:Boolean;	// 游标是否正在拖拽
		private var _offsetX:Number; 		// 游标拖拽开始时与鼠标的相对距离(x)
		
		
		public function SeekBar(outline:DisplayObject, assets:DisplayObject, progress:DisplayObject, cursor:DisplayObject, width:Number = 100, height:Number = 10) {
			_width = width;
			_height = height;
			
			_outline = progress;
			_assets = assets;
			_progress = progress;
			_cursor = cursor;
			
			initLayout();
		}
		
		private function initLayout():void {
			
			_outline.width = _width;
			_outline.height = _height;
			addEventListener(MouseEvent.MOUSE_DOWN, onChange);
			
			_assets.alpha = .5;
			_assets.width = 0;
			
			_progress.width = 0;
			
			_cursor.x = 0 - _cursor.width / 2;
			_cursor.y = 0 - (_cursor.height - _height) / 2;
			_cursor.addEventListener(MouseEvent.MOUSE_DOWN, onTrackStart);
			
			
			addChild(_progress);
			addChild(_assets);
			addChild(_progress);
			addChild(_cursor);
		}
		
		private function onChange(e:MouseEvent):void {
			var offsetX:Number = this.stage.mouseX - this.x;
			offsetX = offsetX < 0 ? 0 : (offsetX > _width ? _width : offsetX);
			var rate:Number = offsetX / _width;
			seek(rate);
			dispatchEvent(new SeekBarEvent(SeekBarEvent.CHANGE, rate));
		}
		
		private function onTrackStart(e:Event):void {
			e.preventDefault();
			if(!_isTracking) {
				_isTracking = true;
				_offsetX = stage.mouseX - (this.x + _cursor.x);
				this.stage.addEventListener(MouseEvent.MOUSE_UP, onTrackEnd);
				this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onTracking);
			}
		}
		
		private function onTracking(e:Event):void {
			if(_isTracking && checkRangeRect()) {
				// 先设置游标的位置
				_cursor.x = stage.mouseX - this.x - _offsetX;
				
				// 计算出游标中心点x坐标
				var cursorCenterX:Number = _cursor.x + _cursor.width / 2;
				
				// 重新渲染_progress的宽
				_progress.width = cursorCenterX > _width ? _width : (cursorCenterX < 0 ? 0 : cursorCenterX);
				
				// 事件通知
				dispatchEvent(new SeekBarEvent(SeekBarEvent.TRACK, _progress.width / _width));
			}
		}
		
		private function onTrackEnd(e:Event):void {
			_isTracking = false;
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onTrackEnd);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onTracking);
		}
		
		private function checkRangeRect():Boolean {
			var offset:Number = _cursor.width / 2;
			return (0 - offset <= _cursor.x && _cursor.x <= _width - offset );
		}
		
		
		public function seek(rate:Number):void {
			if(!_isTracking) {
				var r:Number = rate;
				if(r > 1) r = 1;
				if(r < 0) r = 0;
				_progress.width = _width * r;
				_cursor.x = _width * r - _cursor.width / 2;
			}
		}
		
		public function set assets(rate:Number):void {
			_assets.width = _width * rate;
		}
		
	}
	
}