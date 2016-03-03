//
//  Effect.swift
//  SpaceWarRebellion
//
//  Created by Siro Souza on 3/2/16.
//  Copyright © 2016 Flameworks. All rights reserved.
//

import UIKit

class Effect: CCSprite {
    var gameScene: GameScene?
    /*
    override init() {
        super.init()
        self.runningAction = self.createActionRun()
    }
    
    // Cria acao da animacao do alien correndo infinitamente
    self.runningAction = self.createActionRun()

    func createActionRun() -> CCActionRepeatForever {
        let aName:String = "explosion"
        let qtdFrames:Int = 13
        // Carrega os frames da animacao dentro do arquivo passado dada a quantidade de frames
        var animFrames:Array<CCSpriteFrame> = Array()
        for (var i = 1; i <= qtdFrames; i++) {
            let name:String = "\(aName)\(i).png"
            animFrames.append(CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName(name))
        }
        // Cria a animacao dos frames montados
        let animation:CCAnimation = CCAnimation(spriteFrames: animFrames, delay: 0.03)
        // Cria a acao com a animacao dos frames
        let animationAction:CCActionAnimate = CCActionAnimate(animation: animation)
        // Monta a repeticao eterna da animacao
        let actionForever:CCActionRepeatForever = CCActionRepeatForever(action: animationAction)
        
        return actionForever
    }
    */
}
