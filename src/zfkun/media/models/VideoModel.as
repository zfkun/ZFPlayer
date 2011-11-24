package zfkun.media.models {
	
	import flash.display.StageDisplayState;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import zfkun.events.media.ModelEvent;

	public class VideoModel extends BaseModel implements IModel {
		
		private var _video:Video;
		
		public function VideoModel(name:String = null, width:Number = 480, height:Number = 360, buffer:uint=3) {
			super(name, width, height, buffer);
		}
		
		public function play(url:String=null):void {
			if(!_connect) {
				_connect = new NetConnection();
				_connect.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				_connect.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				_connect.connect(null);
			}
			
			if(!_stream) {
				_stream = new NetStream(_connect);
				_stream.bufferTime = _bufferTime;
				
				var _client:Object = new Object();
				_client.onMetaData = onMetaData;
				_client.onXMPData = onXMPData;
				_client.onCuePoint = onCuePoint;
				_stream.client = _client;//_client = new NetClient(this);
				
				_stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				_stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			}
			
			if(!_video) {
				_video = new Video(_modelWidth, _modelHeight);
				_video.name = this.name + 'Video';
				_video.attachNetStream(_stream);

				addChild(_video);
				
				// 启动尺寸属性变更监听器
				addEventListener(ModelEvent.RESIZE, resizeHandler);
				
//				// 启动视频元数据接收监听器(更新视频尺寸为真实尺寸)
//				addEventListener(ModelEvent.META_RECEIVE, metaDataHandler);
			}

			if(_stream) _stream.play(url);
		}
		
		public function fullScreen(e:Event):void {
			stage.displayState = stage.displayState == StageDisplayState.FULL_SCREEN ? StageDisplayState.NORMAL : StageDisplayState.FULL_SCREEN;
		}
		
		public function get isPlaying():Boolean {
			return !!(_status == ModelStatus.PLAY);
		}
		
		public function get time():Number {
			return _stream.time;
		}
		
		private function netStatusHandler(event:NetStatusEvent):void {
			var code:String = event.info.code;
			trace("NetStatus : " + code);
			
			switch(code) {
				case "NetConnection.Connect.Success":
					trace("连接成功");
					break;
				case "NetConnection.Connect.Failed":
					trace("连接失败");
					break;
				case "NetConnection.Connect.Rejected":
					trace("连接被拒绝");
					break;
				case "NetConnection.Connect.InvalidApp":
					trace("指定连接的服务应用程序不正确");
					break;
				case "NetConnection.Connect.AppShutdown":
					trace("服务应用程序正在关闭");
					break;
				case "NetConnection.Connect.Closed":
					trace("连接已经关闭");
					break;
					
				case "NetStream.Play.StreamNotFound":
					trace("视频流不存在");
					break;
				case "NetStream.Play.Start":
					trace("加载完毕,开始播放");
					if(!_hasStarted) {
						_hasStarted = true;
						_hasEnded = false;
						_status = ModelStatus.PLAY;
						notifyEvent(ModelEvent.STATUS_CHANGE, _status);
						notifyEvent(ModelEvent.START);
					}
					break;
				case "NetStream.Play.Stop":
					trace("播放完毕");
					if(!_hasEnded) {
						_hasEnded = true;
						_status = ModelStatus.STOP;
						notifyEvent(ModelEvent.STATUS_CHANGE, _status);
						notifyEvent(ModelEvent.END);
					}
					break;
					
				case "NetStream.Seek.Notify":
					trace("Seek 完成:" + event.info);
					break;
				case "NetStream.Seek.Failed":
					trace("Seek 失败");
					break;
				case "NetStream.Seek.InvalidTime":
					trace("Seek 失败: 不可用的时间点");
					break;
					
				case "NetStream.Buffer.Empty":
					trace("正在缓冲(bufferLength:" + _stream.bufferLength + ")");
					_status = ModelStatus.BUFFER;
					notifyEvent(ModelEvent.STATUS_CHANGE, _status);
					break;
				case "NetStream.Buffer.Full":
					trace("缓冲完毕，正在播放");
					_status = ModelStatus.PLAY;
					notifyEvent(ModelEvent.STATUS_CHANGE, _status);
					break;
			}
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("安全错误");
		}
		
		private function asyncErrorHandler(event:AsyncErrorEvent):void {
			trace("异步错误");
		}
		
		private function resizeHandler(event:ModelEvent):void {
			var changeRect:Object = event.data as Object;
			trace("尺寸变化事件通知: " + changeRect.width + "," + changeRect.height);
			if(_video && changeRect) {
				if(changeRect.width != null) _video.width = changeRect.width;
				if(changeRect.height != null) _video.height = changeRect.height; 
			}
		}
		
		private function metaDataHandler(e:ModelEvent):void {
			if(e && e.data is Object) {
				modelWidth = e.data.width;
				modelHeight = e.data.height;
				width = modelWidth;
				height = modelHeight;
			}
		}

	}
}