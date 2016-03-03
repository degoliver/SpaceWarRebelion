//
//  GameScene.swift
//  CocosSwift
//
//  Created by Thales Toniolo on 10/09/14.
//  Copyright (c) 2014 Flameworks. All rights reserved.
//
import Foundation

// MARK: - Class Definition
class GameScene: CCScene, CCPhysicsCollisionDelegate, UIGestureRecognizerDelegate {
    private let screenSize:CGSize = CCDirector.sharedDirector().viewSize()
    var canPlay:Bool = true
    var isTouching:Bool = false
    var physicsWorld:CCPhysicsNode = CCPhysicsNode()
    var heroShip:PlayerShip = PlayerShip(imageNamed: "heroShip.png")
    var fireDelayCount:CGFloat = 0.0
    var parallaxNode:CCParallaxNode = CCParallaxNode()
    let spaceBg:CCSprite = CCSprite(imageNamed: "bgSpace.png")
    let spaceBg2:CCSprite = CCSprite(imageNamed: "bgSpace.png")
    
    //life do hero
    var heroLife100:CCSprite = CCSprite(imageNamed: "heroShipLife.png")
    var heroLife75:CCSprite = CCSprite(imageNamed: "heroShipLife.png")
    var heroLife50:CCSprite = CCSprite(imageNamed: "heroShipLife.png")
    var heroLife25:CCSprite = CCSprite(imageNamed: "heroShipLife.png")
    
	override init() {
		super.init()
        self.userInteractionEnabled = true
        self.createSceneObjects()
        self.registerGestures()
	}

	override func onEnter() {
		super.onEnter()
        DelayHelper.sharedInstance.callFunc("createEnemy", onTarget: self, withDelay: 3.0)
        DelayHelper.sharedInstance.callFunc("createAsteroid", onTarget: self, withDelay: 10.0)
	}
    
    override func update(delta: CCTime) {
        if (!canPlay) {
            return
        }
        //Controle do parallax infinito com apenas uma imagem.
        let backgroundScrollVel:CGPoint = CGPointMake(0, -30)
        
        // Soma os pontos (posicao atual + (velocidade * delta))
        let pt1:CGFloat = backgroundScrollVel.y * CGFloat(delta)
        let multiDelta:CGPoint = CGPointMake(backgroundScrollVel.x, pt1)
        self.parallaxNode.position = CGPointMake(0.0, self.parallaxNode.position.y + multiDelta.y)
        
        // Valida quando a imagem chega ao fim para reposicionar as imagens.
        if (self.parallaxNode.convertToWorldSpace(self.spaceBg.position).y < -self.spaceBg.contentSize.height) {
            self.parallaxNode.position = CGPointMake(0.0, 0.0)
        }
        //tamanho da tela para movimentacao
        if(heroShip.position.x <= 0){
            heroShip.position.x = 7
            stopAllActions()
        }else if(heroShip.position.x >= 768){
            heroShip.position.x = 755
            stopAllActions()
        }
        
        // Controla os diparos da nave
        if (self.isTouching) {
            self.fireDelayCount++
            if (self.fireDelayCount > self.heroShip.atackSpeed) {
                self.fireDelayCount = 0.0
                self.heroFire()
            }
        }
    }

