import SpriteKit

var invaderNum = 1
struct CollisionCategories{
    static let Invader : UInt32 = 0x1 << 0
    static let Player: UInt32 = 0x1 << 1
    static let InvaderBullet: UInt32 = 0x1 << 2
    static let PlayerBullet: UInt32 = 0x1 << 3
}

class GameScene: SKScene, SKPhysicsContactDelegate{
    let rowsOfInvaders = 4
    var invaderSpeed = 2
    let leftBounds = CGFloat(30)
    var rightBounds = CGFloat(0)
    var invadersWhoCanFire:[Invader] = []
    let player:Player = Player()
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.gravity=CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        backgroundColor = SKColor.blackColor()
        rightBounds = self.size.width - 30
        setupInvaders()
        setupPlayer()
        invokeInvaderFire()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            player.fireBullet(self)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        moveInvaders()
    }
    
    func setupInvaders(){
        
        var invaderRow = 0;
        var invaderColumn = 0;
        let numberOfInvaders = invaderNum * 2 + 1
        for var i = 1; i <= rowsOfInvaders; i++ {
            invaderRow = i
            for var j = 1; j <= numberOfInvaders; j++ {
                invaderColumn = j
                let tempInvader:Invader = Invader()
                let invaderHalfWidth:CGFloat = tempInvader.size.width/2
                let xPositionStart:CGFloat = size.width/2 - invaderHalfWidth - (CGFloat(invaderNum) * tempInvader.size.width) + CGFloat(10)
                tempInvader.position = CGPoint(x:xPositionStart + ((tempInvader.size.width+CGFloat(10))*(CGFloat(j-1))), y:CGFloat(self.size.height - CGFloat(i) * 46))
                tempInvader.invaderRow = invaderRow
                tempInvader.invaderColumn = invaderColumn
                addChild(tempInvader)
                if(i == rowsOfInvaders){
                    invadersWhoCanFire.append(tempInvader)
                }
            }
        }
    }
    
    func setupPlayer(){
        player.position = CGPoint(x:CGRectGetMidX(self.frame), y:player.size.height/2 + 10)
        addChild(player)
    }
    
    
    func moveInvaders(){
        var changeDirection = false
        enumerateChildNodesWithName("invader") { node, stop in
            let invader = node as SKSpriteNode
            let invaderHalfWidth = invader.size.width/2
            invader.position.x -= CGFloat(self.invaderSpeed)
            if(invader.position.x > self.rightBounds - invaderHalfWidth || invader.position.x < self.leftBounds + invaderHalfWidth){
                changeDirection = true
            }
            
        }
        
        if(changeDirection == true){
            self.invaderSpeed *= -1
            self.enumerateChildNodesWithName("invader") { node, stop in
                let invader = node as SKSpriteNode
                invader.position.y -= CGFloat(46)
            }
            changeDirection = false
        }
        
    }
    
    
    
    func invokeInvaderFire(){
        let fireBullet = SKAction.runBlock(){
            self.fireInvaderBullet()
        }
        let waitToFireInvaderBullet = SKAction.waitForDuration(1.5)
        let invaderFire = SKAction.sequence([fireBullet,waitToFireInvaderBullet])
        let repeatForeverAction = SKAction.repeatActionForever(invaderFire)
        runAction(repeatForeverAction)
        
    }
    
    
    func fireInvaderBullet(){
       let randomInvader = invadersWhoCanFire.randomElement()
       randomInvader.fireBullet(self)
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & CollisionCategories.Invader != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.PlayerBullet != 0)){
                NSLog("Invader and Player Bullet Conatact")
        }
        
        if ((firstBody.categoryBitMask & CollisionCategories.Player != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.InvaderBullet != 0)) {
               NSLog("Player and Invader Bullet Contact")
        }
        
        if ((firstBody.categoryBitMask & CollisionCategories.Invader != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.Player != 0)) {
                NSLog("Invader and Player Collision Contact")
               
        }
        
    }
    
}
