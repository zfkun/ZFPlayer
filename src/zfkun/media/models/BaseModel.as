package zfkun.media.models {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import zfkun.events.media.ModelEvent;

//	import zfkun.media.net.NetClient;
	
	public class BaseModel extends Sprite {
		
		protected var _connect:NetConnection;
		protected var _stream:NetStream;
//		protected var _client:NetClient;
		
		protected var _autoPlay:Boolean;
		protected var _modelWidth:Number;
		protected var _modelHeight:Number;
		protected var _bufferTime:uint;
		
		protected var _duration:Number;
		protected var _status:uint;
		protected var _hasStarted:Boolean;
		protected var _hasEnded:Boolean;

		public function BaseModel(name:String=null, width:Number=320, height:Number=240, buffer:uint=2) {
			_autoPlay = true;			
			_duration = 0;
			_status = ModelStatus.DEFAULT;
			_hasStarted = false;
			_hasEnded = true;
			
			if(name != null) this.name = name;
			
			_modelWidth = width;
			_modelHeight = height;
			_bufferTime = buffer;
		}
		
		protected function onMetaData(data:Object):void {
			if(data is Object) {
				_duration = data.duration;
				notifyEvent(ModelEvent.META_RECEIVE, data);
			}
/*
			for(var key:String in data) {
				trace("metaData[" + key + "] : " + data[key]);
			}			
			metaData[width] : 320
			metaData[lastkeyframetimestamp] : 150
			metaData[canSeekToEnd] : false
			metaData[duration] : 153.133
			metaData[audiodatarate] : 42.53185955999033
			metaData[audiosamplesize] : 16
			metaData[metadatacreator] : Yet Another Metadata Injector for FLV - Version 1.4
			metaData[audiosize] : 898084
			metaData[hasVideo] : true
			metaData[videodatarate] : 200.92450271985788
			metaData[filesize] : 4895403
			metaData[hasAudio] : true
			metaData[datasize] : 4894304
			metaData[audiosamplerate] : 22000
			metaData[hasKeyframes] : true
			metaData[videocodecid] : 2
			metaData[lastkeyframelocation] : 4877661
			metaData[hasMetadata] : true
			metaData[stereo] : true
			metaData[lasttimestamp] : 153.133
			metaData[framerate] : 15.006562922426909
			metaData[height] : 214
			metaData[videosize] : 3963604
			metaData[keyframes] : [object Object]
			metaData[audiocodecid] : 2
*/
		}
		
		protected function onXMPData(data:Object):void {
/*
			for(var key:String in data) {
				trace("XMPData[" + key + "] : " + data[key]);
			}
*/
			notifyEvent(ModelEvent.XMP_RECEIVE, data);
		}
		
		protected function onCuePoint(data:Object):void {
/*
			for(var key:String in data) {
				trace("CuePoint[" + key + "] : " + data[key]);
			}
*/
			notifyEvent(ModelEvent.CUEPOINT_RECEIVE, data);
		}
		
		
		
		protected function notifyEvent(type:String, data:*=null):void {
			switch(type) {

				case ModelEvent.META_RECEIVE:
					_duration = data.duration;
					break;

/*
//				case ModelEvent.STATUS_CHANGE:
//					break;

//				case ModelEvent.VOL_CHANGE:
////					if(data is Number) _stream.soundTransform.volume = data;
//					break;
				
//				case ModelEvent.LOAD:
//					_status = ModelStatus.LOAD;
//					break;
//				case ModelEvent.BUFFER:
//					_status = ModelStatus.BUFFER;
//					break;
//				case ModelEvent.PLAY:
//					_status = ModelStatus.PLAY;
//					break;
//				case ModelEvent.PAUSE:
//					_status = ModelStatus.PAUSE;
//					break;
//				case ModelEvent.STOP:
//					_status = ModelStatus.STOP;
//					break;
				
//				case ModelEvent.READY:
//					break;
//				case ModelEvent.START:
//					break;
//				case ModelEvent.END:
//					break;
//				case ModelEvent.CLOSE:
//					break;
//				case ModelEvent.SEEK:
//					break;
//				case ModelEvent.RESIZE:
//					break;
*/
			}
			dispatchEvent(new ModelEvent(type, data));
		}
		
		
		
		public function resume():void {
//			if(_status == ModelStatus.PAUSE && _stream) {
			if(_status != ModelStatus.PLAY && _stream) {
				_stream.resume();
				_status = ModelStatus.PLAY;
				notifyEvent(ModelEvent.STATUS_CHANGE, _status);
			}
		}
		
		public function pause():void {
//			if((_status == ModelStatus.PLAY || _status == ModelStatus.BUFFER) && _stream) {
			if(_status != ModelStatus.PAUSE && _stream) {
				_stream.pause();
				_status = ModelStatus.PAUSE;
				notifyEvent(ModelEvent.STATUS_CHANGE, _status);
			}
		}
		
		public function togglePause(event:Event = null):void {	
			if(_status == ModelStatus.PAUSE) resume();
			else pause();
		}
		
		public function seek(offset:Number):void {
			if(_status != ModelStatus.DEFAULT && _status != ModelStatus.LOAD && _status != ModelStatus.STOP && _stream) {
				_stream.seek(offset);
				notifyEvent(ModelEvent.SEEK, offset);
			}
		}
		
		public function seekPercent(percent:Number):void {
			if(_stream) seek(_duration * percent);
		}
		
		public function stop():void {
			if(_hasStarted && (_status == ModelStatus.PLAY || _status == ModelStatus.PAUSE || _status == ModelStatus.BUFFER) ) {
				_hasStarted = false;
				pause();
				seek(0);
				_status = ModelStatus.STOP;
				notifyEvent(ModelEvent.STATUS_CHANGE, _status);
			}
		}
		
		public function close():void {
			if(_stream) {
				_stream.close();
				_hasStarted = false;
				_hasEnded = false;
				_status = ModelStatus.STOP;
				notifyEvent(ModelEvent.STATUS_CHANGE, ModelStatus.STOP);
				notifyEvent(ModelEvent.CLOSE);
			}
		}
		
		public function forward(step:Number = 0):void {
			if(_stream) seek(_stream.time + (step > 0 ? step : (_duration / 10)));
		}

		public function rewind(step:Number = 0):void {
			if(_stream) seek(_stream.time - (step > 0 ? step : (_duration / 10)));
		}
		
		
		public function get hasStarted():Boolean {
			return _hasStarted;
		}

//		public function set hasStarted(v:Boolean):void {
//			_hasStarted = v;
//		}

		public function get hasEnded():Boolean {
			return _hasEnded;
		}

//		public function set hasEnded(v:Boolean):void {
//			_hasEnded = v;
//		}

		public function get modelWidth():Number {
			return _modelWidth;
		}

		public function set modelWidth(v:Number):void {
			if(v is Number && v != _modelWidth) {
				_modelWidth = v;
				notifyEvent(ModelEvent.RESIZE, { width : v });
			}
		}

		public function get modelHeight():Number {
			return _modelHeight;
		}

		public function set modelHeight(v:Number):void {
			if(v is Number && v != _modelHeight) {
				_modelHeight = v;
				notifyEvent(ModelEvent.RESIZE, { height : v });
			}
		}

		public function get bufferTime():uint {
			return _bufferTime;
		}

		public function set bufferTime(v:uint):void {
			_bufferTime = v;
		}

		public function get status():uint {
			return _status;
		}
		
		public function get volume():Number {
			return _stream ? _stream.soundTransform.volume : 0;
		}

		public function set volume(v:Number):void {
			if(_stream && v is Number) {
				var st:SoundTransform = _stream.soundTransform;
				st.volume = v;
				_stream.soundTransform = st;
				notifyEvent(ModelEvent.VOL_CHANGE, v);
			}
		}

		public function get duration():Number {
			return _duration;
		}
		
		public function set duration(t:Number):void {
			_duration = t;
		}

		public function get autoPlay():Boolean {
			return _autoPlay;
		}

		public function set autoPlay(v:Boolean):void {
			_autoPlay = v;
		}
		
		public function get byteLoaded():uint {
			return _stream.bytesLoaded;
		}

		public function get bytesTotal():uint {
			return _stream.bytesTotal;
		}

	}
	
}