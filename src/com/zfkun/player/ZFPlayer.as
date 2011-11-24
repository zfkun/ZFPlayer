package com.zfkun.player {
	
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import zfkun.events.media.ModelEvent;
	import zfkun.events.ui.SeekBarEvent;
	import zfkun.media.models.ModelStatus;
	import zfkun.media.models.VideoModel;
	import zfkun.ui.SeekBar;
	import zfkun.utils.TimeUtils;

	
	[SWF(width="640",height="480",frameRate="20",backgroundColor="#330022",allowScriptAccess="allways",wmode="transparent")]
	public class ZFPlayer extends Sprite {

		private var _model:VideoModel;
		
		private var _flvUrl:String;
		private var _pars:Object;
		
		private var _playHeaderTimer:Timer;
		
		private var _startPlayBtn:MovieClip;
		private var _playBtn:MovieClip;
		private var _pauseBtn:MovieClip;
//		private var _stopBtn:ShapeBtn;
		private var _fullOnBtn:MovieClip;
		private var _fullOffBtn:MovieClip;
		private var _TimeText:MovieClip;
		private var _seekBar:SeekBar;
		
		public function ZFPlayer() {
			
			stage.align = StageAlign.TOP_LEFT;
//			stage.scaleMode = StageScaleMode.NO_SCALE;

			
			_pars = this.loaderInfo.parameters;
			_pars.auto = _pars === false ? false : true;
			_flvUrl = _pars.flv || "http://rss.ku6.com/test/demo.flv" + "?" + (new Date()).getTime();//"D:/workspace/flash/ZFPlayer/flv/1.flv";
			
			build();	
		}
		
		private function build():void {
			
			_model = new VideoModel("ZFVideoModel", 640, 440, 5);
			addChild(_model);
			
			initController();
			initListener();
			initTimer();
			
			if(_pars.auto) _model.play(_flvUrl);
			
			trace(_model.name + ": x=" + _model.x + ",y=" + _model.y + ", width=" + _model.width + ", height=" + _model.height);
		}
		
		private function initTimer():void {
			_playHeaderTimer = new Timer(100);
			_playHeaderTimer.addEventListener(TimerEvent.TIMER, onPlayHeaderUpdate);
		}
		
		private function initListener():void {
			
//			var _timer:Timer = new Timer(500);
//			_timer.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void{
//				trace("[Timer] status : " + ModelStatus.getName(_model.status));
//			});
//			_model.addEventListener(ModelEvent.START, function(e:Event):void{
//				_timer.start();
//			});
//			_model.addEventListener(ModelEvent.PLAY, function(e:Event):void{
//				_timer.start();
//			});
//			_model.addEventListener(ModelEvent.STOP, function(e:Event):void{
//				_timer.stop();
//			});
//			_model.addEventListener(ModelEvent.STOP, function(e:Event):void{
//				_timer.stop();
//			});

			// loadState hook
			addEventListener(Event.ENTER_FRAME, loadStateHandler);
			
			// Status hook
			_model.addEventListener(ModelEvent.STATUS_CHANGE, onStatusChange);
			
			// Pause hook
			_model.addEventListener(MouseEvent.MOUSE_UP, modelEventHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, modelEventHandler);
			
			// Full/Normal Screen hook
			_model.doubleClickEnabled = true;
			_model.addEventListener(MouseEvent.DOUBLE_CLICK, modelEventHandler);
		}
		
		private function initController():void {
			
			// Play Buttion
			_playBtn = DefaultSkinMgr.getMC(DefaultSkinMgr.SKIN.play_btn);
			_playBtn.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void{
				_playBtn.gotoAndStop(2);
			});
			_playBtn.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void{
				_playBtn.gotoAndStop(1);
			});
			_playBtn.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void{
				_playBtn.gotoAndStop(3);
			});
			_playBtn.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void{
				_playBtn.gotoAndStop(2);
				_playBtn.visible = false;
				_startPlayBtn.visible = false;
				_pauseBtn.visible = true;
//				_stopBtn.visible = true;
				
				if(_model.hasStarted) _model.resume()
				else _model.play(_flvUrl);
			});
			addChild(_playBtn);
			
			
			// StartPlay Button
			_startPlayBtn = DefaultSkinMgr.getMC(DefaultSkinMgr.SKIN.startPlay_btn);
			_startPlayBtn.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void{
				_startPlayBtn.gotoAndStop(2);
			});
			_startPlayBtn.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void{
				_startPlayBtn.gotoAndStop(1);
			});
			_startPlayBtn.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void{
				_playBtn.visible = false;
				_startPlayBtn.visible = false;
				_pauseBtn.visible = true;
//				_stopBtn.visible = true;
				_model.togglePause(e);
			});
			addChild(_startPlayBtn);

			
			// Pause Button
			_pauseBtn = DefaultSkinMgr.getMC(DefaultSkinMgr.SKIN.pause_btn);
			_pauseBtn.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void{
				_pauseBtn.gotoAndStop(2);
			});
			_pauseBtn.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void{
				_pauseBtn.gotoAndStop(1);
			});
			_pauseBtn.addEventListener(MouseEvent.MOUSE_UP, function(event:MouseEvent):void {
				_pauseBtn.visible = false;
				_startPlayBtn.visible = true;
				_playBtn.visible = true;
//				_stopBtn.visible = true;
				_model.pause();
			});
			addChild(_pauseBtn);
			

