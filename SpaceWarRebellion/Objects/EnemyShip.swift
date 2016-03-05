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
	var life:CGFloat = 100.0
    var isDead: Bool = false
	var gameSceneRef:GameScene?
    var enemyType:Int=0
    
    private var shield:CCSprite = CCSprite(imageNamed: "heroShield.png")
    var isShielded:Bool = false
    var shieldLife:CGFloat = 0.0
	
	// MARK: - Private Objects
	var numShots:Int = 10
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
    
    //função responsável pela geração das turbinas.
    func criaTurbinas(){
        switch(enemyType){
        case 1:
            turbina1()
            break
        case 2:
            turbina2()
            break
        case 3:
            turbina3()
            break
        case 4:
            turbina4()
            break
        case 5:
            turbina5()
            activeShield()
            break
        default:
            break
        }
    }
    
    func turbina1(){
        let rightParticle:CCParticleSystem = CCParticleSystem(file: "turbina2.plist")
        rightParticle.position = CGPoint(x: (self.contentSize.width/2) + 16.0, y: self.contentSize.height)
        rightParticle.scale = 0.8
        self.addChild(rightParticle, z:ObjectsLayers.turbina.rawValue)
        
        let leftParticle:CCParticleSystem = CCParticleSystem(file: "turbina2.plist")
        leftParticle.position = CGPoint(x: (self.contentSize.width/2) - 16.0, y: self.contentSize.height)
        leftParticle.scale = 0.8
        self.addChild(leftParticle, z:ObjectsLayers.turbina.rawValue)
    }
    
    func turbina2(){
        let rightParticle:CCParticleSystem = CCParticleSystem(file: "turbina2.plist")
        rightParticle.position = CGPoint(x: (self.contentSize.width/2) + 5.0, y: self.contentSize.height - 8)
        rightParticle.scale = 0.8
        self.addChild(rightParticle, z:ObjectsLayers.turbina.rawValue)
        
        let leftParticle:CCParticleSystem = CCParticleSystem(file: "turbina2.plist")
        leftParticle.position = CGPoint(x: (self.contentSize.width/2) - 5.0, y: self.contentSize.height - 8)
        leftParticle.scale = 0.8
        self.addChild(leftParticle, z:ObjectsLayers.turbina.rawValue)
    }
    
    func turbina3(){
        let rightParticle:CCParticleSystem = CCParticleSystem(file: "turbina2.plist")
        rightParticle.position = CGPoint(x: (self.contentSize.width/2) + 10.0, y: self.contentSize.height - 5)
        self.addChild(rightParticle, z:ObjectsLayers.turbina.rawValue)
        
        let leftParticle:CCParticleSystem = CCParticleSystem(file: "turbina2.plist")
        leftParticle.position = CGPoint(x: (self.contentSize.width/2) - 10.0, y: self.contentSize.height - 5)
        self.addChild(leftParticle, z:ObjectsLayers.turbina.rawValue)
    }
    
    func turbina4(){
        let rightParticle:CCParticleSystem = CCParticleSystem(file: "turbina2.plist")
        rightParticle.position = CGPoint(x: self.contentSize.width/2, y: self.contentSize.height - 5)
        rightParticle.scale = 1.5
        self.addChild(rightParticle, z:ObjectsLayers.turbina.rawValue)
    }
    
    func turbina5(){
        let rightParticle:CCParticleSystem = CCParticleSystem(file: "turbina2.plist")
        rightParticle.position = CGPoint(x: self.contentSize.width/2, y: self.contentSize.height - 5)
        self.addChild(rightParticle, z:ObjectsLayers.turbina.rawValue)
    }
    
    func activeShield(){
        self.isShielded = true
        self.shieldLife = 200.0
        self.shield.anchorPoint = CGPointMake(0.5, 0.5)
        self.shield.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2)
        self.addChild(shield, z: ObjectsLayers.Shot.rawValue)
    }
    
    func removeShield(){
        self.isShielded = false
        self.shield.scale = 0.0
        self.shield.anchorPoint = CGPointMake(0.5, 0.5)
    }
    
	deinit {
		
	}
}