    func createSceneObjects(){
        // Define o mundo
        self.physicsWorld.collisionDelegate = self
        self.physicsWorld.gravity = CGPointZero
        self.addChild(self.physicsWorld, z:ObjectsLayers.Background.rawValue)
        
        // Life do player
        loadLifeBar()
        
        // Back button
        let backButton:CCButton = CCButton(title: "[ Back ]", fontName: "Verdana-Bold", fontSize: 32.0)
        backButton.position = CGPointMake(150, screenSize.height)
        backButton.anchorPoint = CGPointMake(1.0, 1.0)
        backButton.zoomWhenHighlighted = false
        backButton.block = {_ in
            StateMachine.sharedInstance.changeScene(StateMachineScenes.HomeScene, isFade:true)
            SoundPlayHelper.sharedInstance.playSoundWithControl(GameMusicAndSoundFx.ButtonTap)
        }
        self.addChild(backButton, z:ObjectsLayers.HUD.rawValue)
        
        // Back button
        let aShield:CCButton = CCButton(title: "[ Shield]", fontName: "Verdana-Bold", fontSize: 32.0)
        aShield.position = CGPointMake(1.0, 1.0)
        aShield.anchorPoint = CGPointMake(0.5, 0.5)
        aShield.zoomWhenHighlighted = false
        aShield.block = {_ in
            self.heroShip.activeShield()
        }
        self.addChild(aShield, z:ObjectsLayers.HUD.rawValue)
        
        // Configura o parallax infinito
        self.spaceBg.position = CGPointMake(0.0, 0.0)
        self.spaceBg.anchorPoint = CGPointMake(0.0, 0.0)
        self.spaceBg2.position = CGPointMake(0.0, 0.0)
        self.spaceBg2.anchorPoint = CGPointMake(0.0, 0.0)
        self.parallaxNode.position = CGPointMake(0.0, 0.0)
        self.parallaxNode.addChild(self.spaceBg, z: 1, parallaxRatio:CGPointMake(0.0, 0.5), positionOffset:CGPointMake(0.0, 0.0))
        self.parallaxNode.addChild(self.spaceBg2, z: 1, parallaxRatio:CGPointMake(0.0, 0.5), positionOffset:CGPointMake(0.0, self.spaceBg.contentSize.height))
        self.physicsWorld.addChild(self.parallaxNode, z:ObjectsLayers.Background.rawValue)
        
        // Configura o heroi na tela
        self.heroShip.position = CGPointMake(screenSize.width/2.0, 100.0)
        self.physicsWorld.addChild(self.heroShip, z:ObjectsLayers.Player.rawValue)
    }
    
    func heroFire() {
        let leftShot:PlayerShot = PlayerShot(imageNamed:"heroShot.png", andDamage:25.0)
        let rightShot:PlayerShot = PlayerShot(imageNamed:"heroShot.png", andDamage:25.0)
        
        leftShot.anchorPoint = CGPointMake(0.5, 0.5)
        rightShot.anchorPoint = CGPointMake(0.5, 0.5)
        
        leftShot.position = CGPointMake(self.heroShip.position.x - 45.0, self.heroShip.position.y + 50.0)
        rightShot.position = CGPointMake(self.heroShip.position.x + 45.0, self.heroShip.position.y + 50.0)
        
        leftShot.runAction(CCActionSequence.actionOne(CCActionMoveBy.actionWithDuration(0.4, position: CGPointMake(0.0, screenSize.height)) as! CCActionFiniteTime, two: CCActionCallBlock.actionWithBlock({ () -> Void in
            leftShot.removeFromParentAndCleanup(true)
        }) as! CCActionFiniteTime) as! CCAction)
        
        rightShot.runAction(CCActionSequence.actionOne(CCActionMoveBy.actionWithDuration(0.4, position: CGPointMake(0.0, screenSize.height)) as! CCActionFiniteTime, two: CCActionCallBlock.actionWithBlock({ () -> Void in
            rightShot.removeFromParentAndCleanup(true)
        }) as! CCActionFiniteTime) as! CCAction)
        
        self.physicsWorld.addChild(rightShot, z:ObjectsLayers.Shot.rawValue)
        self.physicsWorld.addChild(leftShot, z:ObjectsLayers.Shot.rawValue)
        //liera do som do disparo.
        SoundPlayHelper.sharedInstance.playSoundWithControl(GameMusicAndSoundFx.HeroShot)
    }
    
