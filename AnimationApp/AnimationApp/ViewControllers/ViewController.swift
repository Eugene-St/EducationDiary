//
//  ViewController.swift
//  AnimationApp
//
//  Created by Eugene St on 08.12.2020.
//

import Spring

class ViewController: UIViewController {
    
    @IBOutlet weak var coreAnimationView: UIView!
    @IBOutlet weak var springAnimationView: SpringView!
    
    private var originCoordinate: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originCoordinate = coreAnimationView.frame.origin.x
    }
    
    @IBAction func startCoreAnimation(_ sender: UIButton) {
        sender.pulsate()
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [.autoreverse, .repeat],
                       animations: {
                        if self.coreAnimationView.frame.origin.x == self.originCoordinate {
                            self.coreAnimationView.frame.origin.x -= 40
                        } else {
                            self.coreAnimationView.frame.origin.x += 40
                        }
                       })
    }
    
    @IBAction func startSpringAnimation(_ sender: SpringButton) {
        springAnimationView.animation = "morph"
        springAnimationView.curve = "easeIn"
        springAnimationView.force = 2
        springAnimationView.animate()
        
        sender.animation = "morph"
        sender.animate()
    }
    
}