//			// Stop Button
//			_stopBtn = new ShapeBtn(StopShape);
//			_stopBtn.buttonMode = true;
//			_stopBtn.visible = true;
//			_stopBtn.x = 90;
//			_stopBtn.y = 465;
//			_stopBtn.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {
//				_stopBtn.visible = false;
//				_pauseBtn.visible = false;
//				_startPlayBtn.visible = false;
//				_playBtn.visible = true;
//				_model.stop();
//			});
//			addChild(_stopBtn);
			
			
			// FullScreen on Button
			_fullOnBtn = DefaultSkinMgr.getMC(DefaultSkinMgr.SKIN.full_btn);
			_fullOnBtn.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void{
				_fullOnBtn.gotoAndStop(3);
			});
			_fullOnBtn.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void{
				_fullOnBtn.gotoAndStop(1);
			});
			_fullOnBtn.addEventListener(MouseEvent.MOUSE_UP, fullScreenHandler);
			addChild(_fullOnBtn);
			
			
			// FullScreen off Button
			_fullOffBtn = DefaultSkinMgr.getMC(DefaultSkinMgr.SKIN.exitFull_btn);
			_fullOffBtn.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void{
				_fullOffBtn.gotoAndStop(3);
			});
			_fullOffBtn.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void{
				_fullOffBtn.gotoAndStop(1);
			});
			_fullOffBtn.addEventListener(MouseEvent.MOUSE_UP, fullScreenHandler);
			addChild(_fullOffBtn);
			
			
			// Time Text
			_TimeText = DefaultSkinMgr.getMC(DefaultSkinMgr.SKIN.time_mc);
			addChild(_TimeText);
			
			// SeekBar
			_seekBar = new SeekBar(
				DefaultSkinMgr.getMC(DefaultSkinMgr.SKIN.proBottom_mc),
				DefaultSkinMgr.getMC(DefaultSkinMgr.SKIN.proMiddle_mc),
				DefaultSkinMgr.getMC(DefaultSkinMgr.SKIN.proTop_mc),
				DefaultSkinMgr.getMC(DefaultSkinMgr.SKIN.pro_btn),
				stage.stageWidth - 400,
				7
			);
			_seekBar.x = _playBtn.x + _playBtn.width + 80;
			_seekBar.y = _playBtn.y + (_playBtn.height - _seekBar.height) / 2;//stage.stageHeight - 40;
			_seekBar.addEventListener(SeekBarEvent.CHANGE, function(e:SeekBarEvent){
				_model.seek(_model.duration * e.data);
			});
			_seekBar.addEventListener(SeekBarEvent.TRACK, onSeekStream);
			
			addChild(_seekBar);
		}
		
		private function onSeekStream(e:SeekBarEvent):void {
			var percent:Number = e.data as Number;
			_model.seek(_model.duration * percent);
		}
		
		private function onStatusChange(e:ModelEvent):void {
			trace("status change : " + e.data + "[" + ModelStatus.getName(e.data) + "]");
			
			var status:uint = e.data as uint;
			switch(status) {
				case ModelStatus.PLAY:
					_playHeaderTimer.start();
					_startPlayBtn.visible = false;
					_playBtn.visible = false;
					_pauseBtn.visible = true;
//					_stopBtn.visible = true;
					break;
				case ModelStatus.PAUSE:
					_playHeaderTimer.stop();
					_startPlayBtn.visible = true;
					_pauseBtn.visible = false;
					_playBtn.visible = true;
//					_stopBtn.visible = true;
					break;
				case ModelStatus.BUFFER:
				case ModelStatus.SEEK:
				case ModelStatus.CLOSE:
				case ModelStatus.LOAD:
				case ModelStatus.STOP:
					_playHeaderTimer.stop();
					break;
			}
		}
		
		private function loadStateHandler(e:Event):void {
			_seekBar.assets = _model.byteLoaded / _model.bytesTotal;
		}
		
		private function onPlayHeaderUpdate(second:int):void {
			_TimeText["time_txt"].text = TimeUtils.toFriendly(_model.time) + "/" + TimeUtils.toFriendly(_model.duration);
			
			var rate:Number = _model.time / _model.duration;
			_seekBar.seek(rate);
		}
		
		private function modelEventHandler(event:Event):void {
			if(event is MouseEvent) {
				if(event.type == MouseEvent.MOUSE_UP) _model.togglePause(event);
				else if(event.type == MouseEvent.DOUBLE_CLICK) _model.fullScreen(event);
			} else if(event is KeyboardEvent && (event as KeyboardEvent).keyCode == 32) _model.togglePause(event);
		}
		
		private function fullScreenHandler(e:MouseEvent):void {
			var name:String = (e.target as MovieClip).name;
			if(name == "full_btn") {
				_fullOnBtn.visible = false;
				_fullOffBtn.visible = true;
				_model.fullScreen(e);
			} else if(name == "exitFull_btn") {
				_fullOffBtn.visible = false;
				_fullOnBtn.visible = true;
				_model.fullScreen(e);
			}
		}
		
	}
}