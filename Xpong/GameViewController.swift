//
//  GameViewController.swift
//  Xpong
//
//  Created by enzo bot on 4/24/16.
//  Copyright (c) 2016 bot. All rights reserved.
//

import UIKit
import SpriteKit
var UIUserInterfaceIdiomPad = UI_USER_INTERFACE_IDIOM()

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let skView = view as! SKView!
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//            let scene = GameScene(size: CGSize(width: 768, height: 1024))
//            /* Sprite Kit applies additional optimizations to improve rendering performance */
//            skView.ignoresSiblingOrder = true
//            
//            /* Set the scale mode to scale to fit the window */
//            scene.scaleMode = .AspectFill
//            
//            skView.presentScene(scene)
//        }else{
        let scene = GameScene(size: CGSize(width: 1080, height: 1920))
        
            // Configure the view.
            //let skView = self.view as! SKView
            
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView?.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFit
            
            skView?.presentScene(scene)
        //}
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
