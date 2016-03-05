//
//  ConfigScene.swift
//  SpaceWarRebellion
//
//  Created by Usuário Convidado on 05/03/16.
//  Copyright © 2016 Flameworks. All rights reserved.
//

import Foundation

class ConfigScene : CCScene {
    private let screenSize:CGSize = CCDirector.sharedDirector().viewSize()
    var volume:Bool = true
    override init() {
        super.init()
        self.createSceneObjects()
        
        let label:CCLabelTTF = CCLabelTTF(string:"Volume:", fontName:"Arial", fontSize:40.0)
        label.color = CCColor.whiteColor()
        label.position = CGPointMake(350,650)
        self.addChild(label)
        
        let configButton:CCButton = CCButton(title: "[ off ]", fontName: "Verdana", fontSize: 32.0)
        configButton.position = CGPointMake(label.position.x + 70,label.position.y - 17)
        configButton.anchorPoint = CGPointMake(0.0, 0.0)
        configButton.block = {(sender:AnyObject!) -> Void in


            if(configButton.title == "[ off ]"){
                SoundPlayHelper.sharedInstance.setMusicVolume(0.0)
                SoundPlayHelper.sharedInstance.setEfectVolume(0.0)
                configButton.title = "[ on ]"
            }else if(configButton.title == "[ on ]"){
    SoundPlayHelper.sharedInstance.setMusicVolume(3.0)
    SoundPlayHelper.sharedInstance.setEfectVolume(3.0)
    configButton.title = "[ off ]"
            }

        }
        self.addChild(configButton, z: 2)
    }
    func createSceneObjects(){
        let background: CCSprite = CCSprite(imageNamed: "bgSpace.png")
        background.anchorPoint = CGPointMake(0.0, 0.0)
        background.position = CGPointMake(0.0, 0.0)
        self.addChild(background)
        
        let settings: CCSprite = CCSprite(imageNamed: "settings.png")
        settings.anchorPoint = CGPointMake(0.0, 0.0)
        settings.position = CGPointMake(260, 800)
        self.addChild(settings)
        
        let creditos: CCSprite = CCSprite(imageNamed: "creditos.png")
        creditos.anchorPoint = CGPointMake(0.0, 0.0)
        creditos.position = CGPointMake(260, 500)
        self.addChild(creditos)
        
        let label:CCLabelTTF = CCLabelTTF(string:"Anderson Gabriel Ferreira", fontName:"Arial", fontSize:40.0)
        label.color = CCColor.whiteColor()
        label.position = CGPointMake(380,400)
        self.addChild(label)
        let label1:CCLabelTTF = CCLabelTTF(string:"Bruno Rodrigues de Araújo", fontName:"Arial", fontSize:40.0)
        label1.color = CCColor.whiteColor()
        label1.position = CGPointMake(380,350)
        self.addChild(label1)
        let label2:CCLabelTTF = CCLabelTTF(string:"Diego Lima de Oliveira", fontName:"Arial", fontSize:40.0)
        label2.color = CCColor.whiteColor()
        label2.position = CGPointMake(380,300)
        self.addChild(label2)
        let label3:CCLabelTTF = CCLabelTTF(string:"Raphael de Oliveira Martins", fontName:"Arial", fontSize:40.0)
        label3.color = CCColor.whiteColor()
        label3.position = CGPointMake(380,250)
        self.addChild(label3)
        let label4:CCLabelTTF = CCLabelTTF(string:"Siralberto Souza Leitão de Almeida", fontName:"Arial", fontSize:40.0)
        label4.color = CCColor.whiteColor()
        label4.position = CGPointMake(380,200)
        self.addChild(label4)
        let label5:CCLabelTTF = CCLabelTTF(string:"Tiago Oliveira Monteiro", fontName:"Arial", fontSize:40.0)
        label5.color = CCColor.whiteColor()
        label5.position = CGPointMake(380,150)
        self.addChild(label5)

        

        //botao back 
        let backButton:CCButton = CCButton(title: "", spriteFrame: CCSpriteFrame.frameWithImageNamed("back.png") as! CCSpriteFrame)
        backButton.scale = 0.2
        backButton.position = CGPointMake(10,930)
        backButton.anchorPoint = CGPointMake(0.0, 0.0)
        backButton.block = {(sender:AnyObject!) -> Void in
            StateMachine.sharedInstance.changeScene(StateMachineScenes.HomeScene, isFade: true)
            
        }
        self.addChild(backButton, z: 2)
        
    }
    
    override func onEnter() {
        super.onEnter()
    }
    
    
    override func onExit() {
        super.onExit()
        CCTextureCache.sharedTextureCache().removeAllTextures()
       // self.volume == volume
        
    }
}