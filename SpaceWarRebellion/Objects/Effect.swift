//
//  Effect.swift
//  SpaceWarRebellion
//
//  Created by Siro Souza on 3/2/16.
//  Copyright © 2016 Flameworks. All rights reserved.
//

import UIKit

internal class Effect: CCNode {
    private var spriteExplosion:CCSprite?
    internal var eventSelector:Selector?
    internal var targetID:AnyObject?
    
    override init() {
        super.init()
        
        self.spriteExplosion = self.gerarAnimacaoSpriteWithName("", aQtdFrames: 6)
        self.spriteExplosion?.position = CGPointMake(200, 200)
        self.addChild(self.spriteExplosion, z: 3)
        
    }
    
    
    // MARK: - Private Methods
    func gerarAnimacaoSpriteWithName(aSpriteName:String, aQtdFrames:Int) -> CCSprite {
        // Carrega os frames da animacao dentro do arquivo passado dada a quantidade de frames
        var animFrames:Array<CCSpriteFrame> = Array()
        for (var i = 1; i <= aQtdFrames; i++) {
            let name:String = "\(aSpriteName)\(i).png"
            animFrames.append(CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName(name))
        }
        // Cria a animacao dos frames montados
        let animation:CCAnimation = CCAnimation(spriteFrames: animFrames, delay: 0.1)
        // Cria a acao com a animacao dos frames
       // let animationAction:CCActionAnimate = CCActionAnimate(animation: animation)
        // Monta a repeticao eterna da animacao
        //let actionForever:CCActionRepeat = CCActionRepeat(action: animationAction, times: 1)
        // Monta o sprite com o primeiro quadro
        let spriteRet:CCSprite = CCSprite(imageNamed: "\(aSpriteName)\(1).png")
        // Executa a acao da animacao
        spriteRet.runAction(CCActionScaleTo.actionWithDuration(0.4, scale: 0.0) as! CCAction) as CCAction
        // Retorna o sprite para controle na classe
        return spriteRet
    }
}
