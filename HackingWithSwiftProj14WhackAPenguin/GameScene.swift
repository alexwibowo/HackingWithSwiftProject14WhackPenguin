//
//  GameScene.swift
//  HackingWithSwiftProj14WhackAPenguin
//
//  Created by Alex Wibowo on 25/9/21.
//

import SpriteKit


class GameScene: SKScene {
    
  
    var scoreLabel : SKLabelNode!
    
    
    var slots = [WhackSlot]()
    
    var popupTime = 0.99
    
    var round = 0
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 8, y: 30)
        addChild(scoreLabel)
        
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.showPenguin()
        }
        
    }
    
    func createSlot(at position: CGPoint){
        let slot = WhackSlot()
        slot.configure(at: position)
        slots.append(slot)
        addChild(slot)
    }
    
    func showPenguin(){
        round += 1
        if round >= 30 {
            for slot in slots {
                slot.hide()
            }

            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)

            return
        } else {
            popupTime *= 0.95
            
            slots.shuffle()
            
            slots[0].show(hideDelay: popupTime)
            if Int.random(in: 0...12) > 4 { slots[1].show(hideDelay: popupTime)}
            if Int.random(in: 0...12) > 8 { slots[2].show(hideDelay: popupTime)}
            if Int.random(in: 0...12) > 10 { slots[3].show(hideDelay: popupTime)}
            if Int.random(in: 0...12) > 12 { slots[4].show(hideDelay: popupTime)}
            
            let minDelay = popupTime / 2
            let maxDelay = popupTime * 2
            let delay = Double.random(in: minDelay...maxDelay)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.showPenguin()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else { return }
        
        let location = firstTouch.location(in: self)
        
        let nodes = nodes(at: location)
        for node in nodes {
            
            guard let penguin = node.parent?.parent as? WhackSlot else { continue }
            if penguin.isHit {
                continue
            }
            penguin.hit()
            
            if node.name == "charFriend" {
                score -= 5
            } else if node.name == "charEnemy" {
                score += 1
                
            }
        }
    }
    
    
}
