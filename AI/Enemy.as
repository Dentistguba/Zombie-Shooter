package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.URLRequest;

	public class Enemy extends MovieClip
	{
		// references
		private var WorldRef:World;
		private var StageRef:Stage;
		
		// target + vars used to move towards
		private var target;				
		private var targetAngle:Number;
		private var targetRelativeAngleBody:Number;
		private var graphicDegs:Number;
		
		// var used for respawn
		private var position:Point;
		
		//used to check whether enemy has no actual target
		private var wander:Boolean = true;
		
		// config
		private const senseRange = 200;
		private const wanderDistanceMin:int = 10;
		private const wanderDistanceMax:int = 70;
		private var maxHealth = 100;
		private var health:int = 100;
		private var damage:int = 1;
		
		// used when hit by flame: time left till put out
		public var onFire:int = 0;
		
		// used in collision check
		private var xCollision = 0;
		private var yCollision = 0;
		
		private var sound:Sound = new LIQUID2();
		
		public function Enemy(world = null,x = null,y = null):void 
		{
			// adds to list of enemies
			Engine.enemyList.push (this);
			
			this.WorldRef = world;
			this.x = x;
			this.y = y;
		
			//addEventListener (Event.ENTER_FRAME, loop, false, 0, true);		//enter frame listener
		}
		
		// function to rotate toward target 
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
				Graphic.rotation  -= 4;
				
			else if (targetRelativeAngleBody < 180 && targetRelativeAngleBody > 0)
				Graphic.rotation += 4;
		}
		
		// moves towards target
		private function follow():void
		{
			//trace (targetRelativeAngleBody);
			if (targetRelativeAngleBody < 180 + 20 && targetRelativeAngleBody > 180 - 20)
			{
				this.y -= (Math.cos(graphicDegs * (Math.PI/180)) * 2);												
				this.x += (Math.sin(graphicDegs * (Math.PI/180)) * 2);
			}
		}
		
		// sets target if null
		private function setTarget():void
		{
			var xDistance:int;
			var yDistance:int;
			var xDistanceTemp:int;
			var yDistanceTemp:int;
			
			if (wander == false)
				target = null;
			
			if (x < Engine.player.x)
				xDistance = Engine.player.x - x;
				
			else 
				xDistance = x - Engine.player.x;
				
			if (y < Engine.player.y)
				yDistance = Engine.player.y - y;
				
			else 
				yDistance = y - Engine.player.y;
				
			if (Math.sqrt(xDistance * xDistance + yDistance * yDistance) <= senseRange)
			{
				this.target = Engine.player;
				wander = false;
			}
			
			
			for (var i:int = 0; i < Engine.NPCList.length; i++)
			{
				if (this.target == null)
				{
					if (x < Engine.NPCList[i].x)
						xDistance = Engine.NPCList[i].x - x;
				
					else 
						xDistance = x - Engine.NPCList[i].x;
				
					if (y < Engine.NPCList[i].y)
						yDistance = Engine.NPCList[i].y - y;
				
					else 
						yDistance = y - Engine.NPCList[i].y;
					
					if (Math.sqrt(xDistance * xDistance + yDistance * yDistance) <= senseRange)
					{
						this.target = Engine.NPCList[i];
						wander = false;
					}
				}
					
				else 
				{
					if (Engine.NPCList[i].x < x)
						xDistanceTemp = Engine.NPCList[i].x - x;
						
					else 
						xDistanceTemp = x - Engine.NPCList[i].x;
							
					if (y < Engine.NPCList[i].y)
						yDistanceTemp = Engine.NPCList[i].y - y;
							
					else 
						yDistanceTemp = y - Engine.NPCList[i].y;
					
					if (Math.sqrt(xDistanceTemp * xDistanceTemp + yDistanceTemp * yDistanceTemp) < Math.sqrt(xDistance * xDistance + yDistance * yDistance))
					{						
						xDistance = xDistanceTemp;
						yDistance = yDistanceTemp;
						
						this.target = Engine.NPCList[i];
						wander = false;
							
						/*if (Math.sqrt(xDistance * xDistance + yDistance * yDistance) <= senseRange)
						{
							this.target = Engine.NPCList[i];
							wander = false;
						}*/
					}
				}
			}
			
			if (wander == true || target == null)
			{
				if (this.target == null || (this.y < (this.target.y + 1) && this.y > (this.target.y - 1)) && (this.x < (this.target.x + 1) && this.x > (this.target.x - 1)))
				{
					this.target = new Point(this.x +((Math.random() - 0.5) *2)  * wanderDistanceMax + wanderDistanceMin,this.y + ((Math.random() - 0.5) *2) * wanderDistanceMax + wanderDistanceMin );
					wander = true;
				}
			}
			
			/*else if (wander== false && (y > (this.target.y + senseRange) || this.y < (this.target.y - senseRange)|| this.x > (this.target.x + senseRange) || this.x < (this.target.x - senseRange)))
			{
				this.target = new Point(this.x +((Math.random() - 0.5) *2) * wanderDistanceMax,this.y + ((Math.random() - 0.5) *2) * wanderDistanceMax);
				wander = true;
			}*/
		}
		
		// collides with: enemies,player and all obstacles
		// calculates x + y overlap amounts, then moves self out by the smallest overlap
		// for moveable obstacles it simply divides this movement equally between it and obstacle, then running obstacle collision test
		// if enemy hits player its takeHit function runs
		
		private function collide():void
		{
			for (var i:int = 0; i < Engine.moveableObstacleList.length; i++)
				{
					if (Engine.moveableObstacleList[i].alpha == 100 && hitTestObject(Engine.moveableObstacleList[i]))
					{
						if (this.x > Engine.moveableObstacleList[i].x)
						{
							xCollision = ( (Engine.moveableObstacleList[i].x + Engine.moveableObstacleList[i].width /2)-(this.x - this.width /2) );	
							
						}
						
						else if (this.x < Engine.moveableObstacleList[i].x)
						{
							xCollision = ( (this.x + this.width /2)-(Engine.moveableObstacleList[i].x - Engine.moveableObstacleList[i].width /2));		
													
						}
						
						if (this.y > Engine.moveableObstacleList[i].y)
						{
							yCollision = ( (Engine.moveableObstacleList[i].y + Engine.moveableObstacleList[i].height /2)-(this.y - this.height /2) );		
							
						}		
						
						else if (this.y < Engine.moveableObstacleList[i].y)
						{
							yCollision = ( (this.y + this.height /2)-(Engine.moveableObstacleList[i].y - Engine.moveableObstacleList[i].height /2));							
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
						if (wander == true)
							this.target = null;
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
						if (wander == true)
							this.target = null;
					}	
				}
			
			for (var i:int = 0; i < Engine.obstacleList.length; i++)
				{
					if (Engine.obstacleList[i].alpha == 100 && hitTestObject(Engine.obstacleList[i]))
					{
						if (this.x > Engine.obstacleList[i].x)
						{
							xCollision = ( (Engine.obstacleList[i].x + Engine.obstacleList[i].width /2)-(this.x - this.width /2) );	
							
						}
						
						else if (this.x < Engine.obstacleList[i].x)
						{
							xCollision = ( (this.x + this.width /2)-(Engine.obstacleList[i].x - Engine.obstacleList[i].width /2));		
														
						}
						
						if (this.y > Engine.obstacleList[i].y)
						{
							yCollision = ( (Engine.obstacleList[i].y + Engine.obstacleList[i].height /2)-(this.y - this.height /2) );		
							
						}		
						
						else if (this.y < Engine.obstacleList[i].y)
						{
							yCollision = ( (this.y + this.height /2)-(Engine.obstacleList[i].y - Engine.obstacleList[i].height /2));		
												
						}
						
						if (xCollision < yCollision)
						{
							if (this.x > Engine.obstacleList[i].x)
								this.x += xCollision +1;
								
							else if (this.x < Engine.obstacleList[i].x)
								this.x -= xCollision -1;
						}
						
						else if (yCollision < xCollision)
						{
							if (this.y > Engine.obstacleList[i].y)
								this.y += yCollision +1;
								
							else if (this.y < Engine.obstacleList[i].y)
								this.y -= yCollision -1;
						}
						if (wander == true)
							this.target = null;
					}
				}
				
			for (var i:int = 0; i < Engine.lowObstacleList.length; i++)
				{
					if (Engine.lowObstacleList[i].alpha == 100 && hitBox.hitTestObject(Engine.lowObstacleList[i]))
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
						if (wander == true)
							this.target = null;
					}	
				}
					
			for (var i:int = 0; i < Engine.enemyList.length; i++)
				{
					if (Engine.enemyList[i].alpha == 100 && hitTestObject(Engine.enemyList[i].hitBox) && Engine.enemyList[i] != this)
					{
						if (this.x > Engine.enemyList[i].x)
						{
							xCollision = ( (Engine.enemyList[i].x + Engine.enemyList[i].hitBox.width /2)-(this.x - this.hitBox.width /2) );	
							
						}
						
						else if (this.x < Engine.enemyList[i].x)
						{
							xCollision = ( (this.x + this.hitBox.width /2)-(Engine.enemyList[i].x - Engine.enemyList[i].hitBox.width /2));		
														
						}
						
						if (this.y > Engine.enemyList[i].y)
						{
							yCollision = ( (Engine.enemyList[i].y + Engine.enemyList[i].hitBox.height /2)-(this.y - this.hitBox.height /2) );		
							
						}		
						
						else if (this.y < Engine.enemyList[i].y)
						{
							yCollision = ( (this.y + this.hitBox.height /2)-(Engine.enemyList[i].y - Engine.enemyList[i].hitBox.height /2));		
													
						}
						
						if (xCollision < yCollision)
						{
							if (this.x > Engine.enemyList[i].x)
								this.x += xCollision ;
								
							else if (this.x < Engine.enemyList[i].x)
								this.x -= xCollision ;
						}
						
						else if (yCollision < xCollision)
						{
							if (this.y > Engine.enemyList[i].y)
								this.y += yCollision ;
								
							else if (this.y < Engine.enemyList[i].y)
								this.y -= yCollision ;
						}
						if (wander == true)
							this.target = null;
					}
				}
				
				if (hitBox.hitTestObject(Engine.player.hitBox))
				{
					Engine.player.takeHit(damage);
					
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
				
			for (var i:int = 0; i < Engine.NPCList.length; i++)
				{
					if (Engine.NPCList[i].alpha == 100 && hitBox.hitTestObject(Engine.NPCList[i].hitBox))
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
						Engine.NPCList[i].takeHit(damage);
						target = null;
						return;
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
		
		public function takeHit(damage,force,angle):void
		{
			health -= damage;
			
			// fire particle effect
			if (onFire <= 0)
			{
				WorldRef.addChildAt (new zombBlood(WorldRef,x,y,Math.random()*360,Math.random()*360),1);
			}
		
			// bullet push back
			if (force > 0)
			{
				this.y -= (Math.cos(angle) * 5);												
				this.x += (Math.sin(angle) * 5);
			}
		}
					
		public function loop():void			//controls bullet loop
		{			
			setTarget();
				
			if (this.target != null)
			{
				lookAtTarget();
				follow();
			}
			
			collide();
			
			// leaving world
			if (y < 0 || y > WorldRef.worldBoundary.height || x < 0 || x > WorldRef.worldBoundary.width)														//off top of stage
			{
				if (y < 0)
					y += 3;
				
				if (y > WorldRef.worldBoundary.height)
					y -= 3;
					
				if (x < 0)
					x += 3;
					
				if (x > WorldRef.worldBoundary.width)
					x -= 3;
				
				
				this.target = null;
			}
			
			if (onFire > 0)
			{
				onFire -= 1;
				health -= 1;
				WorldRef.addChild (new smallFlame(WorldRef,x + ((Math.random()-0.5) * 10) ,y + ((Math.random()-0.5) * 10),Math.random()*360));
			}
			
			if (health <= 0)
				removeSelf();
			
		}
		
		// respawns at random, non visible location
		public function removeSelf():void									
		{
			//removeEventListener(Event.ENTER_FRAME, loop);					//remove listener
			
			position = new Point (Math.random()*WorldRef.worldBoundary.width,Math.random()*WorldRef.worldBoundary.height); 
			if (((position.x + (180) < Engine.player.x || position.x - (180) > Engine.player.x) && (position.y + (180) < Engine.player.y || position.y - (180) > Engine.player.y)))
			{
				x = position.x;
				y = position.y;
			}
			
			health = maxHealth;
			onFire = 0;
			
			//if (WorldRef.contains(this))									//checks if bullet is in StageRef
				//WorldRef.removeChild(this);									//remove bullet from parent (StageRef)
		}
	}
}