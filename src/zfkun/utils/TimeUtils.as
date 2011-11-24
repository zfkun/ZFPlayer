package zfkun.utils {
	
	public final class TimeUtils {
		
		public function TimeUtils() {
			
		}
		
		public static function toFriendly(second:Number, spliter:String = ":"):String {
			var s:int = int(second);
			var m:int = int(s/60);
			s -= m * 60;
			var h:int = int(m/60);
			m -= h* 60;
			
			return (h < 10 ? "0" : "") + h + spliter + (m < 10 ? "0" : "") + m + spliter + (s < 10 ? "0" : "") + s;
		}
	
	}
	
}