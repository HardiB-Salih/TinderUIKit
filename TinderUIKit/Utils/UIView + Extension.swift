//
//  UIView + Extension.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/20/24.
//

import UIKit
import SDWebImage
import QuartzCore


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




extension UIImageView {
    func crossDissolveTransition(toImageURL imageURLString: String, duration: TimeInterval = 0.5) {
        guard let url = URL(string: imageURLString) else {
            print("Invalid URL string: \(imageURLString)")
            return
        }

        // Download the image using SDWebImage
        SDWebImageManager.shared.loadImage(
            with: url,
            options: .highPriority,
            progress: nil
        ) { [weak self] (image, data, error, cacheType, finished, imageURL) in
            guard let self = self else { return }
            guard let image = image, error == nil else {
                print("Failed to load image: \(String(describing: error?.localizedDescription))")
                return
            }

            // Perform the cross-dissolve transition
            UIView.transition(with: self,
                              duration: duration,
                              options: .transitionCrossDissolve,
                              animations: {
                                  self.image = image
                              },
                              completion: nil)
        }
    }
    
    func waterTransition(toImageURL imageURLString: String, duration: TimeInterval = 0.5) {
        guard let url = URL(string: imageURLString) else {
            print("Invalid URL string: \(imageURLString)")
            return
        }

        // Download the image using SDWebImage
        SDWebImageManager.shared.loadImage(
            with: url,
            options: .highPriority,
            progress: nil
        ) { [weak self] (image, data, error, cacheType, finished, imageURL) in
            guard let self = self else { return }
            guard let image = image, error == nil else {
                print("Failed to load image: \(String(describing: error?.localizedDescription))")
                return
            }

            // Perform the water-like transition
            self.applyWaterTransition(newImage: image, duration: duration)
        }
    }
    
    private func applyWaterTransition(newImage: UIImage, duration: TimeInterval) {
        // Create the transition animation
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .reveal

        // Add the transition animation to the layer
        self.layer.add(transition, forKey: kCATransition)

        // Set the new image
        self.image = newImage
    }
}


