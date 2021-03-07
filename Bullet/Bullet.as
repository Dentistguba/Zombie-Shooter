package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.SoundChannel;
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	public class Bullet extends MovieClip
	{
		private var WorldRef:World;
		private var StageRef:Stage;
		private var bulletSpeed:Number = 16;				//speed bullet moves
		private var bulletDirection:Number = 0;	
		private var xMove:Number = 0;	
		private var yMove:Number = 0;	
		
		private var globalX:Number;
		private var globalY:Number;
		protected var Position:Dot;
		
		public var camTarget:Boolean = false;
		
		private var damage:int = 0;
		private var force:int = 0;
		private var ricochet = false;
		protected var range:int = 40;
		private var index:uint = 0;
		private var xCollision;
		private var yCollision;

		private var soundChannel:SoundChannel = new SoundChannel();
		private var ricochetSound:Sound = new Thwack();
		
		public function Bullet(world,x,y,Direction,bulletSpeed,damage,force,camTarget = false,range = 40):void 
		{
			this.camTarget = camTarget;
			addChildAt (Position = new Dot,0)
			index = Engine.bulletList.push (this) -1;
			stop();
			this.WorldRef = world;
			
			if (camTarget == true)
				WorldRef.setCamTarget(this);
				
			this.x = x;
			this.y = y;
			bulletDirection = Direction;
			xMove = Math.cos(bulletDirection *Math.PI/180 +1.58)
			yMove = Math.sin(bulletDirection *Math.PI/180 +1.58)
			this.damage = damage;
			this.force = force;
			this.range = range;
			
			if (bulletSpeed != null)
				this.bulletSpeed = bulletSpeed;
				
			/*if (camTarget == true)
			{
				Engine.player.GameRef.scaleX += 0.4;
				Engine.player.GameRef.scaleY += 0.4;
			}*/
				
			this.rotation = bulletDirection;
		
			addEventListener (Event.ENTER_FRAME, loop, false, 0, true);		//enter frame listener
			addEventListener(Event.ADDED, isChild, false, 0, true);
			
		}
		
		public function loop(evt:Event = void):void								//controls bullet loop
		{
			if (Engine.pauseGame == false)
			{
			this.rotation = bulletDirection;
			
			
			
			if (ricochet == true && scaleX > 0 && bulletSpeed > 0)
			{
				bulletSpeed -= 0.8;
				scaleX -= 0.05;
				scaleY -= 0.05;
			}
				
			if (bulletSpeed <= 0)
			{
				removeSelf();
			}
			
			y -= yMove *bulletSpeed;												
			x -= xMove *bulletSpeed;
			range --;
			
			if (camTarget == true)
			{
				for (var i:int = 0; i < Engine.lowMoveableObstacleList.length; i++)
				{
					if (Engine.lowMoveableObstacleList[i].x > x - Engine.standardObstCheckDistance && Engine.lowMoveableObstacleList[i].x < x + Engine.standardObstCheckDistance && Engine.lowMoveableObstacleList[i].y > y - Engine.standardObstCheckDistance && Engine.lowMoveableObstacleList[i].y < y + Engine.standardObstCheckDistance)
					{
						Engine.lowMoveableObstacleList[i].alpha = 100;
					}
				}
				
				for (var i:int = 0; i < Engine.moveableObstacleList.length; i++)
				{
					if (Engine.moveableObstacleList[i].x > x - Engine.standardObstCheckDistance && Engine.moveableObstacleList[i].x < x + Engine.standardObstCheckDistance && Engine.moveableObstacleList[i].y > y - Engine.standardObstCheckDistance && Engine.moveableObstacleList[i].y < y + Engine.standardObstCheckDistance)
					{
						Engine.moveableObstacleList[i].alpha = 100;
					}
				}
					
				for (var i:int = 0; i < Engine.lowObstacleList.length; i++)
				{
					if (Engine.lowObstacleList[i].x > x - Engine.standardObstCheckDistance && Engine.lowObstacleList[i].x < x + Engine.standardObstCheckDistance && Engine.lowObstacleList[i].y > y - Engine.standardObstCheckDistance && Engine.lowObstacleList[i].y < y + Engine.standardObstCheckDistance)
					{
						Engine.lowObstacleList[i].alpha = 100;
					}
				}
					
					
				for (var i:int = 0; i < Engine.obstacleList.length; i++)
				{
					if (Engine.obstacleList[i].x > x - Engine.standardObstCheckDistance && Engine.obstacleList[i].x < x + Engine.standardObstCheckDistance && Engine.obstacleList[i].y > y - Engine.standardObstCheckDistance && Engine.obstacleList[i].y < y + Engine.standardObstCheckDistance)
					{
						Engine.obstacleList[i].alpha = 100;
					}
				}
					
				for (var i:int = 0; i < Engine.enemyList.length; i++)
				{
					if (Engine.enemyList[i].x > x - Engine.standardEnemyCheckDistance && Engine.enemyList[i].x < x + Engine.standardEnemyCheckDistance && Engine.enemyList[i].y > y - Engine.standardEnemyCheckDistance && Engine.enemyList[i].y < y + Engine.standardEnemyCheckDistance)
					{
						Engine.enemyList[i].alpha = 100;
						Engine.enemyList[i].loop();
					}
				}
			}
			
			collide();
			
			y -= yMove *bulletSpeed;												
			x -= xMove *bulletSpeed;
			range --;
			
			collide();
			
			if (range <= 0)
			{
				removeSelf();
			}
			
			if (y < 0 || y > WorldRef.worldBoundary.height || x < 0 || x > WorldRef.worldBoundary.width)														//off top of stage
			{
				removeSelf();														//removes bullet from stage (method below)
			}
			}
		}
		
		private function collide():void
		{
		
			for (var i:int = 0; i < Engine.moveableObstacleList.length; i++)
			{
				if (Engine.moveableObstacleList[i].alpha == 100 && Position.hitTestObject(Engine.moveableObstacleList[i]))
				{
					if (this.x > Engine.moveableObstacleList[i].x)
					{
						xCollision = ( (Engine.moveableObstacleList[i].x + Engine.moveableObstacleList[i].width /2)-(this.x) );	
						//x ++;
					}
						
					else if (this.x < Engine.moveableObstacleList[i].x)
					{
						xCollision = ( (this.x)-(Engine.moveableObstacleList[i].x - Engine.moveableObstacleList[i].width /2));		
						//x --;
					}
					
					else 
					{
						xCollision = 1000000000;
					}
					
					if (this.y > Engine.moveableObstacleList[i].y)
					{
						yCollision = ( (Engine.moveableObstacleList[i].y + Engine.moveableObstacleList[i].height /2)-(this.y) );		
						//y ++;
					}		
					
					else if (this.y < Engine.moveableObstacleList[i].y)
					{
						yCollision = ( (this.y)-(Engine.moveableObstacleList[i].y - Engine.moveableObstacleList[i].height /2));		
						//y --;
					}
					
					else 
					{
						yCollision = 1000000000;
					}
						
					if (xCollision < yCollision)
					{
						if (this.x > Engine.moveableObstacleList[i].x)
						{
							this.x += xCollision -1;
							xMove = -xMove;
							Engine.moveableObstacleList[i].x -= 1;
						}
						
						else if (this.x < Engine.moveableObstacleList[i].x)
						{
							this.x -= xCollision -1;
							xMove = -xMove
							Engine.moveableObstacleList[i].x += 1;
						}
					}
						
					else if (yCollision < xCollision)
					{
						if (this.y > Engine.moveableObstacleList[i].y)
						{
							this.y += yCollision -1;
							yMove = -yMove;
							Engine.moveableObstacleList[i].y -= 1;
						}
								
						else if (this.y < Engine.moveableObstacleList[i].y)
						{
							this.y -= yCollision -1;
							yMove = -yMove;
							Engine.moveableObstacleList[i].y += 1;
						}
					}
					
					
					Engine.moveableObstacleList[i].collide();
					soundChannel.stop();
					soundChannel = ricochetSound.play();
					ricochet = true;
					bulletDirection = Math.atan2(-yMove, -xMove)*180/Math.PI + 90;
					
				}
			}

			for (var i:int = 0; i < Engine.obstacleList.length; i++)
			{
				if (Engine.obstacleList[i].alpha == 100 && Position.hitTestObject(Engine.obstacleList[i]))
				{
					if (this.x > Engine.obstacleList[i].x)
					{
						xCollision = ( (Engine.obstacleList[i].x + Engine.obstacleList[i].width /2)-(this.x) );	
						//x ++;
					}
						
					else if (this.x < Engine.obstacleList[i].x)
					{
						xCollision = ( (this.x)-(Engine.obstacleList[i].x - Engine.obstacleList[i].width /2));		
						//x --;
					}
					
					if (this.y > Engine.obstacleList[i].y)
					{
						yCollision = ( (Engine.obstacleList[i].y + Engine.obstacleList[i].height /2)-(this.y) );		
						//y ++;
					}		
					
					else if (this.y < Engine.obstacleList[i].y)
					{
						yCollision = ( (this.y)-(Engine.obstacleList[i].y - Engine.obstacleList[i].height /2));		
						//y --;
					}
						
					if (xCollision < yCollision)
					{
						if (this.x > Engine.obstacleList[i].x)
						{
							this.x += xCollision +1;
							xMove = -xMove;
						}
						
						else if (this.x < Engine.obstacleList[i].x)
						{
							this.x -= xCollision +1;
							xMove = -xMove
						}
					}
						
					else if (yCollision < xCollision)
					{
						if (this.y > Engine.obstacleList[i].y)
						{
							this.y += yCollision +1;
							yMove = -yMove;
						}
								
						else if (this.y < Engine.obstacleList[i].y)
						{
							this.y -= yCollision +1;
							yMove = -yMove;
						}
					}
					
					
					ricochet = true;
					soundChannel.stop();
					soundChannel = ricochetSound.play();
					bulletDirection = Math.atan2(-yMove, -xMove)*180/Math.PI + 90;
				}
			}
			
			for (var i:int = 0; i < Engine.enemyList.length; i++)
			{
				if (Engine.enemyList[i].alpha == 100)
				{
					if (Position.hitTestObject(Engine.enemyList[i].hitBox))
					{
						Engine.enemyList[i].takeHit(damage,force,bulletDirection *Math.PI/180);
						removeSelf();
						break;
					}
				}
			}
		}
		
		public function removeSelf():void									
		{
			removeEventListener(Event.ENTER_FRAME, loop);					//remove listener
			
			if (WorldRef.target == this)
				WorldRef.target = Engine.player;
				
			if (camTarget == true)
			{
				WorldRef.mouseFollow = true;
			}
			
			Engine.bulletList.splice (index,1);
			if (WorldRef.contains(this))									//checks if bullet is in StageRef
				WorldRef.removeChild(this);									//remove bullet from parent (StageRef)

		}
		
		public function isChild(evt:Event):void
		{
			collide();
		}
	}
}