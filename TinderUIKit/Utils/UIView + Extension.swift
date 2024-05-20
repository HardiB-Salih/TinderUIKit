//
//  UIView + Extension.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/20/24.
//

import UIKit

extension UIView {
    func crossDissolveTransition(toImage image: UIImage?, duration: TimeInterval = 0.5) {
        UIView.transition(with: self,
                          duration: duration,
                          options: .transitionCrossDissolve,
                          animations: {
                              self.layer.contents = image?.cgImage
                          },
                          completion: nil)
    }
    
    func bounceAnimation(animation: @escaping (() -> Void), completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.75,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.1,
                       animations: {
                           animation()
                       },
                       completion: { _ in
                           completion?()
                       })
    }
}

