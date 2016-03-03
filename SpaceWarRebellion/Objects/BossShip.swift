//
//  BossShip.swift
//  CocosSwift
//
//  Created by Usuário Convidado on 29/02/16.
//  Copyright © 2016 Flameworks. All rights reserved.
//

import UIKit

class BossShip: CCSprite {

    var damage:CGFloat = 75.0
    var life:CGFloat = 800.0
    var gameSceneRef:GameScene?
    var toLEft = false
    
    override init() {
        super.init()
    }
    
    override init(CGImage image: CGImage!, key: String!) {
        super.init(CGImage: image, key: key)
    }
    
    override init(spriteFrame: CCSpriteFrame!) {
        super.init(spriteFrame: spriteFrame)
    }
    
    override init(texture: CCTexture!) {
        super.init(texture: texture)
    }
    
    override init(texture: CCTexture!, rect: CGRect) {
        super.init(texture: texture, rect: rect)
    }
    
    override init(texture: CCTexture!, rect: CGRect, rotated: Bool) {
        super.init(texture: texture, rect: rect, rotated: rotated)
    }
    
    override init(imageNamed imageName: String!) {
        super.init(imageNamed: imageName)
        
        self.rotation = 0
        
        self.physicsBody = CCPhysicsBody(rect: CGRectMake(0, 0, self.contentSize.width, self.contentSize.height), cornerRadius: 0.0)
        self.physicsBody.type = CCPhysicsBodyType.Kinematic
        self.physicsBody.friction = 1.0
        self.physicsBody.elasticity = 0.1
        self.physicsBody.mass = 200.0
        self.physicsBody.density = 100.0
        self.physicsBody.collisionType = "BossShip"
        self.physicsBody.collisionCategories = ["BossShip"]
        self.physicsBody.collisionMask = ["PlayerShip", "PlayerShot", "PlayerShot"]
    }
    
    override func onEnter() {
        super.onEnter()
    }
    
    override func update(delta: CCTime) {
        
        if (toLEft){
            self.position.x-=10
        } else {
            self.position.x+=10
        }
        
        if (self.position.x <= 170) {
            toLEft = false
            self.rotation = 2
        } else if (self.position.x >= 600) {
            toLEft = true
            self.rotation = -2
        }
//        self.generatorMove(toLEft)
    }
    
    func generatorMove(isToLeft: Bool){
        
        if (isToLeft) {
            let arrActions1: [CCAction] = [CCActionMoveBy.actionWithDuration(3.0, position: CGPointMake(-5.0, 0.0)) as! CCAction]
            
            let arrActions2: [CCAction] = [CCActionCallBlock.actionWithBlock({ () -> Void in
                    
                }) as! CCAction]
            
            self.runAction(CCActionSequence.actionOne(CCActionSpawn.actionWithArray(arrActions1) as! CCActionFiniteTime, two: CCActionSequence.actionWithArray(arrActions2) as! CCActionFiniteTime) as! CCAction)
        } else if (!isToLeft) {
            let arrActions1: [CCAction] = [CCActionMoveBy.actionWithDuration(3.0, position: CGPointMake(5.0, 0.0)) as! CCAction]
            
            let arrActions2: [CCAction] = [CCActionCallBlock.actionWithBlock({ () -> Void in
                   
                }) as! CCAction]
            
            self.runAction(CCActionSequence.actionOne(CCActionSpawn.actionWithArray(arrActions1) as! CCActionFiniteTime, two: CCActionSequence.actionWithArray(arrActions2) as! CCActionFiniteTime) as! CCAction)
        } else {
            // Caso nao permita sua movimentacao, libera o swipe
        }
    }
    
    deinit {
        
    }

    
}
