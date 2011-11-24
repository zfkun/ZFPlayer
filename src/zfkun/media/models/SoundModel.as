package zfkun.media.models {
	import zfkun.media.events.SoundEvent;
	
	public class SoundModel extends BaseModel implements IModel {
		
		public function SoundModel(name:String=null) {
			super(name);
		}
		
		public function play():void {
			if(!this.hasStarted) dispatchEvent(new SoundEvent(SoundEvent.START));
			dispatchEvent(new SoundEvent(SoundEvent.PLAY));
		}
		
		public function pause():void {
			dispatchEvent(new SoundEvent(SoundEvent.PAUSE));
		}
		
		public function stop():void {
			dispatchEvent(new SoundEvent(SoundEvent.STOP));
		}
		
		public function get isPlaying():Boolean {
			return false;
		}
	}
}