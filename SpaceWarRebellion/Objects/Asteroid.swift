//
//  Asteroid.swift
//  CocosSwift
//
//  Created by Anderson Ferreira on 29/02/16.
//  Copyright © 2016 Flameworks. All rights reserved.
//

class Asteroid: CCNode {
    var damage:CGFloat = 25.0
    var life:CGFloat = 300.0
    var isDead: Bool = false
    var gameSceneRef:GameScene?
    var asteroid:CCSprite = CCSprite(imageNamed: "asteroid.png")
    
    override init() {
        super.init()
        
        
        asteroid.anchorPoint = CGPointMake(0.5, 0.5)
        asteroid.rotation = 180.0
        
        let rotate:CCAction = CCActionRepeatForever.actionWithAction(CCActionRotateBy.actionWithDuration(0.5, angle: 180) as! CCActionInterval) as! CCAction!
        asteroid.runAction(rotate)
        self.addChild(asteroid)
        
        self.criarFogo()

        self.physicsBody = CCPhysicsBody(circleOfRadius: self.asteroid.boundingBox().size.width/2.0, andCenter: self.asteroid.position)
        self.physicsBody.type = CCPhysicsBodyType.Kinematic
        self.physicsBody.friction = 1.0
        self.physicsBody.elasticity = 0.1
        self.physicsBody.mass = 100.0
        self.physicsBody.density = 100.0
        self.physicsBody.collisionType = "Asteroid"
        self.physicsBody.collisionCategories = ["Asteroid"]
        self.physicsBody.collisionMask = ["PlayerShip", "PlayerShot", "LaserBeam"]
        
        self.contentSize = asteroid.boundingBox().size

//        let pt = self.parent!.convertToWorldSpace(asteroid.position)
//        let pt = CCDirector.sharedDirector().convertToUI(asteroid.position)
//        print("\(pt.x) | \(pt.y)")
    }

    //função responsável pela geração do fogo dos asteroids.
    func criarFogo(){
        let asteroidFire:CCParticleSystem = CCParticleSystem(file: "turbina2.plist")
        asteroidFire.scale = 2.0
        asteroidFire.position = CGPoint(x: self.contentSize.width/2, y: self.contentSize.height/2)
        self.addChild(asteroidFire, z:ObjectsLayers.turbina.rawValue)
    }
    
    //Cria particulas da destruição do asteroid
    func createAsteroidDestructionParticle(asteroidPosition: CGPoint) {
        let particle:CCParticleSystem = CCParticleSystem(file: "boom3.plist")
        particle.position = self.position
        particle.autoRemoveOnFinish = true
        self.addChild(particle, z:ObjectsLayers.Player.rawValue)
    }
    
    override func onEnter() {
        super.onEnter()
    }
    
    deinit {
        
    }
}
