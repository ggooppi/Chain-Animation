//
//  CollapseView.swift
//  Zoho Assesment
//
//  Created by gopinath.a on 05/01/20.
//

import Foundation
import UIKit

enum CardState: String {
    case expanded, collapsed
}

enum ViewName: String{
    case bottom, top
}

protocol UIViewAnimationHandler: class {
    func animateTransitionIfNeeded(givenView: String, cardVisible: Bool, state: String, duration: TimeInterval, expandHeight: CGFloat, collapseHeight: CGFloat, blurBackground: Bool, completionHandler: @escaping ((Bool) -> Void))
    func startInteractiveTransition(view: String, cardVisible: Bool, state: String, duration:TimeInterval, expandHeight: CGFloat, collapseHeight: CGFloat, blurBackground: Bool, completionHandler: @escaping ((Bool) -> Void))
    func updateInteractiveTransition(fractionCompleted:CGFloat)
    func continueInteractiveTransition()
}
