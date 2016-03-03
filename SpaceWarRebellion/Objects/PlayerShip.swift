//
//  PlayerShip.swift
//  SpaceWar
//
//  Created by Thales Toniolo on 11/10/14.
//  Copyright (c) 2014 Flameworks. All rights reserved.
//
// MARK: - Class Definition
class PlayerShip : CCSprite {
	// MARK: - Public Objects
    internal var eventSelector:Selector?
    internal var targetID:AnyObject?
    private var alive:Bool = true
    
	var atackSpeed:CGFloat = 5.0
	var life:CGFloat = 100.0

    var shieldLife:CGFloat = 0.0
    var shieldDuration:CGFloat = 0.0
    var shieldCount:CGFloat = 3.0
    
    private var shield:CCSprite = CCSprite(imageNamed: "heroShield.png")
    
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

		self.physicsBody = CCPhysicsBody(rect: CGRectMake(0, 0, self.contentSize.width, self.contentSize.height), cornerRadius: 0.0)
		self.physicsBody.type = CCPhysicsBodyType.Kinematic
		self.physicsBody.friction = 1.0
		self.physicsBody.elasticity = 0.1
		self.physicsBody.mass = 100.0
		self.physicsBody.density = 100.0
		self.physicsBody.collisionType = "PlayerShip"
		self.physicsBody.collisionCategories = ["PlayerShip"]
		self.physicsBody.collisionMask = ["EnemyShip", "EnemyShot", "Asteroid"]
        
        criaTurbinas()
        
        shield.scale = 0.0
        self.shield.anchorPoint = CGPointMake(0.5, 0.5)
        self.shield.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2)
        self.addChild(shield, z: ObjectsLayers.Shot.rawValue)
	}
	
	override func onEnter() {
		// Chamado apos o init quando entra no director
		super.onEnter()
	}
    
    func activeShield(){
        if(self.shieldCount >= 1){
            shieldCount--
            self.shieldLife = 100.0
            self.shield.runAction(CCActionScaleTo.actionWithDuration(0.2, scale: 1.5) as! CCAction) as CCAction
            DelayHelper.sharedInstance.callBlock({ () -> Void in
                self.finishShield()
                }, withDelay: 20.0)
        }
    }
    
    func finishShield(){
        self.shieldLife = 0.0
        self.shield.scale = 0.0
    }
    
    //função responsável pela geração das turbinas.
    func criaTurbinas(){
        let rightBigParticle:CCParticleSystem = CCParticleSystem(file: "turbina1.plist")
        rightBigParticle.position = CGPoint(x: (self.contentSize.width/2) + 16.0, y: self.contentSize.width - 145.0)
        self.addChild(rightBigParticle, z:ObjectsLayers.turbina.rawValue)
        
        let leftBigParticle:CCParticleSystem = CCParticleSystem(file: "turbina1.plist")
        leftBigParticle.position = CGPoint(x: (self.contentSize.width/2) - 16.0, y: self.contentSize.width - 145.0)
        self.addChild(leftBigParticle, z:ObjectsLayers.turbina.rawValue)
        
        let rightLittleParticle:CCParticleSystem = CCParticleSystem(file: "turbina1.plist")
        rightLittleParticle.position = CGPoint(x: (self.contentSize.width/2) + 40.0, y: self.contentSize.width - 132.0)
        rightLittleParticle.scale = 0.5
        self.addChild(rightLittleParticle, z:ObjectsLayers.turbina.rawValue)
        
        let leftLittleParticle:CCParticleSystem = CCParticleSystem(file: "turbina1.plist")
        leftLittleParticle.position = CGPoint(x: (self.contentSize.width/2) - 40.0, y: self.contentSize.width - 132.0)
        leftLittleParticle.scale = 0.5
        self.addChild(leftLittleParticle, z:ObjectsLayers.turbina.rawValue)

    }
	
	// MARK: - Private Methods
	
	// MARK: - Public Methods

	// MARK: - Delegates/Datasources
	
	// MARK: - Death Cycle
	deinit {
		// Chamado no momento de desalocacao
	}
}