    func loadLifeBar(){
        self.heroLife100.position = CGPointMake(screenSize.width - 110, screenSize.height - 5)
        heroLife100.anchorPoint = CGPointMake(1.0, 1.0)
        self.addChild(heroLife100, z:ObjectsLayers.HUD.rawValue)
        
        self.heroLife75.position = CGPointMake(screenSize.width - 75, screenSize.height - 5)
        heroLife75.anchorPoint = CGPointMake(1.0, 1.0)
        self.addChild(heroLife75, z:ObjectsLayers.HUD.rawValue)
        
        self.heroLife50.position = CGPointMake(screenSize.width - 40, screenSize.height - 5)
        heroLife50.anchorPoint = CGPointMake(1.0, 1.0)
        self.addChild(heroLife50, z:ObjectsLayers.HUD.rawValue)
        
        self.heroLife25.position = CGPointMake(screenSize.width - 5, screenSize.height - 5)
        heroLife25.anchorPoint = CGPointMake(1.0, 1.0)
        self.addChild(heroLife25, z:ObjectsLayers.HUD.rawValue)
    }
    
    func createEnemy() {
        if (!self.canPlay) {
            return
        }
        
        let inimigo:EnemyShip = EnemyShip(imageNamed:"enemyShip\(arc4random_uniform(5) + 1).png")
        inimigo.gameSceneRef = self
        inimigo.anchorPoint = CGPointMake(0.5, 0.5)
        let minScreenX:CGFloat = inimigo.boundingBox().size.width
        let maxScreenX:UInt32 = UInt32(screenSize.width - (inimigo.boundingBox().size.width + minScreenX))
        
        let positionX:CGFloat = minScreenX + CGFloat(arc4random_uniform(maxScreenX))
        inimigo.position = CGPointMake(positionX, screenSize.height + inimigo.boundingBox().size.height)
        self.physicsWorld.addChild(inimigo, z:ObjectsLayers.Foes.rawValue)
        
        let enemySpeed:CCTime = CCTime(arc4random_uniform(6)) + 5.0 // De 5s a 10s
        inimigo.runAction(CCActionSequence.actionOne(CCActionMoveTo.actionWithDuration(enemySpeed, position:CGPointMake(inimigo.position.x, inimigo.boundingBox().size.height * -2)) as! CCActionFiniteTime, two: CCActionCallBlock.actionWithBlock({ _ in
            inimigo.removeFromParentAndCleanup(true)
        }) as! CCActionFiniteTime) as! CCAction)
        
        let delay:CCTime = (CCTime(arc4random_uniform(101)) / 100.0) + 0.5 // De 0.5s a 1.5s
        DelayHelper.sharedInstance.callFunc("createEnemy", onTarget: self, withDelay: delay)
    }
    
    func enemyShotAtPosition(anPosition:CGPoint) {
        //let shot:EnemyShot = EnemyShot(imageNamed: "laserBallBlue.png", andDamage:CGFloat((arc4random_uniform(5) + 3)))
        let shot:EnemyShot = EnemyShot(imageNamed: "laserBallRed.png", andDamage: 25.0)
        shot.anchorPoint = CGPointMake(0.5, 0.5)
        shot.position = anPosition
        
        // Movimenta o disparo ate o final da tela
        shot.runAction(CCActionSequence.actionOne(CCActionMoveTo.actionWithDuration(2.4, position:CGPointMake(anPosition.x, 0.0)) as! CCActionFiniteTime, two: CCActionCallBlock.actionWithBlock({ () -> Void in
            shot.removeFromParentAndCleanup(true)
        }) as! CCActionFiniteTime) as! CCAction)
        self.physicsWorld.addChild(shot, z:ObjectsLayers.Shot.rawValue)
    }
    
