package zfkun.events.ui {
	
	import flash.events.Event;
	
	public class SeekBarEvent extends Event {
		
		public static const TRACK:String = "track";	// 游标拖拽事件
		public static const CHANGE:String = "change";	// 区域点击事件
//		public static const CHANGE:String = "change";
		
		public var data:*;
		
		public function SeekBarEvent(type:String, obj:*=null, bubbles:Boolean=false, cancelable:Boolean=false) {
			if(obj != null) this.data = obj;
			super(type, bubbles, cancelable);
		}
		
	}
	
}