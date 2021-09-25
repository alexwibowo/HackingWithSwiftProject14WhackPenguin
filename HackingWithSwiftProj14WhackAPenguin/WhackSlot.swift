//
//  WhackHole.swift
//  HackingWithSwiftProj14WhackAPenguin
//
//  Created by Alex Wibowo on 25/9/21.
//

import UIKit
import SpriteKit

class WhackSlot: SKNode {
    
    var penguin: SKSpriteNode!
    
    var isVisible = false
    var isHit = false
    
    func configure(at position: CGPoint){
        self.position = position
        
        let spriteHole = SKSpriteNode(imageNamed: "whackHole")
        spriteHole.position = CGPoint(x: 0, y: 0)
        addChild(spriteHole)
        
        let maskNode = SKCropNode()
        maskNode.position = CGPoint(x: 0, y: 15)
        maskNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        maskNode.zPosition = 1
        addChild(maskNode)
        
        
        penguin = SKSpriteNode(imageNamed: "penguinGood")
        penguin.position = CGPoint(x: 0, y: -90)
        maskNode.addChild(penguin)
    }
    
    func show(hideDelay: Double){
        if isVisible {
            return
        }
        
        if Int.random(in: 0...2) == 0 {
            penguin.texture = SKTexture(imageNamed: "penguinGood")
            penguin.name = "charFriend"
        } else {
            penguin.texture = SKTexture(imageNamed: "penguinEvil")
            penguin.name = "charEnemy"
        }
        
        penguin.run(SKAction.moveBy(x: 0, y: 90, duration: 0.05))
        
        isVisible = true
        isHit = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideDelay * 3.5)) { [weak self] in
            self?.hide()
        }
        
    }
    
    func hide(){
        if !isVisible {
            return
        }
        
        isVisible = false
        isHit = false        
        
        penguin.run(SKAction.moveBy(x: 0, y: -90, duration: 0.05))
    }
    
    func hit(){
        isHit = true
        let isGoodPenguin = penguin.name! == "charFriend"
        penguin.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.25),
            SKAction.playSoundFileNamed(isGoodPenguin ? "whackBad": "whack", waitForCompletion: false),
            SKAction.moveBy(x: 0, y: -90, duration: 0.05),
            SKAction.run({ [weak self] in
                
                self?.isVisible = true
            })
        ]))
        
    }
}
