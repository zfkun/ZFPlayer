package com.zfkun.player {
	import com.zfkun.player.ui.skin.DefaultSkin;
	
	import flash.display.MovieClip;
	
	public class DefaultSkinMgr {
		
		public static const SKIN:DefaultSkin = new DefaultSkin();
		public static const SKIN_INFO:Object = {
			'startPlay_btn' : { x : 280, y : 230 },
			
			'play_btn' : { x : 10, y : 455, visible : true },
			'pause_btn' : { x : 10, y : 455 },
			
			'proBottom_mc' : { x : 0, y : 0, button : false, visible : true },
			'proMiddle_mc' : { x : 0, y : 0, button : false, visible : true },
			'proTop_mc' : { x : 0, y : 0, button : false, visible : true },
			'pro_btn' : { x : 0, y : 0, visible : true },
			
			'time_mc' : { x : 450, y : 455, width : 100, button : false, visible : true },
			'full_btn' : { x : 550, y : 455, visible : true },
			'exitFull_btn' : { x : 550, y : 455 }
		};
		
		public function DefaultSkinMgr() {}
		
		public static function getMC(mc:MovieClip):MovieClip {
			var infos:Object = DefaultSkinMgr.SKIN_INFO[mc.name];
			mc.x = infos.x;
			mc.y = infos.y;
			if(infos.hasOwnProperty("width")) mc.width = infos.width;
			if(infos.hasOwnProperty("height")) mc.height = infos.height;
			mc.visible = infos.visible;
			mc.buttonMode = infos.button !== false;
			if(infos.stop !== false) mc.stop();
			return mc;
		}
	}
	
}