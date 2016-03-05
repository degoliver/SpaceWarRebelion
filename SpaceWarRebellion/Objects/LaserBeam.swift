//
//  LaserBeam.swift
//  SpaceWarRebellion
//
//  Created by Usuário Convidado on 05/03/16.
//  Copyright © 2016 Flameworks. All rights reserved.
//

class LaserBeam: CCNode {
    var damage:CGFloat = 100.0
    var gameSceneRef:GameScene?
    var laserBeam:CCParticleSystem = CCParticleSystem(file: "lazer.plist")
    
    override init() {
        super.init()
        self.physicsBody = CCPhysicsBody(rect: CGRectMake(0.0, 0.0, 10.0, 1000.0), cornerRadius: 0.0)
        self.physicsBody.type = CCPhysicsBodyType.Kinematic
        self.physicsBody.friction = 1.0
        self.physicsBody.elasticity = 0.1
        self.physicsBody.mass = 100.0
        self.physicsBody.density = 100.0
        self.physicsBody.collisionType = "LaserBeam"
        self.physicsBody.collisionCategories = ["LaserBeam"]
        self.physicsBody.collisionMask = ["EnemyShip", "Asteroid"]
        
        self.contentSize = CGSizeMake(10.0, 1000.0)
    }
    
    override func onEnter() {
        super.onEnter()
    }
    
    deinit {
        
    }
    
    func activateLaserBeam(playerShip:PlayerShip){
        self.laserBeam.position = CGPointMake((playerShip.boundingBox().size.width/2) - 5, (playerShip.boundingBox().size.height*4) + 60)
        laserBeam.anchorPoint = CGPointMake(0.5, 0.0)
        laserBeam.autoRemoveOnFinish = true
        laserBeam.stopSystem()
        laserBeam.resetSystem()
        playerShip.addChild(laserBeam, z:ObjectsLayers.Player.rawValue)
        DelayHelper.sharedInstance.callBlock({ () -> Void in
            self.abc()
            }, withDelay: 5.0)
    }
    
    func abc(){
        self.laserBeam.stopSystem()
    }
}
