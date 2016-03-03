//
//  Constantes.swift
//  CocosSwift
//
//  Created by Thales Toniolo on 9/22/14.
//  Copyright (c) 2014 Flameworks. All rights reserved.
//
// Tamanho da tela do director
let screenSize:CGSize = CCDirector.sharedDirector().viewSize()

// Layers dos objetos
enum ObjectsLayers:Int {
	case HUD = 6
	case Shot = 5
	case Player = 4
    case turbina = 3
	case Foes = 2
	case Background = 1
}
