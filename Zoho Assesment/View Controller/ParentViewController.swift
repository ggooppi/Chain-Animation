//
//  ViewController.swift
//  Zoho Assesment
//
//  Created by gopinath.a on 04/01/20.
//

import UIKit

class ParentViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var bottomViewController:WateringViewController!
    var topViewController:GraphViewController!
    var visualEffectView:UIVisualEffectView!
    
    let cardHeight:CGFloat = 400
    let topVCHeight:CGFloat = 430
    let cardHandleAreaHeight:CGFloat = 150
    let topVCVisibleArea:CGFloat = 170
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    func setupCard() {
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
        self.view.addSubview(visualEffectView)
        
        backgroundImageView.image = UIImage(named: "plant1")
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "WateringViewController")
        let view2Controller = mainStoryboard.instantiateViewController(withIdentifier: "GraphViewController")
        
        bottomViewController = (viewController as! WateringViewController)
        topViewController = (view2Controller as! GraphViewController)
        self.addChild(bottomViewController)
        self.view.addSubview(bottomViewController.view)
        self.addChild(topViewController)
        self.view.insertSubview(topViewController.view, belowSubview: bottomViewController.view)
        
        bottomViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: cardHeight)
        bottomViewController.delegate = self
        bottomViewController.view.clipsToBounds = true
        
        topViewController.view.frame = CGRect(x: 0, y: self.view.frame.height  - cardHandleAreaHeight - topVCVisibleArea, width: self.view.bounds.width, height: topVCHeight)
        topViewController.delegate = self
        topViewController.callback = {[weak self] image in
            self?.backgroundImageView.image = UIImage(named: image)
        }
        topViewController.view.clipsToBounds = true
        
    }

}

extension ParentViewController: UIViewAnimationHandler{
    
    func animateTransitionIfNeeded(givenView: String, cardVisible: Bool, state: String, duration: TimeInterval, expandHeight: CGFloat, collapseHeight: CGFloat, blurBackground: Bool, completionHandler: @escaping ((Bool) -> Void)) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                if state == CardState.expanded.rawValue {
                    if givenView == ViewName.bottom.rawValue{
                        self.bottomViewController.view.frame.origin.y = self.view.frame.height - expandHeight
                    }else{
                        self.topViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight - expandHeight + 10
                    }
                    
                }else{
                    if givenView == ViewName.bottom.rawValue{
                        self.bottomViewController.view.frame.origin.y = self.view.frame.height - collapseHeight
                    }else{
                        self.topViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight - collapseHeight
                    }
                    
                }
            }
            
            frameAnimator.addCompletion { _ in
                completionHandler(!cardVisible)
                self.runningAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
            let imageAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                
                if !cardVisible{
                    UIView.animate(withDuration: 0.3, animations: {() -> Void in
                        self.backgroundImageView?.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                    })
                }else{
                    UIView.animate(withDuration: 0.1, animations: {() -> Void in
                        self.backgroundImageView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                    })
                }
            }
            
            imageAnimator.startAnimation()
            runningAnimations.append(imageAnimator)
            
            if blurBackground {
                let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                    
                    if state == CardState.expanded.rawValue {
                        self.visualEffectView.effect = UIBlurEffect(style: .regular)
                    }else{
                        self.visualEffectView.effect = nil
                    }
                }
                
                blurAnimator.startAnimation()
                runningAnimations.append(blurAnimator)
            }
        }
    }
    
    func startInteractiveTransition(view: String, cardVisible: Bool, state: String, duration: TimeInterval, expandHeight: CGFloat, collapseHeight: CGFloat, blurBackground: Bool, completionHandler: @escaping ((Bool) -> Void)) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(givenView: view, cardVisible: cardVisible, state: state, duration: duration, expandHeight: expandHeight, collapseHeight: collapseHeight, blurBackground: blurBackground) { (status) in
                completionHandler(status)
            }
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func continueInteractiveTransition() {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
}

