package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;	

	public class NPC extends MovieClip
	{
		private var WorldRef;
		
		private var index:uint = 0;
		private var xCollision = 0;
		private var yCollision = 0;
		
		private var life:int = 100;
		
		private var fleeRange:int = 100;
		private var fleeTarget/*:Point*/;
		public var fleeing:Boolean = false;
		
		private var target;				
		private var targetAngle:Number;
		private var targetRelativeAngleBody:Number;
		private var graphicDegs:Number;
		
		public var weaponList:Array = new Array();
		private var currentWeapon:int = 0;
		public var ammoList:Dictionary = new Dictionary();
		private var canFire:Boolean = true;
		
		private var Head;
		private var Graphic;
		private var textBox;
		private var hitBox;
		
		private var Name:String;
		private var greeting:String = 'hello';
		private var greeting2:String = 'hello again, aaaaaaaaaaaaaaaaaaaaaaa';
		private var dangerGreeting:String = 'help!!';
		public var topicList:Array = new Array();
		public var questList:Array = new Array();
		private var greetingRange:int = 50;
		private var metPlayer:int = 0;
		public var withinTalkRange:Boolean = false;
		
		
		public function NPC(Name,greeting,greeting2,dangerGreeting):void
		{
			WorldRef = Engine.world;
			
			this.Name = Name;
			this.greeting = greeting;
			this.greeting2 = greeting2;
			this.dangerGreeting = dangerGreeting;
			
			index = Engine.NPCList.push (this) -1;
			addEventListener(Event.ADDED, isChild, false, 0, true);
		}
		
		public function setGraphics(head,graphic,textbox,hitbox,weaponlist = null,ammolist = null):void
		{
			Head = head;
			Graphic = graphic;
			textBox = textbox;
			hitBox = hitbox;
			
			if (weaponlist != null)
			{
				for (var i:int = 0; i < weaponlist.length; i++)
				{
					Graphic.addChild(new weaponlist[i](parent,this,0,0))
				}
			}
				
			if (ammolist != null)
				ammoList = ammolist;
				
			textBox.speech.autoSize = 'left';
			textBox.speech.text = greeting;
		}
		
		private function isChild(evt:Event):void
		{
			WorldRef = parent;
		}
		
		private function setTarget():void
		{
			fleeTarget = null;
			fleeing = false;
			//fleeTarget = new Point (0,0)
			var xDistance:int = 0;
			var yDistance:int = 0;
			var xDistanceTemp:int = 0;
			var yDistanceTemp:int = 0;
			
			for (var i:int = 0; i < Engine.enemyList.length; i++)
			{
				if (fleeTarget == null)
				{
					if (x < Engine.enemyList[i].x)
						xDistance = Engine.enemyList[i].x - x;
				
					else 
						xDistance = x - Engine.enemyList[i].x;
				
					if (y < Engine.enemyList[i].y)
						yDistance = Engine.enemyList[i].y - y;
				
					else 
						yDistance = y - Engine.enemyList[i].y;
					
					if (Math.sqrt(xDistance * xDistance + yDistance * yDistance) <= fleeRange)
					{
						fleeTarget = Engine.enemyList[i];
						fleeing = true;
					}
				}
				
				else 
				{
					if (x < Engine.enemyList[i].x)
						xDistanceTemp = Engine.enemyList[i].x - x;
				
					else 
						xDistanceTemp = x - Engine.enemyList[i].x;
				
					if (y < Engine.enemyList[i].y)
						yDistanceTemp = Engine.enemyList[i].y - y;
				
					else 
						yDistanceTemp = y - Engine.enemyList[i].y;
					
					if (Math.sqrt(xDistanceTemp * xDistanceTemp + yDistanceTemp * yDistanceTemp) < Math.sqrt(xDistance * xDistance + yDistance * yDistance))
					{
						xDistance = xDistanceTemp;
						yDistance = yDistanceTemp;
						fleeTarget = Engine.enemyList[i];
						fleeing = true;
					}
					
					/*if (Math.sqrt(xDistance * xDistance + yDistance * yDistance) <= senseRange)
					{
						fleeTarget = Engine.enemyList[i];
						fleeing = true;
					}
					
					fleeTarget.x = Engine.enemyList[i].x
					fleeTarget.y = Engine.enemyList[i].y*/
				}
			}
		}
		
		private function lookAtTarget():void
		{
			graphicDegs = Graphic.rotation;
			var headDegs = Head.rotation;
			var targetRelativeAngleHead;	
				
			if (graphicDegs < 0)
				graphicDegs += 360;
				
			if (headDegs < 0)
				headDegs += 360;
				
			//trace (graphicDegs)
			
			targetAngle = Math.atan2(this.target.x - this.x, this.target.y - this.y) /(Math.PI/180);
				
			if (targetAngle < 0)
				targetAngle += 360;
				
			targetRelativeAngleBody = targetAngle + graphicDegs;
			if (targetRelativeAngleBody > 360)
				targetRelativeAngleBody -= 360;
				
			// this rotates the head to face the current target	
			targetRelativeAngleHead = targetAngle + headDegs;
			if (targetRelativeAngleHead > 360)
				targetRelativeAngleHead -= 360;
				
			if (targetRelativeAngleHead > 180 && targetRelativeAngleHead< 360)
			{
				if (targetRelativeAngleHead < 180 + 200 && targetRelativeAngleHead > 180 - 200)
					Head.rotation -= 10;
					
				else	
					Head.rotation -= 4;
			}
			
			else if (targetRelativeAngleHead < 180 && targetRelativeAngleHead > 0)
			{
				if (targetRelativeAngleHead < 180 + 200 && targetRelativeAngleHead > 180 - 200)
					Head.rotation += 10;
					
				else	
					Head.rotation += 4;
			}
			// this rotates the body to face the current target
				
			if (targetRelativeAngleBody > 180 && targetRelativeAngleBody < 360)
				Graphic.rotation  -= 40;
				
			else if (targetRelativeAngleBody < 180 && targetRelativeAngleBody > 0)
				Graphic.rotation += 40;
				
		}
		
		private function flee():void
		{
			graphicDegs = Graphic.rotation;
			var headDegs = Head.rotation;
			var targetRelativeAngleHead;	
				
			if (graphicDegs < 0)
				graphicDegs += 360;
				
			if (headDegs < 0)
				headDegs += 360;
				
			//trace (graphicDegs)
			
			targetAngle = Math.atan2(this.fleeTarget.x - this.x, this.fleeTarget.y - this.y) /(Math.PI/180);
				
			if (targetAngle < 0)
				targetAngle += 360;
				
			targetRelativeAngleBody = targetAngle + graphicDegs;
			if (targetRelativeAngleBody > 360)
				targetRelativeAngleBody -= 360;
				
			// this rotates the head to face the current target	
			targetRelativeAngleHead = targetAngle + headDegs;
			if (targetRelativeAngleHead > 360)
				targetRelativeAngleHead -= 360;
				
			if (targetRelativeAngleHead > 180 && targetRelativeAngleHead< 360)
			{
				if (targetRelativeAngleHead < 180 + 200 && targetRelativeAngleHead > 180 - 200)
					Head.rotation -= 10;
					
				else	
					Head.rotation -= 4;
			}
			
			else if (targetRelativeAngleHead < 180 && targetRelativeAngleHead > 0)
			{
				if (targetRelativeAngleHead < 180 + 200 && targetRelativeAngleHead > 180 - 200)
					Head.rotation += 10;
					
				else	
					Head.rotation += 4;
			}
			// this rotates the body to face the current target
				
			if (targetRelativeAngleBody > 180 + 8 && targetRelativeAngleBody < 360 - 8)
			{
				Graphic.rotation  -= 10;
				
				if (weaponList[currentWeapon] != null)
					weaponList[currentWeapon].endFire();
			}
			
			else if (targetRelativeAngleBody < 180 - 8 && targetRelativeAngleBody > 0 + 8)
			{
				Graphic.rotation += 10;
				
				if (weaponList[currentWeapon] != null)
					weaponList[currentWeapon].endFire();
			}
			
				
			else
				fire();
				
			/*else
				Graphic.rotation = targetAngle;*/
				
			this.y -= (Math.cos(targetAngle * (Math.PI/180)) * 2.5);												
			this.x -= (Math.sin(targetAngle * (Math.PI/180)) * 2.5);
		}
		
		private function collide ():void
			{
				/*for (var i:int = 0; i < Engine.ammoList.length; i++)
				{
					if (hitBox.hitTestObject(Engine.ammoList[i]))
					{
						Engine.ammoList[i].giveAmmo(this);
					}
				}*/
				
				
				for (var i:int = 0; i < Engine.moveableObstacleList.length; i++)
				{
					/*if (Engine.moveableObstacleList[i].alpha == 100 && weaponList[currentWeapon].hitTestObject(Engine.moveableObstacleList[i]))
					{
						canFire = false;
					}*/
					
					if (Engine.moveableObstacleList[i].alpha == 100 && hitBox.hitTestObject(Engine.moveableObstacleList[i]))
					{
						if (this.x > Engine.moveableObstacleList[i].x)
						{
							xCollision = ( (Engine.moveableObstacleList[i].x + Engine.moveableObstacleList[i].width /2)-(this.x - this.hitBox.width /2) );	
							
						}
						
						else if (this.x < Engine.moveableObstacleList[i].x)
						{
							xCollision = ( (this.x + this.hitBox.width /2)-(Engine.moveableObstacleList[i].x - Engine.moveableObstacleList[i].width /2));		
													
						}
						
						if (this.y > Engine.moveableObstacleList[i].y)
						{
							yCollision = ( (Engine.moveableObstacleList[i].y + Engine.moveableObstacleList[i].height /2)-(this.y - this.hitBox.height /2) );		
							
						}		
						
						else if (this.y < Engine.moveableObstacleList[i].y)
						{
							yCollision = ( (this.y + this.hitBox.height /2)-(Engine.moveableObstacleList[i].y - Engine.moveableObstacleList[i].height /2));							
						}
						
						if (xCollision < yCollision)
						{
							if (this.x > Engine.moveableObstacleList[i].x)
							{
								this.x += xCollision /2;
								Engine.moveableObstacleList[i].x -= xCollision /2;
							}
							
							else if (this.x < Engine.moveableObstacleList[i].x)
							{
								this.x -= xCollision /2;
								Engine.moveableObstacleList[i].x += xCollision /2;
							}
						}
						
						else if (yCollision < xCollision)
						{
							if (this.y > Engine.moveableObstacleList[i].y)
							{
								this.y += yCollision /2;
								Engine.moveableObstacleList[i].y -= yCollision /2;
							}
								
							else if (this.y < Engine.moveableObstacleList[i].y)
							{
								this.y -= yCollision /2;
								Engine.moveableObstacleList[i].y += yCollision /2;
							}
						}		
						Engine.moveableObstacleList[i].collide();
						//return;
					}	
				}
				
				for (var i:int = 0; i < Engine.lowMoveableObstacleList.length; i++)
				{
					if (Engine.lowMoveableObstacleList[i].alpha == 100 && hitBox.hitTestObject(Engine.lowMoveableObstacleList[i]))
					{
						if (this.x > Engine.lowMoveableObstacleList[i].x)
						{
							xCollision = ( (Engine.lowMoveableObstacleList[i].x + Engine.lowMoveableObstacleList[i].width /2)-(this.x - this.hitBox.width /2) );	
							
						}
						
						else if (this.x < Engine.lowMoveableObstacleList[i].x)
						{
							xCollision = ( (this.x + this.hitBox.width /2)-(Engine.lowMoveableObstacleList[i].x - Engine.lowMoveableObstacleList[i].width /2));		
													
						}
						
						if (this.y > Engine.lowMoveableObstacleList[i].y)
						{
							yCollision = ( (Engine.lowMoveableObstacleList[i].y + Engine.lowMoveableObstacleList[i].height /2)-(this.y - this.hitBox.height /2) );		
							
						}		
						
						else if (this.y < Engine.lowMoveableObstacleList[i].y)
						{
							yCollision = ( (this.y + this.hitBox.height /2)-(Engine.lowMoveableObstacleList[i].y - Engine.lowMoveableObstacleList[i].height /2));							
						}
						
						if (xCollision < yCollision)
						{
							if (this.x > Engine.lowMoveableObstacleList[i].x)
							{
								this.x += xCollision /2;
								Engine.lowMoveableObstacleList[i].x -= xCollision /2;
							}
							
							else if (this.x < Engine.lowMoveableObstacleList[i].x)
							{
								this.x -= xCollision /2;
								Engine.lowMoveableObstacleList[i].x += xCollision /2;
							}
						}
						
						else if (yCollision < xCollision)
						{
							if (this.y > Engine.lowMoveableObstacleList[i].y)
							{
								this.y += yCollision /2;
								Engine.lowMoveableObstacleList[i].y -= yCollision /2;
							}
								
							else if (this.y < Engine.lowMoveableObstacleList[i].y)
							{
								this.y -= yCollision /2;
								Engine.lowMoveableObstacleList[i].y += yCollision /2;
							}
						}		
						Engine.lowMoveableObstacleList[i].collide();
						//return;
					}	
				}
				
				for (var i:int = 0; i < Engine.obstacleList.length; i++)
				{
					/*if (Engine.obstacleList[i].alpha == 100 && weaponList[currentWeapon].hitTestObject(Engine.obstacleList[i]))
					{
						canFire = false;
					}*/
					
						
					// player
					if (Engine.obstacleList[i].alpha == 100 && hitBox.hitTestObject(Engine.obstacleList[i]))
					{
						if (this.x > Engine.obstacleList[i].x)
						{
							xCollision = ( (Engine.obstacleList[i].x + Engine.obstacleList[i].width /2)-(this.x - this.hitBox.width /2) );	
							
						}
						
						else if (this.x < Engine.obstacleList[i].x)
						{
							xCollision = ( (this.x + this.hitBox.width /2)-(Engine.obstacleList[i].x - Engine.obstacleList[i].width /2));		
													
						}
						
						if (this.y > Engine.obstacleList[i].y)
						{
							yCollision = ( (Engine.obstacleList[i].y + Engine.obstacleList[i].height /2)-(this.y - this.hitBox.height /2) );		
							
						}		
						
						else if (this.y < Engine.obstacleList[i].y)
						{
							yCollision = ( (this.y + this.hitBox.height /2)-(Engine.obstacleList[i].y - Engine.obstacleList[i].height /2));							
						}
						
						if (xCollision < yCollision)
						{
							if (this.x > Engine.obstacleList[i].x)
								this.x += xCollision ;
								
							else if (this.x < Engine.obstacleList[i].x)
								this.x -= xCollision ;
						}
						
						else if (yCollision < xCollision)
						{
							if (this.y > Engine.obstacleList[i].y)
								this.y += yCollision ;
								
							else if (this.y < Engine.obstacleList[i].y)
								this.y -= yCollision ;
						}						
						//return;
					}	
					
				}
				
				for (var i:int = 0; i < Engine.lowObstacleList.length; i++)
				{
					if (hitBox.hitTestObject(Engine.lowObstacleList[i]))
					{
						if (this.x > Engine.lowObstacleList[i].x)
						{
							xCollision = ( (Engine.lowObstacleList[i].x + Engine.lowObstacleList[i].width /2)-(this.x - this.hitBox.width /2) );	
							
						}
						
						else if (this.x < Engine.lowObstacleList[i].x)
						{
							xCollision = ( (this.x + this.hitBox.width /2)-(Engine.lowObstacleList[i].x - Engine.lowObstacleList[i].width /2));		
													
						}
						
						if (this.y > Engine.lowObstacleList[i].y)
						{
							yCollision = ( (Engine.lowObstacleList[i].y + Engine.lowObstacleList[i].height /2)-(this.y - this.hitBox.height /2) );		
							
						}		
						
						else if (this.y < Engine.lowObstacleList[i].y)
						{
							yCollision = ( (this.y + this.hitBox.height /2)-(Engine.lowObstacleList[i].y - Engine.lowObstacleList[i].height /2));							
						}
						
						if (xCollision < yCollision)
						{
							if (this.x > Engine.lowObstacleList[i].x)
								this.x += xCollision ;
								
							else if (this.x < Engine.lowObstacleList[i].x)
								this.x -= xCollision ;
						}
						
						else if (yCollision < xCollision)
						{
							if (this.y > Engine.lowObstacleList[i].y)
								this.y += yCollision ;
								
							else if (this.y < Engine.lowObstacleList[i].y)
								this.y -= yCollision ;
						}						
						//return;
					}	
				}
				
				for (var i:int = 0; i < Engine.NPCList.length; i++)
				{
					if (Engine.NPCList[i] != this && Engine.NPCList[i].alpha == 100 && hitBox.hitTestObject(Engine.NPCList[i].hitBox))
					{
						if (this.x > Engine.NPCList[i].x)
						{
							xCollision = ( (Engine.NPCList[i].x + Engine.NPCList[i].hitBox.width /2)-(this.x - this.hitBox.width /2) );	
						}
						
						else if (this.x < Engine.NPCList[i].x)
						{
							xCollision = ( (this.x + this.hitBox.width /2)-(Engine.NPCList[i].x - Engine.NPCList[i].hitBox.width /2));		
						}
						
						if (this.y > Engine.NPCList[i].y)
						{
							yCollision = ( (Engine.NPCList[i].y + Engine.NPCList[i].hitBox.height /2)-(this.y - this.hitBox.height /2) );		
						}		
						
						else if (this.y < Engine.NPCList[i].y)
						{
							yCollision = ( (this.y + this.hitBox.height /2)-(Engine.NPCList[i].y - Engine.NPCList[i].hitBox.height /2));		
						}
						
						if (xCollision < yCollision)
						{
							if (this.x > Engine.NPCList[i].x)
								this.x += xCollision ;
								
							else if (this.x < Engine.NPCList[i].x)
								this.x -= xCollision ;
						}
						
						else if (yCollision < xCollision)
						{
							if (this.y > Engine.NPCList[i].y)
								this.y += yCollision ;
								
							else if (this.y < Engine.NPCList[i].y)
								this.y -= yCollision ;
						}
					}
				}
				
				if (hitBox.hitTestObject(Engine.player.hitBox))
				{
					
					if (this.x > Engine.player.x)
					{
						xCollision = ( (Engine.player.x + Engine.player.hitBox.width /2)-(this.x - this.hitBox.width /2) );	
							
					}
						
					else if (this.x < Engine.player.x)
					{
						xCollision = ( (this.x + this.hitBox.width /2)-(Engine.player.x - Engine.player.hitBox.width /2));		
														
					}
						
					if (this.y > Engine.player.y)
					{
						yCollision = ( (Engine.player.y + Engine.player.hitBox.height /2)-(this.y - this.hitBox.height /2) );		
						
					}		
					
					else if (this.y < Engine.player.y)
					{
						yCollision = ( (this.y + this.hitBox.height /2)-(Engine.player.y - Engine.player.hitBox.height /2));		
												
					}
					
					if (xCollision < yCollision)
					{
						if (this.x > Engine.player.x)
							this.x += xCollision ;
							
						else if (this.x < Engine.player.x)
							this.x -= xCollision ;
					}
						
					else if (yCollision < xCollision)
					{
						if (this.y > Engine.player.y)
							this.y += yCollision ;
								
						else if (this.y < Engine.player.y)
							this.y -= yCollision ;
					}
				}
				
				for (var i:int = 0; i < Engine.vehicleList.length; i++)
				{		
					var pointGlobal = Engine.world.localToGlobal(new Point(x,y))
 
					if (Engine.vehicleList[i].hit.hitTestPoint(pointGlobal.x,pointGlobal.y,true))
					{
						pointGlobal = Engine.vehicleList[i].globalToLocal(Engine.world.localToGlobal(new Point(x,y)));
						
						if (pointGlobal.x > 0)
						{
							xCollision = ((Engine.vehicleList[i].hit.width /2)-(pointGlobal.x) );	
						}
						
						else if (pointGlobal.x < 0)
						{
							xCollision = ((pointGlobal.x)+(Engine.vehicleList[i].hit.width /2) );	
						}
					
						if (pointGlobal.y > 0)
						{
							yCollision = ((Engine.vehicleList[i].hit.height /2)-(pointGlobal.y) );	
						}
					
						else if (pointGlobal.y < 0)
						{
							yCollision = ((pointGlobal.y)+(Engine.vehicleList[i].hit.height /2) );	
						}
					
						if (xCollision < yCollision)
						{
							if (pointGlobal.x > 0)
							{
								Engine.vehicleList[i].col.x = xCollision + pointGlobal.x;
								pointGlobal = globalToLocal(Engine.vehicleList[i].localToGlobal(new Point(xCollision + pointGlobal.x,pointGlobal.y)));
							}
								
							else if (pointGlobal.x < 0)
							{
								Engine.vehicleList[i].col.x = pointGlobal.x - xCollision;
								pointGlobal = globalToLocal(Engine.vehicleList[i].localToGlobal(new Point(pointGlobal.x - xCollision,pointGlobal.y)));
							}
						}
						
						if (yCollision < xCollision)
						{
							if (pointGlobal.y > 0)
							{
								Engine.vehicleList[i].col.y = yCollision + pointGlobal.y;
								pointGlobal = globalToLocal(Engine.vehicleList[i].localToGlobal(new Point(pointGlobal.x,yCollision + pointGlobal.y)));
							}
								
							else if (pointGlobal.y < 0)
							{
								Engine.vehicleList[i].col.y = pointGlobal.y - yCollision;
								pointGlobal = globalToLocal(Engine.vehicleList[i].localToGlobal(new Point(pointGlobal.x,pointGlobal.y - yCollision)));
							}
						}
					
						x += pointGlobal.x;
						y += pointGlobal.y;
					}
				}
			}
			
		private function greet():void
		{
			var xDistance:int = 0;
			var yDistance:int = 0;
			
			if (x < Engine.player.x)
				xDistance = Engine.player.x - x;
				
			else 
				xDistance = x - Engine.player.x;
				
			if (y < Engine.player.y)
				yDistance = Engine.player.y - y;
				
			else 
				yDistance = y - Engine.player.y;
				
			if (Math.sqrt(xDistance * xDistance + yDistance * yDistance) <= greetingRange)
			{
				withinTalkRange = true;
				
				if (fleeing == true)
					textBox.speech.text = dangerGreeting;
					
				else if (metPlayer == 2)
					textBox.speech.text = greeting2;
				
				/*textBox.width = textBox.speech.height;
				textBox.height = textBox.speech.width;*/
				textBox.alpha = 100;
				
				if (metPlayer == 0)
					metPlayer = 1;
			}
			
			else
			{
				withinTalkRange = false;
				textBox.alpha = 0;
				
				if (metPlayer == 1)
				{
					metPlayer = 2;
				}
			}
		}
		
		public function talk():void
		{
			Engine.player.HUDRef.speech.alpha = 100;
		}
		
		public function fire():void
		{
			if (weaponList[currentWeapon] != null && canFire == true)
			{
				weaponList[currentWeapon].mouseButton = true;
				weaponList[currentWeapon].fire();
			}
		}
		
		public function loop():void
		{
			setTarget();
			
			if (fleeing == true)
			{
				flee();
			}
			
			else if (weaponList[currentWeapon] != null)
				weaponList[currentWeapon].endFire();

			
			canFire = true;
			
			greet();
			
			//fleeing = false;
			
			collide();
			
			
		}
		
		public function takeHit(damage):void
		{
			life -= damage;
			
			WorldRef.addChildAt (new Blood(WorldRef,x,y,Math.random()*360,Math.random()*360),1);

			if (life <= 0)
				removeSelf();
		}
		
		public function removeSelf():void
		{
			if (WorldRef.contains(this))									//checks if bullet is in StageRef
				WorldRef.removeChild(this);									
				
			for (var i:int = 0; i < Engine.NPCList.length; i++)
				if (Engine.NPCList[i] == this)
					Engine.NPCList.splice (i,1)
					
		}
	}
}
