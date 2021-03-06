//
//  ThirdIntroScene.swift
//  SpaceWarRebellion
//
//  Created by Usuário Convidado on 02/03/16.
//  Copyright © 2016 Flameworks. All rights reserved.
//

import UIKit

class ThirdIntroScene: CCScene {
    private let screenSize:CGSize = CCDirector.sharedDirector().viewSize()
    private let legenda:CCLabelTTF = CCLabelTTF(string: "N", fontName: "Chalkduster", fontSize: 18.0)
    private var arrLegenda:[Character] = []
    private var cont: Int = 0
    private var fimLegenda: Bool = false
    
    override init() {
        super.init()
        self.userInteractionEnabled = true
        self.createSceneObjects()
        
        let string : String = "ossa maior esperaça é enviar o grande astronauta João da Silva\n e sua super espaço-nave \"Phantom\" desenvolvida pelo pentágono."
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
        
        let boss: CCSprite = CCSprite(imageNamed: "thirdIntro.jpg")
        boss.position = CGPointMake(self.screenSize.width / 2, screenSize.height / 2)
        self.addChild(boss)
        
        self.legenda.position = CGPointMake(self.screenSize.width / 2, 100)
        self.addChild(legenda)
    }
    
    override func touchBegan(touch: UITouch!, withEvent event: UIEvent!) {
        StateMachine.sharedInstance.changeScene(StateMachineScenes.HomeScene, isFade: true)
    }
    
    override func onExit() {
        super.onExit()
    }
}
