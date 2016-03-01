//
//  EnemyShot.swift
//  SpaceWar
//
//  Created by Thales Toniolo on 11/10/14.
//  Copyright (c) 2014 Flameworks. All rights reserved.
//
// MARK: - Class Definition
class EnemyShot : CCSprite {
	// MARK: - Public Objects
	var damage:CGFloat = 0.0

	// MARK: - Private Objects

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
	}

	convenience init(imageNamed imageName: String!, andDamage:CGFloat) {
		self.init(imageNamed:imageName)
		
		// Configuracoes default
		self.damage = andDamage

		self.rotation = 180.0

		self.physicsBody = CCPhysicsBody(rect: CGRectMake(0, 0, self.contentSize.width, self.contentSize.height), cornerRadius: 0.0)
		self.physicsBody.type = CCPhysicsBodyType.Kinematic
		self.physicsBody.friction = 1.0
		self.physicsBody.elasticity = 0.1
		self.physicsBody.mass = 100.0
		self.physicsBody.density = 100.0
		self.physicsBody.collisionType = "EnemyShot"
		self.physicsBody.collisionCategories = ["EnemyShot"]
		self.physicsBody.collisionMask = ["PlayerShip", "PlayerShot"]
	}

	override func onEnter() {
		super.onEnter()
	}

	deinit {
	}
}
