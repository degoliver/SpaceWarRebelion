//
//  LoadingScene.swift
//  CocosSwift
//
//  Created by Thales Toniolo on 10/09/14.
//  Copyright (c) 2014 Flameworks. All rights reserved.
//
import Foundation

// MARK: - Class Definition
class LoadingScene : CCScene {
	private let screenSize:CGSize = CCDirector.sharedDirector().viewSize()

	override init() {
		super.init()
		createSceneObjects()
	}

	override func onEnter() {
		super.onEnter()
	}
    
    func createSceneObjects(){
        let label:CCLabelTTF = CCLabelTTF(string: "Loading...", fontName: "Chalkduster", fontSize: 36.0)
        label.color = CCColor.redColor()
        label.position = CGPointMake(self.screenSize.width/2, self.screenSize.height/2)
        label.anchorPoint = CGPointMake(0.5, 0.5)
        self.addChild(label)
        
        DelayHelper.sharedInstance.callBlock({ _ in
            StateMachine.sharedInstance.changeScene(StateMachineScenes.FirstIntroScene, isFade:true)
            }, withDelay: 1.0)
    }

	override func onExit() {
		super.onExit()
        CCTextureCache.sharedTextureCache().removeAllTextures()
	}
}
