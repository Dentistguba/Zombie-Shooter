package
{
	import flash.display.Stage
	import flash.events.Event
	import flash.display.MovieClip
	import flash.geom.Point

	
	public class moveableObstacle extends MovieClip
	{
		public var point1; 
		public var point2;
		public var point3;
		public var point4;
		public var pointList:Array = new Array();
		// collision
		private var xCollision = 0;
		private var yCollision = 0;
		
		public function moveableObstacle()
		{
			Engine.moveableObstacleList.push (this);
		}
		
		public function createCorners(world):void
		{
			pointList.push(addChild(point1 = new Dot(-width/2,-height/2)));
			
			pointList.push(addChild(point2 = new Dot(width/2,-height/2)));
			
			pointList.push(addChild(point3 = new Dot(-width/2,height/2)));
			
			pointList.push(addChild(point4 = new Dot(width/2,height/2)));
		}
		
		public function collide():void
		{
			xCollision = 0;
			yCollision = 0;
			
			for (var i:int = 0; i < Engine.obstacleList.length; i++)
				{
					if(Engine.obstacleList[i].alpha == 100 && hitTestObject(Engine.obstacleList[i]))
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
					}	
				}
				
			for (var i:int = 0; i < Engine.lowObstacleList.length; i++)
				{
					if(Engine.lowObstacleList[i].alpha == 100 && hitTestObject(Engine.lowObstacleList[i]))
					{
						if (this.x > Engine.lowObstacleList[i].x)
						{
							xCollision = ( (Engine.lowObstacleList[i].x + Engine.lowObstacleList[i].width /2)-(this.x - this.width /2) );	
						}
						
						else if (this.x < Engine.lowObstacleList[i].x)
						{
							xCollision = ( (this.x + this.width /2)-(Engine.lowObstacleList[i].x - Engine.lowObstacleList[i].width /2));		
						}
						
						if (this.y > Engine.obstacleList[i].y)
						{
							yCollision = ( (Engine.lowObstacleList[i].y + Engine.lowObstacleList[i].height /2)-(this.y - this.height /2) );		
						}		
						
						else if (this.y < Engine.lowObstacleList[i].y)
						{
							yCollision = ( (this.y + this.height /2)-(Engine.lowObstacleList[i].y - Engine.lowObstacleList[i].height /2));							
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
					}	
				}
			
			for (var i:int = 0; i < Engine.moveableObstacleList.length; i++)
				{
					xCollision = 0;
					yCollision = 0;
					
					if (Engine.moveableObstacleList[i] != this && Engine.moveableObstacleList[i].alpha == 100 && hitTestObject(Engine.moveableObstacleList[i]))
					{
						if (this.x > Engine.moveableObstacleList[i].x)
						{
							xCollision = ( (Engine.moveableObstacleList[i].x + Engine.moveableObstacleList[i].width /2)-(this.x - this.width /2) );	
						}
						
						else if (this.x < Engine.moveableObstacleList[i].x)
						{
							xCollision = ( (this.x + this.width /2)-(Engine.moveableObstacleList[i].x - Engine.moveableObstacleList[i].width /2));		
						}
						
						else 
						{
							xCollision = 1000000000;
						}
						
						if (this.y > Engine.moveableObstacleList[i].y)
						{
							yCollision = ( (Engine.moveableObstacleList[i].y + Engine.moveableObstacleList[i].height /2)-(this.y - this.height /2) );		
						}		
						
						else if (this.y < Engine.moveableObstacleList[i].y)
						{
							yCollision = ( (this.y + this.height /2)-(Engine.moveableObstacleList[i].y - Engine.moveableObstacleList[i].height /2));							
						}
						
						else 
						{
							yCollision = 1000000000;
						}
						
						if (xCollision < yCollision /*&& xCollision > 0*/)
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
						
						else if (yCollision < xCollision /*&& yCollision > 0*/)
						{
							if (this.y > Engine.moveableObstacleList[i].y)
							{
								this.y += yCollision;
							}
								
							else if (this.y < Engine.moveableObstacleList[i].y)
							{
								this.y -= yCollision;
							}
						}	
					}
				}
						
			for (var i:int = 0; i < Engine.lowMoveableObstacleList.length; i++)
				{
					xCollision = 0;
					yCollision = 0;
					
					if (Engine.lowMoveableObstacleList[i].alpha == 100 && hitTestObject(Engine.lowMoveableObstacleList[i]))
					{
						if (this.x > Engine.lowMoveableObstacleList[i].x)
						{
							xCollision = ( (Engine.lowMoveableObstacleList[i].x + Engine.lowMoveableObstacleList[i].width /2)-(this.x - this.width /2) );	
						}
						
						else if (this.x < Engine.lowMoveableObstacleList[i].x)
						{
							xCollision = ( (this.x + this.width /2)-(Engine.lowMoveableObstacleList[i].x - Engine.lowMoveableObstacleList[i].width /2));		
						}
						
						else 
						{
							xCollision = 1000000000;
						}
						
						if (this.y > Engine.lowMoveableObstacleList[i].y)
						{
							yCollision = ( (Engine.lowMoveableObstacleList[i].y + Engine.lowMoveableObstacleList[i].height /2)-(this.y - this.height /2) );		
						}		
						
						else if (this.y < Engine.lowMoveableObstacleList[i].y)
						{
							yCollision = ( (this.y + this.height /2)-(Engine.lowMoveableObstacleList[i].y - Engine.lowMoveableObstacleList[i].height /2));							
						}
						
						else 
						{
							yCollision = 1000000000;
						}
						
						if (xCollision < yCollision)
						{
							if (this.x > Engine.lowMoveableObstacleList[i].x)
							{
								this.x += xCollision / 2;
								Engine.lowMoveableObstacleList[i].x -= xCollision / 2;
							}
							
							else if (this.x < Engine.lowMoveableObstacleList[i].x)
							{
								this.x -= xCollision / 2;
								Engine.lowMoveableObstacleList[i].x -= xCollision / 2;
							}
						}
						
						else if (yCollision < xCollision)
						{
							if (this.y > Engine.lowMoveableObstacleList[i].y)
							{
								this.y += yCollision / 2;
								Engine.lowMoveableObstacleList[i].y -= yCollision / 2;
							}
								
							else if (this.y < Engine.lowMoveableObstacleList[i].y)
							{
								this.y -= yCollision / 2;
								Engine.lowMoveableObstacleList[i].y -= yCollision / 2;
							}
						}	
						
						Engine.lowMoveableObstacleList[i].collide();
					}	
				}
				
				if (y - height < 0 || y + height > Engine.world.worldBoundary.height || x - width < 0 || x + width > Engine.world.worldBoundary.width)														//off top of stage
				{
					if (y - height < 0)
						y += 5;
				
					if (y + height > Engine.world.worldBoundary.height)
						y -= 5;
					
					if (x - width < 0)
						x += 5;
					
					if (x + width > Engine.world.worldBoundary.width)
						x -= 5;
				}
		}
	}
}