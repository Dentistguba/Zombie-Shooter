package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.BlendMode;

	
	public class Flame extends Bullet
	{
		private var WorldRef:World;
		private var StageRef:Stage;
		private var bulletSpeed = 10;
		private var bulletDirection:Number = 0;	
		private const damage:int = 0;
		private var force:int = 0;
		private var yCollision; 
		private var xCollision;
		private var hitGround:Boolean = false;
		private var createFire:Boolean = true;
		
		private var lightMaskRef;
		
		public function Flame(world,x,y,Direction):void 
		{
			stop();
			super(world,x,y,Direction,bulletSpeed,damage,force);
			bulletDirection = Direction;
			WorldRef = world;
			blendMode = BlendMode.ADD;
			
			lightMaskRef = lightMask;
			WorldRef.darkness.darknessMask.addChild(lightMask)
			lightMask.x = x;
			lightMask.y = y;
		}
		
		// flame is as bullet but slows over time, turns to smoke frame and removes self when stopped
		override public function loop(evt:Event = void):void
		{
			if (Engine.pauseGame == false)
			{
				y -= (Math.sin(bulletDirection *Math.PI/180 +1.58) ) *bulletSpeed;												
				x -= (Math.cos(bulletDirection *Math.PI/180 +1.58) ) *bulletSpeed;
				
				if (bulletSpeed < 9.5)
					gotoAndStop(2)
				
				if (bulletSpeed < 4 && hitGround == false)
				{
					for (var i:int = 0; i < Engine.fireList.length; i++)
					{
						if (Position.hitTestObject(Engine.fireList[i]))
						{
							createFire = false;
							Engine.fireList[i].life = 100;
						}
					}
					
					if (createFire == true)
						WorldRef.addChildAt (new Fire(WorldRef,x,y),1);
						
					hitGround = true;
					gotoAndStop(3)
					
				}
				
				if (bulletSpeed > 0)
				{
					bulletSpeed -=0.5;
					this.scaleX += 0.1;
					this.scaleY += 0.1;
				}
				
				else
				{
					WorldRef.darkness.darknessMask.removeChild(lightMaskRef)
					
					removeSelf();
				}
					
				for (var i:int = 0; i < Engine.moveableObstacleList.length; i++)
				{
					if (Engine.moveableObstacleList[i].alpha == 100 && hitTestObject(Engine.moveableObstacleList[i]))
					{
						if (this.x > Engine.moveableObstacleList[i].x)
						{
							xCollision = ( (Engine.moveableObstacleList[i].x + Engine.moveableObstacleList[i].width /2)-(x - (width/2)));	
							//x ++;
						}
							
						else if (this.x < Engine.moveableObstacleList[i].x)
						{
							xCollision = ( (x + (width/2))-(Engine.moveableObstacleList[i].x - Engine.moveableObstacleList[i].width /2));		
							//x --;
						}
						
						if (this.y > Engine.moveableObstacleList[i].y)
						{
							yCollision = ( (Engine.moveableObstacleList[i].y + Engine.moveableObstacleList[i].height /2)-(y - (height/2)));		
							//y ++;
						}		
						
						else if (this.y < Engine.moveableObstacleList[i].y)
						{
							yCollision = ( (y + (height/2))-(Engine.moveableObstacleList[i].y - Engine.moveableObstacleList[i].height /2));		
							//y --;
						}
							
						if (xCollision < yCollision)
						{
							if (this.x > Engine.moveableObstacleList[i].x)
							{
								this.x += xCollision;
							}
							
							else if (this.x < Engine.moveableObstacleList[i].x)
							{
								this.x -= xCollision;
							}
						}
							
						else if (yCollision < xCollision)
						{
							if (this.y > Engine.moveableObstacleList[i].y)
							{
								this.y += yCollision;
							}
									
							else if (this.y < Engine.moveableObstacleList[i].y)
							{
								this.y -= yCollision;
							}
							
							bulletSpeed -= 0.5;
							scaleX += 0.1;
							scaleY += 0.1;
						}
					}
				}
				
				for (var i:int = 0; i < Engine.obstacleList.length; i++)
					{
						if (Engine.obstacleList[i].alpha == 100 && hitTestObject(Engine.obstacleList[i]))
						{
							if (this.x > Engine.obstacleList[i].x)
							{
								xCollision = ( (Engine.obstacleList[i].x + Engine.obstacleList[i].width /2)-(x -(width/2)));	
								//x ++;
							}
							
							else if (this.x < Engine.obstacleList[i].x)
							{
								xCollision = ( (x + (width/2))-(Engine.obstacleList[i].x - Engine.obstacleList[i].width /2));		
								//x --;
							}
							
							if (this.y > Engine.obstacleList[i].y)
							{
								yCollision = ( (Engine.obstacleList[i].y + Engine.obstacleList[i].height /2)-(y - (height/2)));		
								//y ++;
							}		
							
							else if (this.y < Engine.obstacleList[i].y)
							{
								yCollision = ( (this.y + (height/2))-(Engine.obstacleList[i].y - Engine.obstacleList[i].height /2));		
								//y --;
							}
							
							if (xCollision < yCollision)
							{
								if (this.x > Engine.obstacleList[i].x)
									this.x += xCollision +1;
									
								else if (this.x < Engine.obstacleList[i].x)
									this.x -= xCollision +1;
							}
							
							else if (yCollision < xCollision)
							{
								if (this.y > Engine.obstacleList[i].y)
									this.y += yCollision +1;
									
								else if (this.y < Engine.obstacleList[i].y)
									this.y -= yCollision +1;
							}
							bulletSpeed -= 0.5;
							scaleX += 0.1;
							scaleY += 0.1;
						}
					}
				
				for (var i:int = 0; i < Engine.enemyList.length; i++)
				{
					if (Engine.enemyList[i].alpha == 100 && hitTestObject(Engine.enemyList[i].hitBox))
					{
						
						if (this.x > Engine.enemyList[i].x)
						{
							xCollision = ( (Engine.enemyList[i].x + Engine.enemyList[i].hitBox.width /2)-(this.x) );	
							x ++;
						}
						
						else if (this.x < Engine.enemyList[i].x)
						{
							xCollision = ( (this.x)-(Engine.enemyList[i].x - Engine.enemyList[i].hitBox.width /2));		
							x --;
						}
							
						if (this.y > Engine.enemyList[i].y)
						{
							yCollision = ( (Engine.enemyList[i].y + Engine.enemyList[i].hitBox.height /2)-(this.y) );		
							y ++;
						}		
							
						else if (this.y < Engine.enemyList[i].y)
						{
							yCollision = ( (this.y)-(Engine.enemyList[i].y - Engine.enemyList[i].hitBox.height /2));		
							y --;
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
						
						Engine.enemyList[i].onFire = 80;
						Engine.enemyList[i].takeHit(damage,force,bulletDirection *Math.PI/180);
					}
				}
			}
			
			lightMaskRef.x = x;
			lightMaskRef.y = y;
		}
	}
}