function love.load()
    player = { x = 400, y = 550, speed = 300, size = 30 }
    obstacles = {}
    spawnTimer = 0
    prizeTimer = 0
    prizes = {}
    gameOver = false
    score = 0
    music = love.audio.newSource("bgm.mp3", "static")
    music:play()
    
end

function love.update(dt)
    if gameOver then
        if love.keyboard.isDown("r") then
            resetGame()  -- Reiniciar el juego
        end
        return 
    end

    if love.keyboard.isDown("left") then
        player.x = player.x - player.speed * dt
    elseif love.keyboard.isDown("right") then
        player.x = player.x + player.speed * dt
    end

    -- Crear obstáculos cada 2 segundos
    spawnTimer = spawnTimer + dt
    if spawnTimer > 0.3 then
        table.insert(obstacles, { x = math.random(0, 800), y = 0, speed = 200 })
        spawnTimer = 0
    end
    -- crear premios
    prizeTimer = prizeTimer + dt
    if prizeTimer > 5 then
        table.insert(prizes, {x = math.random(0,800), y = 0, size = 20})
        prizeTimer = 0
    end



    -- Mover obstáculos
    for i, obj in ipairs(obstacles) do
        obj.y = obj.y + obj.speed * dt
        if obj.y > 600 then
            table.remove(obstacles, i)
        end

        if player.x < obj.x + 20 and player.x + player.size > obj.x and 
            player.y < obj.y + 20 and player.y + player.size > obj.y then
                gameOver = true
        end
    end

    for i, prize in ipairs(prizes) do
        prize.y = prize.y + 150 * dt  -- Velocidad de caída de los premios
        if prize.y > 600 then
            table.remove(prizes, i)  -- Eliminar el premio si sale de la pantalla
        end

        -- Verificar si el jugador recoge el premio
        if player.x < prize.x + prize.size and player.x + player.size > prize.x and
            player.y < prize.y + prize.size and player.y + player.size > prize.y then
                score = score + 10  -- Sumar puntos al jugador
                table.remove(prizes, i)  -- Eliminar el premio al recogerlo
        end
    end
end

function love.draw()
    if gameOver then
        love.graphics.print("Game Over", 350, 250)
        love.graphics.print("Press 'R' to restart", 350, 300)
        love.graphics.print("Score: " .. score, 350, 350)
        return
    end
    love.graphics.setColor(255,255,255)
    love.graphics.rectangle("fill", player.x, player.y, player.size, player.size)

    for _, obj in pairs(obstacles) do
        love.graphics.setColor(255,0,0)
        love.graphics.rectangle("fill", obj.x, obj.y, 20, 20)
    end

    for _, prize in pairs(prizes) do
        love.graphics.setColor(1, 1, 0)  -- Color amarillo para los premios
        love.graphics.rectangle("fill", prize.x, prize.y, prize.size, prize.size)
    end
    love.graphics.print("Score: " .. score, 10, 10)
end

function resetGame()
    player.x = 400
    player.y = 550
    obstacles = {}
    spawnTimer = 0
    prizeTimer = 0
    gameOver = false
    score = 0
    prizes = {}

end
