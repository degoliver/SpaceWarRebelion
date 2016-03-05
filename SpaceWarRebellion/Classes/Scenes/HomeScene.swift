//
//  HomeScene.swift
//  CocosSwift
//
//  Created by Thales Toniolo on 10/09/14.
//  Copyright (c) 2014 Flameworks. All rights reserved.
//
import Foundation

// MARK: - Class Definition
class HomeScene : CCScene {
	private let screenSize:CGSize = CCDirector.sharedDirector().viewSize()

	override init() {
		super.init()
        self.userInteractionEnabled = true
        self.createSceneObjects()
        self.createConfig()
    }

	override func onEnter() {
		super.onEnter()
	}
    
    func createSceneObjects(){
        let background: CCSprite = CCSprite(imageNamed: "bgSpaceMain.png")
        background.anchorPoint = CGPointMake(0.0, 0.0)
        background.position = CGPointMake(0.0, 0.0)
        self.addChild(background)
    }
    func createConfig(){

        let configButton:CCButton = CCButton(title: "", spriteFrame: CCSpriteFrame.frameWithImageNamed("config_01.png") as! CCSpriteFrame)
        configButton.scale = 0.3
        configButton.position = CGPointMake(700,10)
        configButton.anchorPoint = CGPointMake(0.0, 0.0)
        configButton.block = {(sender:AnyObject!) -> Void in
    //OALSimpleAudio.sharedInstance().playEffect("FXButtonTap.mp3")
    CCDirector.sharedDirector().replaceScene(ConfigScene())
        }
        self.addChild(configButton, z: 2)
    }

    
    override func touchBegan(touch: UITouch!, withEvent event: UIEvent!) {
        SoundPlayHelper.sharedInstance.playSoundWithControl(GameMusicAndSoundFx.ButtonTap)
        StateMachine.sharedInstance.changeScene(StateMachineScenes.GameScene, isFade: true)
    }

	override func onExit() {
		super.onExit()
	}
}
