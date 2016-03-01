//
//  EnemyShip.swift
//  SpaceWar
//
//  Created by Thales Toniolo on 11/10/14.
//  Copyright (c) 2014 Flameworks. All rights reserved.
//
// MARK: - Class Definition
class EnemyShip : CCSprite {
	// MARK: - Public Objects
	var damage:CGFloat = 25.0
	var life:CGFloat = 25.0
	var gameSceneRef:GameScene?
	
	// MARK: - Private Objects
	var numShots:Int = 5
	var shootDelayCount:Int = 0
	
	// MARK: - Life Cycle
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

		self.life += CGFloat(arc4random_uniform(4)) // Ganha vidas extras de 0 a 3
		// Configuracoes default
		self.physicsBody = CCPhysicsBody(rect: CGRectMake(0, 0, self.contentSize.width, self.contentSize.height), cornerRadius: 0.0)
		self.physicsBody.type = CCPhysicsBodyType.Kinematic
		self.physicsBody.friction = 1.0
		self.physicsBody.elasticity = 0.1
		self.physicsBody.mass = 100.0
		self.physicsBody.density = 100.0
		self.physicsBody.collisionType = "EnemyShip"
		self.physicsBody.collisionCategories = ["EnemyShip"]
		self.physicsBody.collisionMask = ["PlayerShip", "PlayerShot"]
	}
	
	override func onEnter() {
		super.onEnter()
	}

	// Cada nave tem 40% de atirar a cada tick ateh um limite de 5x
	override func update(delta: CCTime) {
		self.shootDelayCount++
		if (self.shootDelayCount >= 35 && self.numShots > 0 && (arc4random_uniform(101) > 60)) {
			self.shootDelayCount = 0
			self.numShots--
			self.gameSceneRef!.enemyShotAtPosition(self.position)
		}
	}
    
	deinit {
		
	}
}
