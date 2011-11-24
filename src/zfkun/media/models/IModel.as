package zfkun.media.models {
	
	public interface IModel {
		
		function play(url:String=null):void;
		
		function get isPlaying():Boolean;
		
	}
	
}