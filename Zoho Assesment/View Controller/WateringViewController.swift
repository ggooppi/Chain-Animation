//
//  WateringViewController.swift
//  Zoho Assesment
//
//  Created by gopinath.a on 05/01/20.
//

import UIKit

class WateringViewController: UIViewController {

    @IBOutlet weak var daysLabel: AnimatedLabel!
    @IBOutlet weak var waterImageView: UIImageView!
    @IBOutlet weak var gestureRegion: UIView!
    @IBOutlet weak var viewTobeHidden: UIView!
    
    @IBOutlet weak var plantInfoView: UIView!
    
    var dayCount = 7
    
    let cardHeight:CGFloat = 400
    let cardHandleAreaHeight:CGFloat = 150
    
    var cardVisible = false
    
    weak var delegate: UIViewAnimationHandler?
    
    var nextState:CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI() {
        waterImageView.roundedCorners(radius: 18)
        waterImageView.backgroundColor = .themeColor
        waterImageView.tintColor = .white
        
        plantInfoView.roundedCorners(radius: 5)
        plantInfoView.layer.borderColor = UIColor.separator.cgColor
        plantInfoView.layer.borderWidth = 2
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(WateringViewController.handleWaterImageTap(recognzier:)))
        waterImageView.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizerHandel = UITapGestureRecognizer(target: self, action: #selector(WateringViewController.handleCardHandelTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(WateringViewController.handleCardPan(recognizer:)))
        
        view.addGestureRecognizer(tapGestureRecognizerHandel)
        view.addGestureRecognizer(panGestureRecognizer)
        viewTobeHidden.alpha = 0
        
         self.view.layer.cornerRadius = 12
    }
    
    @objc
    func handleCardHandelTap(recognzier:UITapGestureRecognizer) {
        guard let delegate = self.delegate else {
          return
        }
        switch recognzier.state {
        case .ended:
            delegate.animateTransitionIfNeeded(givenView: ViewName.bottom.rawValue, cardVisible: cardVisible, state: nextState.rawValue, duration: 0.9, expandHeight: cardHeight, collapseHeight: cardHandleAreaHeight, blurBackground: false) {[weak self] (status) in
                self?.cardVisible = status
                if !self!.cardVisible{
                    UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                        self!.viewTobeHidden.alpha = 0
                    })
                    
                }else{
                    UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                        self!.viewTobeHidden.alpha = 1
                    })
                    
                }
            }
//            animateTransitionIfNeeded(state: nextState, duration: 0.9)
        default:
            break
        }
    }
    
    @objc
    func handleCardPan (recognizer:UIPanGestureRecognizer) {
        guard let delegate = self.delegate else {
          return
        }
        switch recognizer.state {
        case .began:
            delegate.startInteractiveTransition(view: ViewName.bottom.rawValue, cardVisible: cardVisible, state: nextState.rawValue, duration: 0.9, expandHeight: cardHeight, collapseHeight: cardHandleAreaHeight, blurBackground: false) {[weak self] (status) in
                self?.cardVisible = status
                if !self!.cardVisible{
                    UIView.animate(withDuration: 0.9, delay: 0.3, options: .curveEaseInOut, animations: {
                        self!.viewTobeHidden.alpha = 0
                    })
                    
                }else{
                    UIView.animate(withDuration: 0.9, delay: 0.3, options: .curveEaseInOut, animations: {
                        self!.viewTobeHidden.alpha = 1
                    })
                    
                }
            }
        case .changed:
            let translation = recognizer.translation(in: self.gestureRegion)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            delegate.updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            delegate.continueInteractiveTransition()
        default:
            break
        }
    }
    
    @objc
    func handleWaterImageTap(recognzier:UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.9, delay: 0.3, options: .curveEaseOut, animations: {
            if self.waterImageView.isHighlighted{
                self.waterImageView.tintColor = .white
                self.waterImageView.isHighlighted = !self.waterImageView.isHighlighted
                self.waterImageView.backgroundColor = .themeColor
                self.waterImageView.layer.borderWidth = 0
            }else{
                self.waterImageView.backgroundColor = .white
                self.waterImageView.tintColor = .themeColor
                self.waterImageView.layer.borderColor = UIColor.themeColor.cgColor
                self.waterImageView.layer.borderWidth = 5
                self.waterImageView.isHighlighted = !self.waterImageView.isHighlighted
               
                
            }
        }) { (_) in
            if self.waterImageView.isHighlighted{
                self.daysLabel.count(from: 1, to: 7, suffixTextSingular: "day", suffixTextPlural: "days", duration: .fast)
            }else{
                self.daysLabel.count(from: 7, to: 1, suffixTextSingular: "day", suffixTextPlural: "days", duration: .fast)
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}




