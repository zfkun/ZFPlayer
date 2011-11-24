package zfkun.events.media {

	import flash.events.Event;
	
	
	public class ModelEvent extends Event {
		
		public static const PLAY:String = "play";
		public static const PAUSE:String = "pause";
		public static const STOP:String = "stop";
		
		public static const LOAD:String = "loading";
		public static const READY:String = "ready";
		public static const START:String = "start";
		public static const BUFFER:String = "buffer";
		public static const BUFFER_COMPLETE:String = "bufferComplete";
		public static const SEEK:String = "seeking";
		public static const SEEK_START:String = "seekStart";
		public static const SEEK_END:String = "seekEnd";
		public static const END:String = "end";
		public static const CLOSE:String = "close";
		
		public static const STATUS_CHANGE:String = "stausChange";
		
		public static const VOL_CHANGE:String = "volumeChange";
		
		public static const RESIZE:String = "resize";
		
		public static const META_RECEIVE:String = "onMetaData";
		public static const XMP_RECEIVE:String = "onXMPData";
		public static const CUEPOINT_RECEIVE:String = "onCuePoint";
		
		public var data:*;
		
		public function ModelEvent(type:String, obj:*=null, bubbles:Boolean=false, cancelable:Boolean=false) {
			if(obj != null) this.data = obj;
			super(type, bubbles, cancelable);
		}
	}
	
}