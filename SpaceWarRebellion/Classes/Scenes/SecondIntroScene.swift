//
//  SecondIntroScene.swift
//  SpaceWarRebellion
//
//  Created by Usuário Convidado on 02/03/16.
//  Copyright © 2016 Flameworks. All rights reserved.
//

import UIKit

class SecondIntroScene: CCScene {
    private let screenSize:CGSize = CCDirector.sharedDirector().viewSize()
    private let legenda:CCLabelTTF = CCLabelTTF(string: "A", fontName: "Chalkduster", fontSize: 18.0)
    private var arrLegenda:[Character] = []
    private var cont: Int = 0
    private var fimLegenda: Bool = false
    
    override init() {
        super.init()
        self.userInteractionEnabled = true
        self.createSceneObjects()
        
        let string : String = "s pessoas mais poderosas da terra já se mobilizam para defendê-la."
        let characters = Array(string.characters)
        self.arrLegenda = characters
    }
    
    override func onEnter() {
        super.onEnter()
    }
    
    override func update(delta: CCTime) {
        if(cont < self.arrLegenda.count) {
            self.legenda.string.append(self.arrLegenda[cont])
            cont++
        }
        else {
            if(!fimLegenda) {
                let tapButton: CCLabelTTF = CCLabelTTF(string: "[Tap to next...]", fontName: "Verdana-Bold", fontSize: 18.0)
                tapButton.position = CGPointMake(650, 50)
                self.addChild(tapButton)
                self.fimLegenda = true
            }
        }
    }
    
    func createSceneObjects(){
        let background: CCSprite = CCSprite(imageNamed: "bgSpace.png")
        background.anchorPoint = CGPointMake(0.0, 0.0)
        background.position = CGPointMake(0.0, 0.0)
        self.addChild(background)
        
        let boss: CCSprite = CCSprite(imageNamed: "secondIntro.png")
        boss.position = CGPointMake(self.screenSize.width / 2, screenSize.height / 2)
        self.addChild(boss)
        
        self.legenda.position = CGPointMake(self.screenSize.width / 2, 100)
        self.addChild(legenda)
    }
    
    override func touchBegan(touch: UITouch!, withEvent event: UIEvent!) {
        StateMachine.sharedInstance.changeScene(StateMachineScenes.ThirdIntroScene, isFade: true)
    }
    
    override func onExit() {
        super.onExit()
    }
}
