package zfkun.media.net {
	
	import zfkun.media.events.ModelEvent;
	import zfkun.media.models.BaseModel;
	
	public class NetClient {
		
		private var _metaData:Object;
		private var _xmpData:Object;
		private var _cuePoint:Object;
		private var _model:BaseModel;
		
		public function NetClient(model:BaseModel) {
			_model = model;
		}
		
		public function onMetaData(infoData:Object):void {
			_metaData = infoData;
			if(_model) {
				_model.duration = _metaData.duration;
				_model.dispatchEvent(new ModelEvent(ModelEvent.META_RECEIVE));
			}
			
//			for(var key:String in _metaData) {
//				trace("metaData[" + key + "] : " + _metaData[key]);
//			}
			
//			metaData[width] : 320
//			metaData[lastkeyframetimestamp] : 150
//			metaData[canSeekToEnd] : false
//			metaData[duration] : 153.133
//			metaData[audiodatarate] : 42.53185955999033
//			metaData[audiosamplesize] : 16
//			metaData[metadatacreator] : Yet Another Metadata Injector for FLV - Version 1.4
//			metaData[audiosize] : 898084
//			metaData[hasVideo] : true
//			metaData[videodatarate] : 200.92450271985788
//			metaData[filesize] : 4895403
//			metaData[hasAudio] : true
//			metaData[datasize] : 4894304
//			metaData[audiosamplerate] : 22000
//			metaData[hasKeyframes] : true
//			metaData[videocodecid] : 2
//			metaData[lastkeyframelocation] : 4877661
//			metaData[hasMetadata] : true
//			metaData[stereo] : true
//			metaData[lasttimestamp] : 153.133
//			metaData[framerate] : 15.006562922426909
//			metaData[height] : 214
//			metaData[videosize] : 3963604
//			metaData[keyframes] : [object Object]
//			metaData[audiocodecid] : 2
		}
		
		public function onXMPData(infoData:Object):void {
			_xmpData = infoData;
			if(_model) _model.dispatchEvent(new ModelEvent(ModelEvent.XMP_RECEIVE));
		}
		
		public function onCuePoint(data:Object):void {
			_cuePoint = data;
			if(_model) _model.dispatchEvent(new ModelEvent(ModelEvent.CUEPOINT_RECEIVE));
		}

		public function get metaData():Object {
			return _metaData;
		}
		
		public function get XMPData():Object {
			return _xmpData;
		}
		
		public function get cuePoint():Object {
			return _cuePoint;
		}
		
	}
}