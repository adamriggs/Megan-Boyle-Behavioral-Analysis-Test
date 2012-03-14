﻿// com.app.view.BlackoutView// Adam Riggs//package com.app.view {	import com.adam.events.MuleEvent;	import com.adam.utils.AppData;		import flash.display.Sprite;	import flash.events.*;		public class BlackoutView extends Sprite {				//vars		private var _color:uint;		private var _screenWidth,_screenHeight:uint;		private var _boSprite:Sprite;						//objects		private var appData:AppData=AppData.instance;				//const		public const NAME:String="blackoutView";		public const RETURNTYPE:String=NAME;				public function BlackoutView(){						init();		}		//*****Initialization Routines				public function init():void{			debug("init()");						initVars();			initEvents();			initObjs();		}				private function initVars():void{			_color=0x000000;			_screenHeight		}				private function initEvents():void{			appData.eventManager.listen(NAME, onBlackoutView);			appData.eventManager.listen("sql", onSQL);		}				private function initObjs():void{			_boSprite=new Sprite();			addChild(_boSprite);			drawBlackout();		}		//*****Core Functionality				private function drawBlackout():void{			_boSprite.graphics.clear();			_boSprite.graphics.beginFill(_color);			_boSprite.graphics.drawRect(0,0,appData.stageWidth,appData.stageHeight);		}				public function resizeMe():void{			drawBlackout();		}		//*****Event Handlers				private function onSQL(e:MuleEvent):void{			/*debug("onSQL()");			debug("e.data.sender=="+e.data.sender);			debug("e.data.type=="+e.data.type);*/			switch(e.data.type){								case RETURNTYPE:									break;							}		}				private function onBlackoutView(e:MuleEvent):void{			/*debug("onBlackoutView()");			debug("e.data.sender=="+e.data.sender);			debug("e.data.type=="+e.data.type);*/			switch(e.data.type){																default:					debug("onBlackoutView()");					debug("*type not found");					debug("e.data.sender=="+e.data.sender);					debug("e.data.type=="+e.data.type);				break;							}		}				//*****Gets and Sets						//*****Utility Functions				//**visibility		public function show():void{			this.visible = true;		}				public function hide():void{			this.visible = false;		}				//**debug		private function debug(str:String):void{			appData.debug(NAME,str);		}				}//end class}//end package