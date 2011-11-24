package com.zfkun.player {
	
	import flash.display.Sprite;
	
	public class LayoutMgr {
		
		private var _doc:Sprite;
		private var _configs:Object;
		
		public function LayoutMgr(document:Sprite, skin:) {
			_doc = document;
		}
		
		private function initConfigs():void {
			_configs = {
				
				'play_btn' : { x : 10, y : 440 },
				'startPlay_btn' : { x : 10, y : 360 }
			};
		}
		
	}
}