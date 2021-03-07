package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.ui.Mouse;	
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.events.Event;
	
	public class Engine extends MovieClip
	{
		// Variables:
			//references
			public static var player:Player;
			public static var world;
			private var cursor:Cursor;
			public static var playerHUD:HUD = null;
			
			//game state vars: used to check for game over, menu e.t.c.
			public static var menuScreen:Boolean = false;
			public static var playGame:Boolean = false;
			public static var engineCreated:Boolean = false;
			public static var startPlay:Boolean = true;
			public static var pauseGame = false;
			public static var gameOver:Boolean = false;
			
			//background music
			private var BGM:Sound;
			
			// Object arrays: used by objects to access other objects in the world
			public static var obstacleList:Array = new Array();
			public static var lowObstacleList:Array = new Array();
			public static var moveableObstacleList:Array = new Array();
			public static var lowMoveableObstacleList:Array = new Array();
			public static var enemyList:Array = new Array();		
			public static var NPCList:Array = new Array();
			public static var vehicleList:Array = new Array();
			public static var bulletList:Array = new Array();	
			public static var fireList:Array = new Array();	

			public static var ammoList:Array = new Array();	
			
			public static var obstCheckDistance:int = 500;
			public static var enemyCheckDistance:int = 300;
			
			public static const standardObstCheckDistance:int = 500;
			public static const standardEnemyCheckDistance:int = 300;
			
			public static const zoomObstCheckDistance:int = 800;
			public static const zoomEnemyCheckDistance:int = 750;
			
			private var framerateTracker;
			private var framerateTrackerCountdown:int = 0;
			
		// Methods:
			public function Engine():void
			{
				addEventListener(Event.ENTER_FRAME, loop, false, 0, true); 			   //creates event listener(enter frame event, loop function below, false=, 0=priority, true=) 
				stage.addEventListener(Event.MOUSE_LEAVE, Pause);
			}

			private function Pause(evt:Event = null)
			{
				var sTransform:SoundTransform = new SoundTransform(1,0);
				sTransform.volume = 0;
				SoundMixer.soundTransform = sTransform;
				pauseGame = true;
				addEventListener(MouseEvent.MOUSE_OVER, unPause);
			}
			
			private function unPause(evt:Event = null)
			{
				var sTransform:SoundTransform = new SoundTransform(1,0);
				sTransform.volume = 1;
				SoundMixer.soundTransform = sTransform;
				pauseGame = false;
				removeEventListener(MouseEvent.MOUSE_OVER, unPause);
			}

			private function loop(evt:Event):void
			{
				if (menuScreen == true && playGame == false && gameOver == false)
					gotoAndStop (1,'menu');
				
				if (playGame == true /*&& engineCreated*/ && startPlay && gameOver == false)
				{
					gotoAndStop(1,'game')
					startPlay = false;
				}
				
				// construction of world happens here (as engine constructor is run before preloader)
				// is run at start and whenever the world is removed (restart)
				if (playGame && engineCreated == false && game != null)
				{
					if (BGM == null)
					{
						BGM = new zomb();
						BGM.play(0,int.MAX_VALUE);
					}
				
					Mouse.hide();
				
					//game.scaleX = 1.2;
					//game.scaleY = 1.2;
					
					world = new World (stage);
					game.addChild (world);				
					
					framerateTracker = addChild (new FramerateTracker());
					
					for (var i:int = 0; i < obstacleList.length; i++)
						obstacleList[i].createCorners(world);
						
					for ( i = 0; i < lowObstacleList.length; i++)
						lowObstacleList[i].createCorners(world);
						
					for ( i = 0; i < moveableObstacleList.length; i++)
						moveableObstacleList[i].createCorners(world);
						
					for ( i = 0; i < lowMoveableObstacleList.length; i++)
						lowMoveableObstacleList[i].createCorners(world);
				
					cursor = new Cursor (game,stage,1,1);
					game.addChild (cursor);
					
					playerHUD = new HUD(stage.stageWidth / 2, stage.stageHeight -350, player);
					stage.addChild(playerHUD);
				
					// + create player (and store reference)
					player = new Player (game,world ,stage, playerHUD, world.width / 3, world.height/3);
					world.addChild (player);
				
					//world.addChild (new Spawn(world,0,0))
					world.addChild (new Spawn(stage,world,world.width,world.height))
				
					world.setChildIndex(world.lightLayer,world.numChildren - 1);
					world.setChildIndex(world.darkness,world.numChildren - 1);
					

				
					// makes screen follow player
					world.setCamTarget(player);
				
					//ensures things aren't created more than once
					engineCreated = true;
				}
				
				
				// runs player and zombie loops: was mainly for use with a cell system which was not completed
				// this system would allow larger worlds by only running tests on objects within range of the player
				if (engineCreated == true && playGame == true && gameOver == false && pauseGame == false)
				{
					obstCheckDistance = standardObstCheckDistance;
					enemyCheckDistance = standardEnemyCheckDistance;
					
					player.loop();
					
					if (pauseGame == false)
					{
						for (var i:int = 0; i < lowMoveableObstacleList.length; i++)
						{
							if (lowMoveableObstacleList[i].x > player.x - obstCheckDistance && lowMoveableObstacleList[i].x < player.x + obstCheckDistance && lowMoveableObstacleList[i].y > player.y - obstCheckDistance && lowMoveableObstacleList[i].y < player.y + obstCheckDistance)
							{
								lowMoveableObstacleList[i].alpha = 100;
							}
						
							else
							{
								lowMoveableObstacleList[i].alpha = 0;
							}
						}
					
						for (var i:int = 0; i < moveableObstacleList.length; i++)
						{
							if (moveableObstacleList[i].x > player.x - obstCheckDistance && moveableObstacleList[i].x < player.x + obstCheckDistance && moveableObstacleList[i].y > player.y - obstCheckDistance && moveableObstacleList[i].y < player.y + obstCheckDistance)
							{
								moveableObstacleList[i].alpha = 100;
							}
						
							else	
							{
								moveableObstacleList[i].alpha = 0;
							}
						}
					
						for (var i:int = 0; i < lowObstacleList.length; i++)
						{
							if (lowObstacleList[i].x > player.x - obstCheckDistance && lowObstacleList[i].x < player.x + obstCheckDistance && lowObstacleList[i].y > player.y - obstCheckDistance && lowObstacleList[i].y < player.y + obstCheckDistance)
							{
								lowObstacleList[i].alpha = 100;
								lowObstacleList[i].visible = true;
							}
						
							else
							{
								lowObstacleList[i].alpha = 0;
								lowObstacleList[i].visible = false;
							}
						}
					
					
						for (var i:int = 0; i < obstacleList.length; i++)
						{
							if (obstacleList[i].x > player.x - obstCheckDistance && obstacleList[i].x < player.x + obstCheckDistance && obstacleList[i].y > player.y - obstCheckDistance && obstacleList[i].y < player.y + obstCheckDistance)
							{
								obstacleList[i].alpha = 100;
								obstacleList[i].visible = true;
							}
						
							else
							{
								obstacleList[i].alpha = 0;
								obstacleList[i].visible = false;
							}
						}
					
						for (var i:int = 0; i < enemyList.length; i++)
						{
							if (enemyList[i].x > player.x - enemyCheckDistance && enemyList[i].x < player.x + enemyCheckDistance && enemyList[i].y > player.y - enemyCheckDistance && enemyList[i].y < player.y + enemyCheckDistance)
							{
								enemyList[i].alpha = 100;
								enemyList[i].loop();
							}
						
							else
							{
								enemyList[i].alpha = 0;
							}
						}
					
						for (var i:int = 0; i < NPCList.length; i++)
						{
							if (NPCList[i].x > player.x - enemyCheckDistance && NPCList[i].x < player.x + enemyCheckDistance && NPCList[i].y > player.y - enemyCheckDistance && NPCList[i].y < player.y + enemyCheckDistance)
							{
								NPCList[i].alpha = 100;
								NPCList[i].loop();
							}
						
							else
							{
								NPCList[i].alpha = 0;
							}
						}
					}
				}
				
				
				// this goes to game over screen and clears out the game objects: to be added again if player resets
				if (playGame && engineCreated == true && player.getHealth() <= 0)
				{
					gameOver = true;
					
					enemyList.splice(0,enemyList.length);
					bulletList.splice(0,bulletList.length);
					obstacleList.splice(0,obstacleList.length);
					lowObstacleList.splice(0,lowObstacleList.length);
					moveableObstacleList.splice(0,moveableObstacleList.length);
					lowMoveableObstacleList.splice(0,lowMoveableObstacleList.length);
					
					trace (enemyList.length);
					player = null;
					
						
					game.removeChild(world);
					
					
					Mouse.show();
					gotoAndStop(1,'gameOver');
					playerHUD.alpha = 0;
					playGame = false;
				}
				
				//if (framerateTrackerCountdown == 0)
				//{
				if (framerateTracker != null)
					framerateTracker.getFps();
					//framerateTrackerCountdown = 10;
				//}
					
				//else
					//framerateTrackerCountdown --;

			}
			// 
			

			
			// Loop (runs repeatedly [triggered by event listener])
				// + 
			//  
	}
}