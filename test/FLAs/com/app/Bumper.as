﻿// com.app.Bumper// Adam Riggs//package com.app {	import flash.display.Sprite;	import flash.events.*;		import gs.TweenMax;		import com.adam.utils.AppData;	import com.adam.events.MuleEvent;	import flash.display.MovieClip;	import flash.display.DisplayObject;		public class Bumper extends Sprite {				private var appData:AppData=AppData.instance;				//display objects		public var startBtn:MovieClip;		public var endBtn:MovieClip;		public var rectSp:Sprite;				public function Bumper(){						init();		}		//*****Initialization Routines				public function init(){			//this.visible = false;			trace("Bumper() init");						initVars();			initEvents();			initBlackRectSp();			initStartBtn();			initEndBtn();			drawRect();			resizeMe();		}				private function initVars():void{					}				private function initEvents():void{			appData.eventManager.listen("bumper", onBumper);		}				private function initBlackRectSp():void{			rectSp=new Sprite();			addChildAt(rectSp,0);		}				private function initStartBtn():void{			appData.makeButton(startBtn, this);			startBtn.visible=false;		}				private function initEndBtn():void{			appData.makeButton(endBtn, this);			endBtn.visible=false;		}		//*****Core Functionality				private function resizeMe():void{			/*trace("bumper");			trace("appData.stageWidth=="+appData.stageWidth);			trace("appData.stageHeight=="+appData.stageHeight);*/			drawRect();			centerDO(startBtn);			centerDO(endBtn);		}				private function drawRect():void{			rectSp.graphics.clear();			rectSp.graphics.beginFill(0x000000,1);			rectSp.graphics.drawRect(0,0,appData.stageWidth,appData.stageHeight);			rectSp.graphics.endFill();		}				private function centerDO(dispObj:DisplayObject):void{			dispObj.x=(appData.stageWidth-dispObj.width)/2;			dispObj.y=(appData.stageHeight-dispObj.height)/2;		}				public function showStart():void{			trace("bumper.showStart()");			visible=true;			endBtn.visible=false;			startBtn.visible=true;		}				public function showStop():void{			visible=true;			endBtn.visible=true;			endBtn.totalRewardTxt.text="$"+appData.totalReward.toString();						startBtn.visible=false;		}		//*****Event Handlers				public function onClick(e:MouseEvent):void{			switch(e.currentTarget){								case startBtn:					trace("startBtn");					appData.eventManager.dispatch("main", {type:"startTest", sender:"bumper"});				break;								case endBtn:					trace("endBtn");					appData.eventManager.dispatch("main", {type:"exitFullscreen", sender:"bumper"});				break;							}		}				private function onBumper(e:MuleEvent):void{			switch(e.data.type){								case "resize":					resizeMe();				break;							}		}		//*****Gets and Sets						//*****Utility Functions				public function show(){			this.visible = true;		}				public function hide(){			this.visible = false;		}				}}