    func createAsteroid(){
        if (!self.canPlay) {
            return
        }
        
        let asteroid:Asteroid = Asteroid(imageNamed: "asteroid.png")
        asteroid.gameSceneRef = self
        asteroid.anchorPoint = CGPointMake(0.5, 0.5)
        let minScreenX:CGFloat = asteroid.boundingBox().size.width
        let maxScreenX:UInt32 = UInt32(screenSize.width - (asteroid.boundingBox().size.width + minScreenX))
        
        let positionX:CGFloat = minScreenX + CGFloat(arc4random_uniform(maxScreenX))
        asteroid.position = CGPointMake(positionX, screenSize.height + asteroid.boundingBox().size.height)
        let rotate:CCAction = CCActionRepeatForever.actionWithAction(CCActionRotateBy.actionWithDuration(0.5, angle: 180) as! CCActionInterval) as! CCAction!
        asteroid.runAction(rotate)
        self.physicsWorld.addChild(asteroid, z:ObjectsLayers.Foes.rawValue)
        
        let asteroidSped:CCTime = CCTime(arc4random_uniform(16)) + 5.0 // De 15s a 20s
        asteroid.runAction(CCActionSequence.actionOne(CCActionMoveTo.actionWithDuration(asteroidSped, position:CGPointMake(asteroid.position.x, asteroid.boundingBox().size.height * -2)) as! CCActionFiniteTime, two: CCActionCallBlock.actionWithBlock({ _ in
            asteroid.removeFromParentAndCleanup(true)
        }) as! CCActionFiniteTime) as! CCAction)
        
        let delay:CCTime = CCTime(arc4random_uniform(21)) + 5.0 // De 20s a 25s
        DelayHelper.sharedInstance.callFunc("createAsteroid", onTarget: self, withDelay: delay)
    }
    
    //alterar esse método
    func createParticleAtPosition(aPosition:CGPoint) {
        let particleFile:CCParticleSystem = CCParticleSystem(file: "ShipBlow.plist")
        particleFile.position = aPosition
        particleFile.autoRemoveOnFinish = true
        self.addChild(particleFile, z:ObjectsLayers.Player.rawValue)
    }
    
    func doGameOver() {
        self.canPlay = false
        self.isTouching = false
        //self.createParticleAtPosition(self.heroShip.position)
        self.heroShip.removeFromParentAndCleanup(true)
        
        // Exibe o texto game over
        let label:CCSprite = CCSprite(imageNamed: "textGameOver.png")
        label.position = CGPointMake(screenSize.width/2, screenSize.height/2)
        label.anchorPoint = CGPointMake(0.5, 0.5)
        self.addChild(label, z:ObjectsLayers.HUD.rawValue)
    }
    
