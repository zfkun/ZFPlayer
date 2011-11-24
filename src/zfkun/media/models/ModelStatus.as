package zfkun.media.models {
	
	public final class ModelStatus {
		
		public static const DEFAULT:uint = 0;
		public static const LOAD:uint = 1;
		public static const BUFFER:uint = 2;
		public static const PLAY:uint = 3;
		public static const PAUSE:uint = 4;
		public static const STOP:uint = 5;
		
		public static const SEEK:uint = 6;
		public static const CLOSE:uint = 7;
		
		public function ModelStatus() {}
		
		public static function getName(code:uint):String {
			var name:String;
			switch(code) {
				case ModelStatus.DEFAULT:
					name = "default";
					break;
				case ModelStatus.LOAD:
					name = "load";
					break;
				case ModelStatus.BUFFER:
					name = "buffer";
					break;
				case ModelStatus.PLAY:
					name = "play";
					break;
				case ModelStatus.PAUSE:
					name = "pause";
					break;
				case ModelStatus.STOP:
					name = "stop";
					break;
				case ModelStatus.SEEK:
					name = "seek";
					break;
				case ModelStatus.CLOSE:
					name = "close";
					break;
			}
			return name;
		}
		
	}
	
}