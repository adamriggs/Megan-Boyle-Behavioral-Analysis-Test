﻿// com.app.TestBackground// Adam Riggs//package com.app{	import flash.display.Sprite;	import flash.events.*;	import flash.geom.Rectangle;	import gs.TweenMax;	import com.adam.utils.AppData;	import com.adam.events.MuleEvent;	import flash.display.MovieClip;	public class TestBackground extends Sprite {		private var appData:AppData=AppData.instance;				public var redSprite,blueSprite,yellowSprite:Sprite;		private var spriteArray:Array;				private var tweenTime:int;		public function TestBackground() {			init();		}//*****Initialization Routines		public function init() {			//this.visible = false;			trace("TestBackground() init");						initVars();			//initColors();			initRects();			showRed();		}				private function initVars():void{			spriteArray=new Array();			redSprite=new Sprite();			blueSprite=new Sprite();			yellowSprite=new Sprite();		}				/*private function initColors():void{			trace("TestBackground.initColors()");			colorsArray=new Array();			colorsArray.push(0x000099);			colorsArray.push(0x990000);		}*/				private function initRects():void{			trace("TestBackground.initRects()");			//redSprite=makeRect();//			blueSprite=makeRect();			for(var i:uint=0;i<spriteArray.length;i++){				removeChild(spriteArray[i]);			}			spriteArray=new Array();			redSprite=makeRect(redSprite,0x990000);			blueSprite=makeRect(blueSprite,0x000099);			yellowSprite=makeRect(yellowSprite,0xFFFF00);			//showRed();		}		//*****Core Functionality				private function makeRect(s:Sprite, color:int):Sprite{			trace("makeRect()");			s=new Sprite();			s.graphics.beginFill(color);			s.graphics.drawRect(0,0,appData.stageWidth,appData.stageHeight);			addChild(s);			spriteArray.push(s);			trace("end makeRect()");						return s;		}				/*private function makeRect():Sprite{			trace("TestBackground.makeRect()");						var color:uint=colorsArray.pop();			var colorString:String="0x"+color.toString(16);			var s:Sprite;						s=new Sprite();			s.graphics.lineStyle(1,uint(Number(colorString)));			s.graphics.beginFill(uint(Number(colorString)));			s.graphics.drawRect(0,0,appData.main.width,appData.main.height);			addChild(s);						return s;		}*/				public function showBlue():void{			trace("TestBackground.showBlue()");			showSprite(blueSprite);			hideSprite(redSprite);			hideSprite(yellowSprite);		}				public function showRed():void{			trace("TestBackground.showRed()");			showSprite(redSprite);			hideSprite(blueSprite);			hideSprite(yellowSprite);		}				public function showYellow():void{			showSprite(yellowSprite);			hideSprite(blueSprite);			hideSprite(redSprite);		}				private function showSprite(s:Sprite):void{			trace("TestBackground.showSprite()");			s.visible=true;		}				private function hideSprite(s:Sprite):void{			trace("TestBackground.hideSprite()");			s.visible=false;		}				public function flip():void{			trace("TestBackground.flip()");			if(blueSprite.visible){				hideSprite(blueSprite);				showSprite(redSprite);			} else {				showSprite(blueSprite);				hideSprite(redSprite);			}		}				public function resizeMe():void{			initRects();		}//*****Event Handlers//*****Gets and Sets		//*****Utility Functions		public function show(spr:Sprite=null) {			this.visible=true;		}		public function hide() {			this.visible=false;		}	}}