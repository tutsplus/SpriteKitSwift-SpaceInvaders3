import UIKit
import SpriteKit


class Player: SKSpriteNode {
   private var canFire = true

    override init() {
        let texture = SKTexture(imageNamed: "player1")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        self.physicsBody =
            SKPhysicsBody(texture: self.texture,size:self.size)
        self.physicsBody?.dynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = false
        self.physicsBody?.categoryBitMask = CollisionCategories.Player
        self.physicsBody?.contactTestBitMask = CollisionCategories.InvaderBullet | CollisionCategories.Invader
        self.physicsBody?.collisionBitMask = 0x0
        animate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func animate(){
        var playerTextures:[SKTexture] = []
        for i in 1...2 {
            playerTextures.append(SKTexture(imageNamed: "player\(i)"))
        }
        let playerAnimation = SKAction.repeatActionForever( SKAction.animateWithTextures(playerTextures, timePerFrame: 0.1))
        self.runAction(playerAnimation)
    }
    
    
    func die (){
        
    }
    
    func kill(){
    
    }
    
    func respawn(){
        
    }
    
    func fireBullet(scene: SKScene){
        if(!canFire){
            return
        }else{
            canFire = false
            let bullet = PlayerBullet(imageName: "laser",bulletSound: "laser.mp3")
            bullet.position.x = self.position.x
            bullet.position.y = self.position.y + self.size.height/2
            scene.addChild(bullet)
            let moveBulletAction = SKAction.moveTo(CGPoint(x:self.position.x,y:scene.size.height + bullet.size.height), duration: 1.0)
            let removeBulletAction = SKAction.removeFromParent()
            bullet.runAction(SKAction.sequence([moveBulletAction,removeBulletAction]))
            let waitToEnableFire = SKAction.waitForDuration(0.5)
            runAction(waitToEnableFire,completion:{
                self.canFire = true
            })
        }
    }
}

