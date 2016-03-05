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
    var bossTime: Int = 60
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
    
    
    //Ícones para shields capturados.
    var shieldItem1:CCSprite = CCSprite(imageNamed: "heroShieldIco.png")
    var shieldItem2:CCSprite = CCSprite(imageNamed: "heroShieldIco.png")
    var shieldItem3:CCSprite = CCSprite(imageNamed: "heroShieldIco.png")
    
    //Ícones para Laser Beam capturados.
    var beamItem1:CCSprite = CCSprite(imageNamed: "laserBallBlue.png")
    var beamItem2:CCSprite = CCSprite(imageNamed: "laserBallBlue.png")
    var beamItem3:CCSprite = CCSprite(imageNamed: "laserBallBlue.png")
    
    //boss
    var boss: BossShip = BossShip(imageNamed: "boss.png")
    
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
        
        // Registra a entrada do Boss 
        //DelayHelper.sharedInstance.callFunc("entryBoss", onTarget: self, withDelay: 1.0)

        //self.bossTime--
        //print(self.bossTime)
	}
    
    func entryBoss(){
        
        self.bossTime--
        if (self.bossTime <= 0) {
            //entra boss
            //Configura o BOSS
            self.boss.visible = true
            self.boss.position = CGPointMake(self.screenSize.width/2,800)
            self.physicsWorld.addChild(self.boss,z:ObjectsLayers.Foes.rawValue)
           
        } else {
            // Chama de 1 em 1 seg
            DelayHelper.sharedInstance.callFunc("entryBoss", onTarget: self, withDelay: 1.0)
        }
        print(self.bossTime)
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
                self.fireDelayCount = 2.0
                self.heroShip.heroFire(self)
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
        let imgButton:CCButton = CCButton(title: "", spriteFrame: CCSprite.spriteWithImageNamed("eject5.png").spriteFrame)
        imgButton.position = CGPointMake(60, screenSize.height-50)
        imgButton.scale = 0.2
                imgButton.block = {_ in
                   StateMachine.sharedInstance.changeScene(StateMachineScenes.HomeScene, isFade:true)
                }
                self.addChild(imgButton, z:ObjectsLayers.HUD.rawValue)
        
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
        
        //Adiciona icones do shield.
        self.adicionaShieldIcons()
        
        //Adciona ícones do Laser Beam.
        self.adicionaLaserBeamIcons()
        self.boss.visible = false
    }
    
    func loadLifeBar(){
        self.heroLife100.position = CGPointMake(screenSize.width - 110, screenSize.height - 5)
        self.heroLife100.anchorPoint = CGPointMake(1.0, 1.0)
        self.addChild(heroLife100, z:ObjectsLayers.HUD.rawValue)
        
        self.heroLife75.position = CGPointMake(screenSize.width - 75, screenSize.height - 5)
        self.heroLife75.anchorPoint = CGPointMake(1.0, 1.0)
        self.addChild(heroLife75, z:ObjectsLayers.HUD.rawValue)
        
        self.heroLife50.position = CGPointMake(screenSize.width - 40, screenSize.height - 5)
        self.heroLife50.anchorPoint = CGPointMake(1.0, 1.0)
        self.addChild(heroLife50, z:ObjectsLayers.HUD.rawValue)
        
        self.heroLife25.position = CGPointMake(screenSize.width - 5, screenSize.height - 5)
        self.heroLife25.anchorPoint = CGPointMake(1.0, 1.0)
        self.addChild(heroLife25, z:ObjectsLayers.HUD.rawValue)
    }
    
    func adicionaShieldIcons(){
        self.shieldItem1.position = CGPointMake(screenSize.width - 5, 35)
        self.shieldItem1.anchorPoint = CGPointMake(1.0, 1.0)
        self.shieldItem1.scale = 0.0
        self.addChild(shieldItem1, z:ObjectsLayers.HUD.rawValue)
        
        self.shieldItem2.position = CGPointMake(screenSize.width - 40, 35)
        self.shieldItem2.anchorPoint = CGPointMake(1.0, 1.0)
        self.shieldItem2.scale = 0.0
        self.addChild(shieldItem2, z:ObjectsLayers.HUD.rawValue)
        
        self.shieldItem3.position = CGPointMake(screenSize.width - 75, 35)
        self.shieldItem3.anchorPoint = CGPointMake(1.0, 1.0)
        self.shieldItem3.scale = 0.0
        self.addChild(shieldItem3, z:ObjectsLayers.HUD.rawValue)
    }
    
    func adicionaLaserBeamIcons(){
        self.beamItem1.position = CGPointMake(screenSize.width - 5, 70)
        self.beamItem1.anchorPoint = CGPointMake(1.0, 1.0)
        self.beamItem1.scale = 0.0
        self.addChild(beamItem1, z:ObjectsLayers.HUD.rawValue)
        
        self.beamItem2.position = CGPointMake(screenSize.width - 40, 70)
        self.beamItem2.anchorPoint = CGPointMake(1.0, 1.0)
        self.beamItem2.scale = 0.0
        self.addChild(beamItem2, z:ObjectsLayers.HUD.rawValue)
        
        self.beamItem3.position = CGPointMake(screenSize.width - 75, 70)
        self.beamItem3.anchorPoint = CGPointMake(1.0, 1.0)
        self.beamItem3.scale = 0.0
        self.addChild(beamItem3, z:ObjectsLayers.HUD.rawValue)
    }
    
    func createEnemy() {
        if (!self.canPlay) {
            return
        }
        
        let random: Int = Int(arc4random_uniform(5) + 1)
        let inimigo:EnemyShip = EnemyShip(imageNamed:"enemyShip\(random).png")
        inimigo.enemyType = random
        inimigo.criaTurbinas()
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
        if (bossTime>=3){
            DelayHelper.sharedInstance.callFunc("createEnemy", onTarget: self, withDelay: delay)
        }
    }
    
    func enemyShotAtPosition(anPosition:CGPoint) {
        let shot:EnemyShot = EnemyShot(imageNamed: "laserBallRed.png", andDamage: 25.0)
        shot.anchorPoint = CGPointMake(0.5, 0.5)
        shot.position = anPosition
        
        // Movimenta o disparo ate o final da tela
        shot.runAction(CCActionSequence.actionOne(CCActionMoveTo.actionWithDuration(1.0, position:CGPointMake(anPosition.x, 0.0)) as! CCActionFiniteTime, two: CCActionCallBlock.actionWithBlock({ () -> Void in
            shot.removeFromParentAndCleanup(true)
        }) as! CCActionFiniteTime) as! CCAction)
        self.physicsWorld.addChild(shot, z:ObjectsLayers.Shot.rawValue)
    }
    
    func createAsteroid(){
        if (!self.canPlay) {
            return
        }
        
        let asteroid:Asteroid = Asteroid()
        asteroid.gameSceneRef = self
        asteroid.anchorPoint = CGPointMake(0.5, 0.5)
        let minScreenX:CGFloat = asteroid.boundingBox().size.width
        let maxScreenX:UInt32 = UInt32(screenSize.width - (asteroid.boundingBox().size.width + minScreenX))
        
        let positionX:CGFloat = minScreenX + CGFloat(arc4random_uniform(maxScreenX))
        asteroid.position = CGPointMake(positionX, screenSize.height + asteroid.boundingBox().size.height)
        self.physicsWorld.addChild(asteroid, z:ObjectsLayers.Foes.rawValue)
        
        let asteroidSped:CCTime = CCTime(arc4random_uniform(16)) + 5.0 // De 15s a 20s
        asteroid.runAction(CCActionSequence.actionOne(CCActionMoveTo.actionWithDuration(asteroidSped, position:CGPointMake(asteroid.position.x, asteroid.boundingBox().size.height * -2)) as! CCActionFiniteTime, two: CCActionCallBlock.actionWithBlock({ _ in
            asteroid.removeFromParentAndCleanup(true)
        }) as! CCActionFiniteTime) as! CCAction)
        
        let delay:CCTime = CCTime(arc4random_uniform(21)) + 5.0 // De 20s a 25s
        if (bossTime>=3){
            DelayHelper.sharedInstance.callFunc("createAsteroid", onTarget: self, withDelay: delay)
        }
    }
    
    func createParticleAtPosition(aPosition:CGPoint) {
        let particleFile:CCParticleSystem = CCParticleSystem(file: "boom.plist")
        particleFile.position = aPosition
        particleFile.autoRemoveOnFinish = true
        self.addChild(particleFile, z:ObjectsLayers.Player.rawValue)
    }
    
    func doGameOver() {
        self.canPlay = false
        self.isTouching = false
        self.createParticleAtPosition(self.heroShip.position)
        self.heroShip.removeFromParentAndCleanup(true)
        
        // Exibe o texto game over
        let label:CCSprite = CCSprite(imageNamed: "textGameOver.png")
        label.position = CGPointMake(screenSize.width/2, screenSize.height/2)
        label.anchorPoint = CGPointMake(0.5, 0.5)
        self.addChild(label, z:ObjectsLayers.HUD.rawValue)
    }
    
    //valida colisao entre a nave do heroi e nave inimiga
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, PlayerShip aPlayerShip:PlayerShip!, EnemyShip anEnemyShip:EnemyShip!) -> Bool {
        if(aPlayerShip.isShielded){
            aPlayerShip.shieldLife -= anEnemyShip.damage
            if(aPlayerShip.shieldLife <= 0){
                aPlayerShip.finishShield()
            }
        }else{
            aPlayerShip.life -= anEnemyShip.damage
            if (aPlayerShip.life <= 0) {
                updateHeroLife(aPlayerShip.life)
                SoundPlayHelper.sharedInstance.playSoundWithControl(GameMusicAndSoundFx.ShipBoom)
                aPlayerShip.life = 0
                self.doGameOver()
            }
        }
        SoundPlayHelper.sharedInstance.playSoundWithControl(GameMusicAndSoundFx.ShipBoom)
        self.createParticleAtPosition(anEnemyShip.position)
        anEnemyShip.removeFromParentAndCleanup(true)
        
        // Configura o display da vida do player
        updateHeroLife(aPlayerShip.life)
        
        return true
    }
    
    //valida colisao entre nave do heroi e tiro inimigo
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, PlayerShip aPlayerShip:PlayerShip!, EnemyShot anEnemyShot:EnemyShot!) -> Bool {
        if(aPlayerShip.isShielded){
            aPlayerShip.shieldLife -= anEnemyShot.damage
            if(aPlayerShip.shieldLife <= 0){
                aPlayerShip.finishShield()
            }
        }else{
            aPlayerShip.life -= anEnemyShot.damage
            if (aPlayerShip.life <= 0) {
                updateHeroLife(aPlayerShip.life)
                SoundPlayHelper.sharedInstance.playSoundWithControl(GameMusicAndSoundFx.ShipBoom)
                aPlayerShip.life = 0
                self.doGameOver()
            }
            // Configura o display da vida do player
            updateHeroLife(aPlayerShip.life)
        }
        // Remove o disparo
        anEnemyShot.removeFromParentAndCleanup(true)
        return true
    }
    
    //valida colisao entre nave inimiga e tiro do heroi
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, EnemyShip anEnemyShip:EnemyShip!, PlayerShot anPlayerShot:PlayerShot!) -> Bool {
        if(anEnemyShip.isShielded){
            anEnemyShip.shieldLife -= anPlayerShot.damage
            
            if(anEnemyShip.shieldLife <= 0){
                anEnemyShip.removeShield()
            }
        }else{
            anEnemyShip.life -= anPlayerShot.damage
            
            if (anEnemyShip.life <= 0 && !anEnemyShip.isDead) {
                anEnemyShip.isDead = true
                SoundPlayHelper.sharedInstance.playSoundWithControl(GameMusicAndSoundFx.ShipBoom)
                self.createParticleAtPosition(anEnemyShip.position)
                anEnemyShip.removeFromParentAndCleanup(true)
                
                if(anEnemyShip.enemyType == 5 && arc4random_uniform(10) <= 3){
                    let item:Item = Item(imageNamed: "heroShieldIco.png")
                    item.type = "shield"
                    item.position = anEnemyShip.position
                    item.runAction(CCActionSequence.actionOne(CCActionMoveTo.actionWithDuration(3.0, position:CGPointMake(item.position.x, item.boundingBox().size.height * -2)) as! CCActionFiniteTime, two: CCActionCallBlock.actionWithBlock({ _ in
                    }) as! CCActionFiniteTime) as! CCAction)
                    self.physicsWorld.addChild(item ,z:ObjectsLayers.Foes.rawValue)
                }
                let explosion: Effect = Effect()
                explosion.position = CGPointMake(anEnemyShip.position.x,anEnemyShip.position.y)
                self.addChild(explosion, z: 3)
            }
        }

        // Remove o disparo
        anPlayerShot.removeFromParentAndCleanup(true)
        
        return true
    }
    
    //valida colisao entre a nave do heroi e o asteroid.
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, PlayerShip aPlayerShip: PlayerShip!, Asteroid aAsteroid: Asteroid!) -> Bool {
        if (aPlayerShip.life <= 0) {
            updateHeroLife(aPlayerShip.life)
            SoundPlayHelper.sharedInstance.playSoundWithControl(GameMusicAndSoundFx.ShipBoom)
            aPlayerShip.life = 0
            self.doGameOver()
        }else{
            aPlayerShip.life -= aAsteroid.damage
            if(aPlayerShip.life <= 0){
                SoundPlayHelper.sharedInstance.playSoundWithControl(GameMusicAndSoundFx.ShipBoom)
                aPlayerShip.life = 0
                self.doGameOver()
            }else{
                updateHeroLife(aPlayerShip.life)
            }
        }
        aAsteroid.removeFromParentAndCleanup(true)
        
        return  true
    }
    
    //valida colisao entre asteroid e tiro do heroi
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, Asteroid aAsteroid: Asteroid!, PlayerShot aPlayerShot: PlayerShot!) -> Bool {
        aAsteroid.life -= aPlayerShot.damage
        
        if(aAsteroid.life <= 0 && !aAsteroid.isDead){
            aAsteroid.isDead = true
            aAsteroid.removeFromParentAndCleanup(true)
            aAsteroid.createAsteroidDestructionParticle(aAsteroid.position)

            let item: Item = Item(imageNamed: "laserBallBlue.png")
            item.type = "laserBeam"
            item.position = CGPointMake(aAsteroid.position.x - 40, aAsteroid.position.y - 30)
            print("\(item.position.x) | \(item.position.y)")
            item.anchorPoint = CGPointMake(0.5, 0.5)
            item.runAction(CCActionSequence.actionOne(CCActionMoveTo.actionWithDuration(3.0, position:CGPointMake(item.position.x, item.boundingBox().size.height * -2)) as! CCActionFiniteTime, two: CCActionCallBlock.actionWithBlock({ _ in
            }) as! CCActionFiniteTime) as! CCAction)
            
            self.physicsWorld.addChild(item ,z:ObjectsLayers.Foes.rawValue)
        }
        
        aPlayerShot.removeFromParentAndCleanup(true)
        
        return true
    }
    
    //valida colisao entre laser beam e nave inimiga.
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, LaserBeam aLaserBeam: LaserBeam!, EnemyShip aEnemyShip: EnemyShip!) -> Bool {
        if(aEnemyShip.isShielded){
            aEnemyShip.shieldLife -= aLaserBeam.damage
            
            if(aEnemyShip.shieldLife <= 0){
                aEnemyShip.removeShield()
            }
        }else{
            aEnemyShip.life -= aLaserBeam.damage
            
            if (aEnemyShip.life <= 0 && !aEnemyShip.isDead) {
                aEnemyShip.isDead = true
                SoundPlayHelper.sharedInstance.playSoundWithControl(GameMusicAndSoundFx.ShipBoom)
                self.createParticleAtPosition(aEnemyShip.position)
                aEnemyShip.removeFromParentAndCleanup(true)
                
                if(aEnemyShip.enemyType == 5 && arc4random_uniform(10) <= 3){
                    let item:Item = Item(imageNamed: "heroShieldIco.png")
                    item.type = "shield"
                    item.position = aEnemyShip.position
                    item.runAction(CCActionSequence.actionOne(CCActionMoveTo.actionWithDuration(3.0, position:CGPointMake(item.position.x, item.boundingBox().size.height * -2)) as! CCActionFiniteTime, two: CCActionCallBlock.actionWithBlock({ _ in
                    }) as! CCActionFiniteTime) as! CCAction)
                    self.physicsWorld.addChild(item ,z:ObjectsLayers.Foes.rawValue)
                }
                let explosion: Effect = Effect()
                explosion.position = CGPointMake(aEnemyShip.position.x,aEnemyShip.position.y)
                self.addChild(explosion, z: 3)
            }
        }
        return true
    }
    
    //valida colisao entre heroi e o Item
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, Item aItem: Item!, PlayerShip aPlayerShip: PlayerShip!) -> Bool {
        aItem.removeFromParentAndCleanup(true)
        switch(aItem.type){
        case "laserBeam":
            if(self.heroShip.laserBeamCount < 3){
                heroShip.laserBeamCount++
                addLaserBeamIconScreen()
            }
            break
        case "shield":
            if(self.heroShip.shieldCount < 3){
                self.heroShip.shieldCount++
                addShieldIconScreen()
            }
            break
        case "rapidFire":
            //..
            break
        default:
            break
        }
        
    return true
    }
    
    //Anima o icone do item pego na tela.
    func addShieldIconScreen(){
        if(self.heroShip.shieldCount == 1){
            self.shieldItem1.runAction(CCActionScaleTo.actionWithDuration(0.2, scale: 1.0) as! CCAction) as CCAction
        }else if(self.heroShip.shieldCount == 2){
            self.shieldItem2.runAction(CCActionScaleTo.actionWithDuration(0.2, scale: 1.0) as! CCAction) as CCAction
        }else{
            self.shieldItem3.runAction(CCActionScaleTo.actionWithDuration(0.2, scale: 1.0) as! CCAction) as CCAction
        }
    }
    
    //Anima o icone do item pego na tela.
    func addLaserBeamIconScreen(){
        if(self.heroShip.laserBeamCount == 1){
            self.beamItem1.runAction(CCActionScaleTo.actionWithDuration(0.2, scale: 1.0) as! CCAction) as CCAction
        }else if (self.heroShip.laserBeamCount == 2){
            self.beamItem2.runAction(CCActionScaleTo.actionWithDuration(0.2, scale: 1.0) as! CCAction) as CCAction
        }else{
            self.beamItem3.runAction(CCActionScaleTo.actionWithDuration(0.2, scale: 1.0) as! CCAction) as CCAction
        }
    }
    
    //Anima o icone do item pego na tela.
    func activateRapidFire(){
        
    }
    
    func removeShieldIconScreen(){
        if(self.heroShip.shieldCount == 2){
            self.shieldItem3.runAction(CCActionScaleTo.actionWithDuration(0.2, scale: 0.0) as! CCAction) as CCAction
        }else if(self.heroShip.shieldCount == 1){
            self.shieldItem2.runAction(CCActionScaleTo.actionWithDuration(0.2, scale: 0.0) as! CCAction) as CCAction
        }else{
            self.shieldItem1.runAction(CCActionScaleTo.actionWithDuration(0.2, scale: 0.0) as! CCAction) as CCAction
        }
    }
    
    func removeLaserBeamIconScreen(){
        if(self.heroShip.laserBeamCount == 2){
            self.beamItem3.runAction(CCActionScaleTo.actionWithDuration(0.2, scale: 0.0) as! CCAction) as CCAction
        }else if (self.heroShip.laserBeamCount == 1){
            self.beamItem2.runAction(CCActionScaleTo.actionWithDuration(0.2, scale: 0.0) as! CCAction) as CCAction
        }else{
            self.beamItem1.runAction(CCActionScaleTo.actionWithDuration(0.2, scale: 0.0) as! CCAction) as CCAction
        }
    }
    
    //valida colisao entre a o tiro da nave e o Boss
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, PlayerShot aPlayerShot: PlayerShot!, BossShip boss:BossShip!) -> Bool {
        boss.life -= aPlayerShot.damage
        
        SoundPlayHelper.sharedInstance.playSoundWithControl(GameMusicAndSoundFx.ShipBoom)
        if boss.life <= 0{
            boss.life = 0
            // boss desaparece
            boss.removeFromParentAndCleanup(true)
        }else{
            // mudar a cor do boss
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
    
    //registra os gestures usados na gameScene
    func registerGestures(){
        let swipDowm: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handlePlayerSwipe:")
        swipDowm.direction = UISwipeGestureRecognizerDirection.Down
        swipDowm.delegate = self
        CCDirector.sharedDirector().view.addGestureRecognizer(swipDowm)
        
        let swipUp: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handlePlayerSwipe:")
        swipUp.direction = UISwipeGestureRecognizerDirection.Up
        swipUp.delegate = self
        CCDirector.sharedDirector().view.addGestureRecognizer(swipUp)
    }
    
    //controle os getures da tela.
    func handlePlayerSwipe(recognizer: UISwipeGestureRecognizer){
        if(self.canPlay){
            if(recognizer.state == .Ended){
                switch(recognizer.direction){
                case UISwipeGestureRecognizerDirection.Down:
                    self.heroShip.activeShield()
                    self.removeShieldIconScreen()
                    break
                case UISwipeGestureRecognizerDirection.Up:
                    self.heroShip.activateLaserBeam()
                    self.removeLaserBeamIconScreen()
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
            self.heroShip.heroFire(self)
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