    //valida colisao entre a nave do heroi e nave inimiga
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, PlayerShip aPlayerShip:PlayerShip!, EnemyShip anEnemyShip:EnemyShip!) -> Bool {
        aPlayerShip.life -= anEnemyShip.damage
        if (aPlayerShip.life <= 0) {
            updateHeroLife(aPlayerShip.life)
            SoundPlayHelper.sharedInstance.playSoundWithControl(GameMusicAndSoundFx.ShipBoom)
            aPlayerShip.life = 0
            self.doGameOver()
        }
        
        SoundPlayHelper.sharedInstance.playSoundWithControl(GameMusicAndSoundFx.ShipBoom)
        //self.createParticleAtPosition(anEnemyShip.position)
        anEnemyShip.removeFromParentAndCleanup(true)
        
        // Configura o display da vida do player
        updateHeroLife(aPlayerShip.life)
        
        return true
    }
    
    //valida colisao entre nave do heroi e tiro inimigo
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, PlayerShip aPlayerShip:PlayerShip!, EnemyShot anEnemyShot:EnemyShot!) -> Bool {
        aPlayerShip.life -= anEnemyShot.damage
        if (aPlayerShip.life <= 0) {
            updateHeroLife(aPlayerShip.life)
            SoundPlayHelper.sharedInstance.playSoundWithControl(GameMusicAndSoundFx.ShipBoom)
            aPlayerShip.life = 0
            self.doGameOver()
        }
        
        // Remove o disparo
        anEnemyShot.removeFromParentAndCleanup(true)
        
        // Configura o display da vida do player
        updateHeroLife(aPlayerShip.life)
        
        return true
    }
    
    //valida colisao entre nave inimiga e tiro do hero
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, EnemyShip anEnemyShip:EnemyShip!, PlayerShot anPlayerShot:PlayerShot!) -> Bool {
        anEnemyShip.life -= anPlayerShot.damage
        
        if (anEnemyShip.life <= 0) {
            SoundPlayHelper.sharedInstance.playSoundWithControl(GameMusicAndSoundFx.ShipBoom)
            //self.createParticleAtPosition(anEnemyShip.position)
            anEnemyShip.removeFromParentAndCleanup(true)
        }
        
        // Remove o disparo
        anPlayerShot.removeFromParentAndCleanup(true)
        
        return true
    }
    
    //valida colisao entre a nave do heroi e o asteroid.
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, PlayerShip aPlayerShip: PlayerShip!, Asteroid aAsteroid: Asteroid!) -> Bool {
        aPlayerShip.life -= aAsteroid.damage
        if(aPlayerShip.life <= 0){
            SoundPlayHelper.sharedInstance.playSoundWithControl(GameMusicAndSoundFx.ShipBoom)
            aPlayerShip.life = 0
            self.doGameOver()
        }else{
            updateHeroLife(aPlayerShip.life)
        }
        
        aAsteroid.removeFromParentAndCleanup(true)
        
        return  true
    }
    
    //valida colisão entre tiro do heroi e tiro inimigo
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, PlayerShot aPlayerShot: PlayerShot!, EnemyShot aEnemyShot: EnemyShot!) -> Bool {
        aPlayerShot.removeFromParentAndCleanup(true)
        aEnemyShot.removeFromParentAndCleanup(true)
        return true
    }
    
    //valida colisao entre asteroid e tiro do heroi
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, Asteroid aAsteroid: Asteroid!, PlayerShot aPlayerShot: PlayerShot!) -> Bool {
        aAsteroid.life -= aPlayerShot.damage
        
        if(aAsteroid.life <= 0){
            aAsteroid.removeFromParentAndCleanup(true)
        }
        
        aPlayerShot.removeFromParentAndCleanup(true)
        
        return true
    }
    
    func updateHeroLife(lifeHero:CGFloat){
        if(lifeHero <= 75.0 && lifeHero > 50.0){
            heroLife100.removeFromParentAndCleanup(true)
        }
        else if(lifeHero <= 50.0 && lifeHero > 25.0){
            heroLife75.removeFromParentAndCleanup(true)
        }
        else if(lifeHero <= 25.0 && lifeHero > 0.0){
            heroLife50.removeFromParentAndCleanup(true)
        }
        else if(lifeHero <= 0.0){
            heroLife25.removeFromParentAndCleanup(true)
        }
    }
    
    //registra os gestures usadosna gameScene
    func registerGestures(){
        let swipDowm: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handlePlayerSwipe:")
        swipDowm.direction = UISwipeGestureRecognizerDirection.Down
        swipDowm.delegate = self
        CCDirector.sharedDirector().view.addGestureRecognizer(swipDowm)
    }
    
    //controle os getures da tela.
    func handlePlayerSwipe(recognizer: UISwipeGestureRecognizer){
        if(self.canPlay){
            if(recognizer.state == .Ended){
                switch(recognizer.direction){
                case UISwipeGestureRecognizerDirection.Down:
                    heroShip.activeShield()
                    break
                default:
                    debugPrint("Direção não tratada")
                    break
                }
            }
        }
    }

    override func touchBegan(touch: UITouch!, withEvent event: UIEvent!) {
        if (self.canPlay) {
            self.isTouching = true
            let locationInView:CGPoint = CCDirector.sharedDirector().convertTouchToGL(touch)
            //self.heroShip.position = locationInView
            let move:CCAction = CCActionMoveTo.actionWithDuration(0.4, position: CGPointMake(locationInView.x,
                heroShip.position.y)) as! CCAction
            heroFire()
            heroShip.runAction(move)
        }
    }
    
    override func touchMoved(touch: UITouch!, withEvent event: UIEvent!) {
        if (self.canPlay && self.isTouching) {
            let locationInView:CGPoint = CCDirector.sharedDirector().convertTouchToGL(touch)
            self.heroShip.position.x = locationInView.x
        }
    }
    
    override func touchEnded(touch: UITouch!, withEvent event: UIEvent!) {
        self.isTouching = false
    }
    
    override func touchCancelled(touch: UITouch!, withEvent event: UIEvent!) {
        self.isTouching = false
    }
    
	override func onExit() {
		super.onExit()
        
        CCTextureCache.sharedTextureCache().removeAllTextures()
	}
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
