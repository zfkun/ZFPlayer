package com.zfkun.player.ui {

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	import gs.TweenFilterLite;
	import gs.TweenLite;
	
	import zfkun.ui.shape.Rect;
		
	public class ShapeBtn extends Sprite {
		
		private var _enable:Boolean;
		private var _shapeWapper:Sprite;
		private var _clickArea:Rect;
		
		public function ShapeBtn(shapeClass:Class, color:uint = 0xffffff) {
			buttonMode = true;
			
			_enable = true;
			_shapeWapper = new Sprite();
			_clickArea = new Rect(15,15,0xff0000);
			_clickArea.alpha = 0;
			
			addChild(_shapeWapper);
			addChild(_clickArea);
			_shapeWapper.addChild(new shapeClass());
			
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
			addEventListener(FocusEvent.FOCUS_IN, onMouseOver, false, 0, true);
			addEventListener(FocusEvent.FOCUS_OUT, onMouseOut, false, 0, true);
			addEventListener(MouseEvent.MOUSE_DOWN, onClick, false, 0, true);
		}
		
		private function onMouseOver(e:Event):void {
			TweenFilterLite.to(_shapeWapper, 1, { glowFilter: { color:0xffff00, alpha:1, blurX:4, blurY:4, strength:3 }, /*ease:Elastic.easeOut,*/  overwrite:true } );
		}
		private function onMouseOut(e:Event):void {
			TweenFilterLite.to(_shapeWapper, .8, { glowFilter: { color:0xffff00, alpha:0, blurX:2, blurY:2 , strength:3}, overwrite:true } );
		}
		private function onClick(e:Event):void {
			if(_enable == true) {
				TweenFilterLite.to(this, .1, { glowFilter: { color:0xffff00, alpha:1, blurX:3, blurY:3 , strength:3 }, overwrite:false } );
				TweenFilterLite.to(this, .3, { glowFilter: { color:0xffff00, alpha:0, blurX:2, blurY:2 , strength:3 }, delay:.1, overwrite:false } );
			}
		}

		public function get enable():Boolean {
			return _enable;
		}

		public function set enable(v:Boolean):void {
			if (v) {		
				TweenLite.to(this,.5,{alpha:1, overwrite:false});
			} else {
				TweenLite.to(this,.5,{alpha:.2, overwrite:false});
			}
			_enable = v;
			mouseEnabled = v;
			mouseChildren = v;
		}

		
	}
	
}