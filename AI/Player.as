package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	
	import flash.geom.Point;

	public class Player extends MovieClip
	{
		// Variables here:
			// world reference (for position e.t.c.)
			private var WorldRef:World;
			private var StageRef:Stage;	
			public var GameRef:Game;
			public var HUDRef:HUD;
			
			// keyboard array
			private var KeyArray:Array = new Array();		
			private var keysDown:int = 0;
			private var mouseButton:Boolean = false;
			
			// stats 
			private const playerSpeed:Number = 5; 
			private var health:int = 100;
			
			// look direction
			private var mouseAngle;
			private var playerDirection:Number = 0;
			private var playerRotation:Number = 0;
			
			// collision
			private var xCollision = 0;
			private var yCollision = 0;
			
			
			// weapons
			public var weaponList:Array = new Array();
			private var currentWeapon:int = 1;
			public var ammoList:Dictionary = new Dictionary();
			private var canFire:Boolean = true;
			
			private var canCloseTalk:Boolean = true;
			private var canOpenTalk:Boolean = true;
			
			private var canCloseQuest:Boolean = true;
			private var canOpenQuest:Boolean = true;
			
			private var Collision:Boolean = false;
			
			public var playerScore:int = 0;
			public var questList:Array = new Array();
			
			private var inVehicle:Boolean = false;
			private var currentVehicle;
			
			private var canExitVehicle:Boolean = false;
			private var canEnterVehicle:Boolean = true;
			
			public var lightGraphic:Shape = new Shape();
			private var lightOn:Boolean = false;
			private var canLightToggle:Boolean = true;
			
		// Methods here:
			// Constructor:
			public function Player (game,world,stageRef:Stage,hud,x,y): void
			{
				this.WorldRef = world;
				this.StageRef = stageRef;
				this.GameRef = game;
				this.HUDRef = hud;
				this.x = x;
				this.y = y;
				
				// gives player initial ammo
				ammoList[Bullet9mm] = 100;
				ammoList[BulletShotgun] = 30;
				ammoList[Flame] = 1000;
				ammoList[TracerBullet] = 1000;
				ammoList[BulletSniper] = 100;
				
				// gives player all weapons
				Graphic.addChild (new Pistol(world,this,0,0))
				Graphic.addChild (new Smg(world,this,0,0))
				Graphic.addChild (new Shotgun(world,this,0,0))
				Graphic.addChild (new Flamethrower(world,this,0,0))
				Graphic.addChild (new Minigun(world,this,0,0))
				Graphic.addChild (new SniperRifle(world,this,0,0))
				
				// fill key array
				for (var i:int = 0; i <  222; i++)				//puts all keys in KeyArray into default false state
				{
					KeyArray.push([i, false]);
				}				
				
				// loop evt listener
				//addEventListener(Event.ENTER_FRAME, loop, false, 0, true); 			   //creates event listener(enter frame event, loop function below, false=, 0=priority, true=) 
				
				// input evt listener
				StageRef.addEventListener(KeyboardEvent.KEY_DOWN, this.checkKeysDown);
				StageRef.addEventListener(KeyboardEvent.KEY_UP, this.checkKeysUp);				
				StageRef.addEventListener (MouseEvent.MOUSE_DOWN, this.mouseTrue);
				StageRef.addEventListener (MouseEvent.MOUSE_UP, this.mouseFalse);
				
				
				WorldRef.darkness.darknessMask.addChild(lightMask);
				lightMask.visible = false;
				lightMask.x = x;
				lightMask.y = y;
				
				WorldRef.darkness.darknessMask.addChild(muzzleFlashMask);
				muzzleFlashMask.x = x
				muzzleFlashMask.y = y
				muzzleFlashMask.visible = false;
			}
			
			// Check key position (edits keyArray):
			private function checkKeysDown(evt:KeyboardEvent) // sets keys in "KeyArray" to true if down
			{
				KeyArray[evt.keyCode][1] = true;
			}
			
			private function checkKeysUp(evt:KeyboardEvent)  // sets keys in "KeyArray" to false if up
			{
				KeyArray[evt.keyCode][1] = false;
				
				if (isKeyDown(69) == false)
				{
					canCloseTalk = true;
					canOpenTalk = true;
					canEnterVehicle = true;
					canExitVehicle = true;
				}
				
				if (isKeyDown(81) == false)
				{
					canCloseQuest = true;
					canOpenQuest = true;
				}
			}	
			
			private function isKeyDown(key) // returns whether a certain key is true(down) or false(up)
			{
				return KeyArray[key][1];
			}		
			
			// mouse button up/down
			private function mouseTrue(evt:MouseEvent)
			{
				mouseButton = true;
				
				if (HUDRef.speech.alpha == 100)
					HUDRef.speech.checkClick();
					
				else if (HUDRef.quest.alpha == 100)
					HUDRef.quest.checkClick();
					
				else
				{
					weaponList[currentWeapon].startFire();
				}
			}
			
			private function mouseFalse(evt:MouseEvent)
			{
				mouseButton = false;
				weaponList[currentWeapon].endFire();
			}
			
			// rotates player to face mouse position
			private function lookAtMouse():void
			{
				var MousePos:Point = WorldRef.globalToLocal (new Point(StageRef.mouseX, StageRef.mouseY));
				
	        	mouseAngle = Math.atan2(MousePos.y - y, MousePos.x - x)*180/Math.PI + 90; 
				
				Graphic.rotation = mouseAngle; 
				light.rotation = mouseAngle; 
				lightMask.rotation = mouseAngle; 
				//trace (Graphic.rotation)
				/*if (mouseAngle < 0)
					mouseAngle += 360;
					
				trace (mouseAngle);*/
			}
			


			// collides with: enemies,player and all obstacles
			// calculates x + y overlap amounts, then moves self out by the smallest overlap
			// for moveable obstacles it simply divides this movement equally between it and obstacle, then running obstacle collision test

			private function collide ():void
			{
				for (var i:int = 0; i < Engine.ammoList.length; i++)
				{
					if (hitBox.hitTestObject(Engine.ammoList[i]))
					{
						Engine.ammoList[i].giveAmmo(this);
					}
				}
				
				
				for (var i:int = 0; i < Engine.moveableObstacleList.length; i++)
				{
					if (Engine.moveableObstacleList[i].alpha == 100 && weaponList[currentWeapon].hitTestObject(Engine.moveableObstacleList[i]))
					{
						canFire = false;
					}
					
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
					if (Engine.obstacleList[i].alpha == 100 && weaponList[currentWeapon].hitTestObject(Engine.obstacleList[i]))
					{
						canFire = false;
					}
					
						
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
			
			// shoots gun
			private function fire():void
			{
				weaponList[currentWeapon].mouseButton = true;
				weaponList[currentWeapon].fire();
			}
			
			public function takeHit(damage):void
			{
				WorldRef.addChildAt (new Blood(WorldRef,x,y,Math.random()*360,Math.random()*360),1);
				health -= damage;
			}
			
			// used by external classes to access health var
			public function getHealth():int
			{
				return (health);
			}
			
			// shines torch
			public function shineTorch()
			{				
				lightMask.scaleY = 1
			
				if(light.contains(lightGraphic))
					light.removeChild(lightGraphic)
					
				lightGraphic = new Shape();
				lightGraphic.graphics.lineStyle(0,0xFFFFFF,0);
				lightGraphic.graphics.moveTo(0,-20)
				lightGraphic.graphics.beginFill(0xFFFFFF,1-WorldRef.darkness.darknessMask.daylight.alpha);
				
				for (var i:int = -1; i < 2; i++)
				{
					var rayPosition:Point = new Point(0,-20)
					
					var	yMove = -18 + Math.abs(i/4)
					var xMove = i*4
					
					for (var n = 0; n < 6; n++)
					{
						rayPosition.y += yMove
						rayPosition.x += xMove
						
						if (n == 5)
						{
							lightMask.scaleY = 1
							
							var pointGlobal = light.localToGlobal(new Point(rayPosition.x,rayPosition.y))
							
							var pointLocal = light.globalToLocal(pointGlobal)
								

							lightGraphic.graphics.lineTo(pointLocal.x, pointLocal.y);
						}
						
						else
						{
							for (var g:int = 0; g < Engine.obstacleList.length; g++)
							{		
								if (Engine.obstacleList[g].alpha == 100)
								{
									var pointGlobal = light.localToGlobal(new Point(rayPosition.x,rayPosition.y))
	 
									if (Engine.obstacleList[g].hitTestPoint(pointGlobal.x,pointGlobal.y,false))
									{
										if (i == 0)
										{
											if(n > 0)
												lightMask.scaleY = 0.5 + (0.5 * (n/4))
												
											else
												lightMask.scaleY = 0.5
										}
										
										n = 100
									
										var pointLocal = light.globalToLocal(pointGlobal)
									
	
										lightGraphic.graphics.lineTo(pointLocal.x, pointLocal.y)
									}
								}
							}
						}
					}
				}
				
				lightGraphic.graphics.endFill();
				light.addChild(lightGraphic);				
			}
			
			//Loop:
			public function loop ():void
			{
				if (inVehicle == false)
				{
					alpha = 100;
					
					for (var i:int = 0; i < Engine.vehicleList.length; i++)
					{
						if (inVehicle == false && canEnterVehicle == true && isKeyDown(69) && x > (Engine.vehicleList[i].x - Engine.vehicleList[i].width/2) - 20 && x < (Engine.vehicleList[i].x + Engine.vehicleList[i].width/2) + 20 && y > (Engine.vehicleList[i].y - Engine.vehicleList[i].height/2) - 20 && y < (Engine.vehicleList[i].y + Engine.vehicleList[i].height/2) + 20)
						{
							inVehicle = true;
							canExitVehicle = false;
							currentVehicle = Engine.vehicleList[i];
							currentVehicle.cacheAsBitmap = false;
						}
					}
				}
				
				if (inVehicle == true)
				{
					alpha = 0;
					
					if (isKeyDown(69) && canExitVehicle == true )
					{
						canEnterVehicle = false;
						inVehicle = false;
					}
					
					if (isKeyDown(65) || isKeyDown(Keyboard.LEFT))		//left arrow
					{
						//currentVehicle.rotateLeft();
						//currentVehicle.collide();
					}
			
					if (isKeyDown (68) || isKeyDown(Keyboard.RIGHT))		//right arrow
					{
						//currentVehicle.rotateRight();
						//currentVehicle.collide();
					}		
				
					if (isKeyDown(87) || isKeyDown(Keyboard.UP))			//up arrow
					{
						currentVehicle.moveForward();
						//currentVehicle.collide();
					}
			
					if (isKeyDown (83) || isKeyDown(Keyboard.DOWN))		//down arrow
					{
						currentVehicle.moveBackward();
						//currentVehicle.collide();
					}		
					
					if (isKeyDown(Keyboard.CONTROL) && GameRef.scaleX > 0)
					{
						GameRef.scaleX -= 0.1;
						GameRef.scaleY -= 0.1;
					}
				
					if (isKeyDown(Keyboard.SHIFT))
					{
						GameRef.scaleX += 0.1;
						GameRef.scaleY += 0.1;
					}
					
					if (currentVehicle is Tank && isKeyDown(49))
						currentVehicle.Loop(isKeyDown(Keyboard.LEFT),isKeyDown(Keyboard.RIGHT),mouseButton,0);
						
					else if (currentVehicle is Tank && isKeyDown(50))
						currentVehicle.Loop(isKeyDown(Keyboard.LEFT),isKeyDown(Keyboard.RIGHT),mouseButton,1);
						
					else if (currentVehicle is Tank)
						currentVehicle.Loop(isKeyDown(Keyboard.LEFT),isKeyDown(Keyboard.RIGHT),mouseButton);
						
					else
						currentVehicle.Loop(isKeyDown(Keyboard.LEFT),isKeyDown(Keyboard.RIGHT));
					
					x = currentVehicle.x;
					y = currentVehicle.y;
				}
				
				if (isKeyDown(69) && inVehicle == false)		
				{
					for (var i:int = 0; i < Engine.NPCList.length; i++)
					{
						if (Engine.NPCList[i].withinTalkRange == true && HUDRef.speech.alpha == 0 && canOpenTalk == true && Engine.NPCList[i].fleeing == false)
						{
							Mouse.show();
							HUDRef.setChildIndex(HUDRef.speech,HUDRef.numChildren-1);
							//HUDRef.speech.clearMenu();
							HUDRef.speech.fillMenu(Engine.NPCList[i]);
							HUDRef.speech.alpha = 100;
							Engine.pauseGame = true;
							canCloseTalk = false;
							return;
						}
					}
					
					if (HUDRef.speech.alpha == 100 && canCloseTalk == true)
					{
						Mouse.hide();
						HUDRef.speech.alpha = 0;
						HUDRef.speech.clearMenu();
						Engine.pauseGame = false;
						canOpenTalk = false;
					}
				}
				
				if (isKeyDown(81) && inVehicle == false)		
				{
					if (HUDRef.quest.alpha == 0 && canOpenQuest == true)
					{
						Mouse.show();
						HUDRef.setChildIndex(HUDRef.quest,HUDRef.numChildren-1);
						HUDRef.quest.alpha = 100;
						HUDRef.quest.fillMenu(questList);
						Engine.pauseGame = true;
						canCloseQuest = false;
						return;
					}
				
					if (HUDRef.quest.alpha == 100 && canCloseQuest == true)
					{
						Mouse.hide();
						HUDRef.quest.alpha = 0;
						HUDRef.quest.clearMenu();
						Engine.pauseGame = false;
						canOpenQuest = false;
					}
				}
				
				
				// this first bit of the loop checks the keyboard
				if (Engine.pauseGame == false && inVehicle == false)
				{
				if (isKeyDown(65) || isKeyDown(Keyboard.LEFT))		//left arrow
				{
					this.x -= playerSpeed;
					playerDirection = 1;			//subtracts playerSpeed from current y position
				}
				
				if (isKeyDown (68) || isKeyDown(Keyboard.RIGHT))		//right arrow
				{
					this.x += playerSpeed;
					playerDirection = 2;				//adds ""                                    ""
				}		
				
				if (isKeyDown(87) || isKeyDown(Keyboard.UP))			//up arrow
				{
					this.y -= playerSpeed;
					playerDirection = 3;				//subtracts playerSpeed from current y position
				}
				
				if (isKeyDown (83) || isKeyDown(Keyboard.DOWN))		//down arrow
				{
					this.y += playerSpeed;
					playerDirection = 4;				//adds ""                                    ""
				}		
				
				// zoom:
				if (isKeyDown(Keyboard.CONTROL) && GameRef.scaleX > 0)
				{
					GameRef.scaleX -= 0.1;
					GameRef.scaleY -= 0.1;
				}
				
				if (isKeyDown(Keyboard.SHIFT))
				{
					GameRef.scaleX += 0.1;
					GameRef.scaleY += 0.1;
				}
				
				// reload
				if (isKeyDown(82))
				{
					weaponList[currentWeapon].forceReload();
				}
				
				// torch
				if (isKeyDown(85) && lightOn == false && canLightToggle == true)
				{
					lightMask.visible = true;
					lightOn = true;
					canLightToggle = false;
				}
				
				else if (isKeyDown(85) && canLightToggle == true)
				{
					lightOn = false;
					lightMask.visible = false;
					if(light.contains(lightGraphic))
						light.removeChild(lightGraphic)
						
					canLightToggle = false;
				}
				
				else if (!(isKeyDown(85)))
					canLightToggle = true
				
				// change weapon (bit to stop multi key press doesn't work)
				keysDown = 0;
			
				for (var i:int = 0; i < KeyArray.length; i++)
				{
					if (KeyArray[i] == true)
					{
						keysDown ++;
					}
				}
				
				if (keysDown <= 1)
				{
					
					
					for (var i:int = 0; i < weaponList.length; i++)
					{
						if (i == currentWeapon)
						{
							weaponList[i].alpha = 100;
						}
					
						else 
							weaponList[i].alpha = 0;
					
						if (isKeyDown(i + 49) && currentWeapon != i)
						{
							if (currentWeapon == 5)
							{
								GameRef.scaleX = 1;
								GameRef.scaleY = 1;
								WorldRef.mouseFollow = false;
								WorldRef.target = null;
								stage.quality = "high";
							}
						
							currentWeapon = i;
						
							if (currentWeapon == 5)
							{
								Engine.obstCheckDistance = Engine.zoomObstCheckDistance;
								Engine.enemyCheckDistance = Engine.zoomEnemyCheckDistance;
								
								GameRef.scaleX = 0.8;
								GameRef.scaleY = 0.8;
								WorldRef.mouseFollow = true;
							}
						}
					}
				}
				
				if (currentWeapon != 5)
				{
					WorldRef.mouseFollow = false;
				}
				
				else 
				{
					Engine.obstCheckDistance = Engine.zoomObstCheckDistance;
					Engine.enemyCheckDistance = Engine.zoomEnemyCheckDistance;
					stage.quality = "medium";
				}

				collide();
				
				// edge of world
				if (y < 0 || y > WorldRef.worldBoundary.height || x < 0 || x > WorldRef.worldBoundary.width)														//off top of stage
				{
					if (y < 0)
						y += playerSpeed;
				
					if (y > WorldRef.worldBoundary.height)
						y -= playerSpeed;
					
					if (x < 0)
						x += playerSpeed;
					
					if (x > WorldRef.worldBoundary.width)
						x -= playerSpeed;
				}
				
				//fire if canFire
				if (mouseButton == true && canFire == true)
					fire();
					
				canFire = true;
				WorldRef.camMove();
				
				lookAtMouse();
				
				HUDRef.UpdateAmmo(ammoList[weaponList[currentWeapon].bulletType]);
				
				HUDRef.UpdateClip(weaponList[currentWeapon].ammo);
					
				HUDRef.UpdateLife(health);
				HUDRef.UpdateDisplay();
				}
				
				for (var i:int = 0; i < questList.length; i++)
				{
					questList[i].checkComplete();
				}
				
				if(lightOn && WorldRef.lightLayer.alpha > 0.1)
				{
					lightMask.x = x;
					lightMask.y = y;
					shineTorch();
				}
			}
				// + checks for input (and runs method if true)
				// + 
	}
}