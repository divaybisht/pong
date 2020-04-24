push = require 'push'
Class  = require 'class'
require 'Paddle'
require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243
PADDLE_SPEED = 200 

--[[
    Runs when the game first starts up, only once; used to initialize the game.
]]
function love.load()
    -- use nearest-neighbor filtering on upscaling and downscaling to prevent blurring of text 
    -- and graphics; try removing this function to see the difference!
    love.graphics.setDefaultFilter('nearest', 'nearest')
 
     math.randomseed(os.time())    --update
      
    smallFont = love.graphics.newFont('font.ttf',10)

      love.graphics.setFont(smallFont)
      scorefont =  love.graphics.newFont('font.ttf',20)
     largeFont  = love.graphics.newFont('font.ttf',30)

    
      -- initialize our virtual resolution, which will be rendered within our
    -- actual window no matter its dimensions; replaces our love.window.setMode call
    -- from the last example
        push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true 
            })
      servingPlayer = 1
         winningPlayer = 0
    player1Score = 0
    player2Score = 0 
    --PADDLE_SPEED positions on Yaxis up and down
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
    

    -- place a ball in the middle of the screen
    ball = Ball(VIRTUAL_WIDTH / 2 + 5, VIRTUAL_HEIGHT / 2 - 2, 4 , 4)
   
    -- game state variable used to transition between different parts of the game
    -- (used for beginning, menus, main game, high score list, etc.)
    -- we will use this to determine behavior during render and update

gameState = 'start'


 end
  
 function love.resize(w, h)
  push:resize(w, h)
end



 function love.update(dt)
   
    if gameState == 'serve' then
      ball.dy = math.random(-50, 50)
      if servingPlayer == 1 then
         ball.dx = math.random(140, 200)
      else
        ball.dx = -math.random(140, 200)
      end 

      elseif gameState == 'play' then
         if ball:collides(player1) then
           ball.dx = -ball.dx * 1.05
           ball.x = player1.x + 5

          if ball.dy < 0 then 
             ball.dy = -math.random(10, 150)
             else
             ball.dy = math.random(10, 150)
          end
     
         end

        if ball:collides(player2) then
          ball.dx = -ball.dx * 1.05
          ball.x = player2.x - 4

            if ball.dy < 0 then 
              ball.dy = -math.random(10, 150) 
            else
               ball.dy = math.random(10 ,150)
            end
        end

  if ball.y <=0 then
    ball.y = 0 
    ball.dy = -ball.dy
  end

   if ball.y >= VIRTUAL_HEIGHT - 4 then
    ball.y = VIRTUAL_HEIGHT - 4
    ball.dy = -ball.dy 
   end 

  


    if ball.x < 0  then
      servingPlayer = 1 
      player2Score = player2Score + 1

      if player2Score == 10 then
        winningPlayer = 2 
        servingPlayer = 1 
        gameState = 'done'
      else 
        gameState = 'serve'
      ball:reset()
      end
    end


    if ball.x > VIRTUAL_WIDTH - 4  then
     servingPlayer = 2 
     player1Score = player1Score +1
     
     if player1Score == 10 then
    winningPlayer = 1 
    gameState = 'done'
     else
    gameState = 'serve'
     ball: reset()
     
      end
    end

  end

   --for restricting paddle
   
    if love.keyboard.isDown('w')  then
     player1.dy = -PADDLE_SPEED
   
     
   elseif love.keyboard.isDown('s') then
     player1.dy = PADDLE_SPEED
   else 
     player1.dy = 0
   
    end
   if love.keyboard.isDown('up') then
    player2.dy = -PADDLE_SPEED
   elseif love.keyboard.isDown('down')  then
    player2.dy = PADDLE_SPEED
   else
    player2.dy = 0

   end

   --update ball position 
    if gameState == 'play' then
     ball:update(dt)
    end 

    player1:update(dt)
    player2:update(dt)
end




function love.keypressed(key)    
  -- keys can be accessed by string name
  if key == 'escape' then
      -- function LÖVE gives us to terminate application
      love.event.quit()
  
  elseif key == 'enter' or key == 'return' then
    if gameState =='start' then
      gameState = 'serve'
    elseif gameState == 'serve' then
      gameState = 'play'
    elseif gameState == 'done' then
    gameState = 'serve'
    ball:reset()


    player1Score = 0
    player2Score = 0
    

    if winningPlayer ==1 then
      servingPlayer = 2 
      else
        servingPlayer = 1 
    end
   end
end
end

--[[ss
    Called after update by LÖVE2D, used to draw anything to the screen, 
    updated or otherwise.
]]
function love.draw()
    -- begin rendering at virtual resolution

    
    push:start()
    
     love.graphics.setColor(1,0,0,1)

    
    love.graphics.clear(.54,0,1)
   
    displayScore()
    if gameState == 'start' then
                 love.graphics.printf('hello welcome  to pong  ', 0 ,20 , VIRTUAL_WIDTH ,'center')
            elseif gameState == 'serve' then
             love.graphics.setFont(smallFont)
              love.graphics.printf('serving player :' ..tostring(servingPlayer) , 0 , 20 , VIRTUAL_WIDTH /2 , 'center')
              love.graphics.setFont(smallFont)
              love.graphics.printf('press enter to serve ' , 0 , 50 , VIRTUAL_WIDTH /2 , 'center')

          elseif gameState == 'play' then


        elseif gameState == 'done'  then
          love.graphics.setFont(largeFont)
          love.graphics.printf('winner : player'..tostring(winningPlayer),0,30,VIRTUAL_WIDTH / 2 , 'center')
          love.graphics.setFont(smallFont)
          love.graphics.printf('press enter to restart ' , 0 , 60 , VIRTUAL_WIDTH /2 , 'center')
             
    end

  
            player1:render() 
            player2:render()
        
            ball:render()
    
            
            displayFPS()
    push:finish()
   

end 


function displayFPS() 
   love.graphics.setFont(smallFont)
   love.graphics.setColor(1,1,0)
   love.graphics.print(' Made By : DIVB ' , VIRTUAL_WIDTH - 100 , 10 )

   love.graphics.print(' FPS ' .. tostring(love.timer.getFPS()), 20,10 )
end

function displayScore()
  -- draw score on the left and right center of the screen
  -- need to switch font to draw before actually printing
 -- love.graphics.setFont(scoreFont)
 love.graphics.setColor(1,1,1,1)
 love.graphics.setFont(largeFont)
  love.graphics.print('  '..tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, 
      VIRTUAL_HEIGHT / 3)
  love.graphics.print(' '..tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
      VIRTUAL_HEIGHT / 3)
end