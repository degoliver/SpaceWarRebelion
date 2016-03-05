//
//  LaserBeam.swift
//  SpaceWarRebellion
//
//  Created by Usuário Convidado on 05/03/16.
//  Copyright © 2016 Flameworks. All rights reserved.
//

class LaserBeam: CCNode {
    var damage:CGFloat = 300.0
    var gameSceneRef:GameScene?
    var laserBeam:CCParticleSystem = CCParticleSystem(file: "lazer.plist")
    
    override init() {
        super.init()
        self.physicsBody = CCPhysicsBody(rect: CGRectMake(0.0, 990, 10.0, 1000.0), cornerRadius: 0.0)
        self.physicsBody.type = CCPhysicsBodyType.Kinematic
        self.physicsBody.friction = 1.0
        self.physicsBody.elasticity = 0.1
        self.physicsBody.mass = 100.0
        self.physicsBody.density = 100.0
        self.physicsBody.collisionType = "LaserBeam"
        self.physicsBody.collisionCategories = ["LaserBeam"]
        self.physicsBody.collisionMask = ["EnemyShip", "Asteroid"]
        
        self.contentSize = CGSizeMake(10.0, 1000.0)

        self.laserBeam.position = CGPointMake(0.0, 0.0)
        self.laserBeam.anchorPoint = CGPointMake(0.0, 0.0)
    }
    
    override func onEnter() {
        super.onEnter()
    }
    
    deinit {
        
    }
    
    func activateLaserBeam(gameScene:GameScene){
        self.laserBeam.autoRemoveOnFinish = true
        gameScene.addChild(self.laserBeam, z:ObjectsLayers.Player.rawValue)
        self.laserBeam.resetSystem()
        DelayHelper.sharedInstance.callBlock({ () -> Void in
                self.stopLaser()
            }, withDelay: 5.0)
    }
    
    func stopLaser(){
        self.laserBeam.stopSystem()
        self.laserBeam.removeFromParentAndCleanup(true)
    }
}
