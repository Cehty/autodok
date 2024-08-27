//
//  UIView+Shrink.swift
//  SantehnikApp
//
//  Created by Евгений Таран on 12.12.22.
//

import Foundation
import UIKit

extension UIView {
    func shrink(with direction: ShrinkDirection, and scale: CGFloat? = nil) {
        UIView.animate(withDuration: 0.2) {
            switch direction {
            case .down:
                guard let scale = scale else {
                    self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                    return
                }
                self.transform = CGAffineTransform(scaleX: scale, y: scale)
            case .up:
                guard let scale = scale else {
                    self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    return
                }
                self.transform = CGAffineTransform(scaleX: scale, y: scale)
            case .identity:
                self.transform = .identity
            }
        }
    }
    
    enum ShrinkDirection {
        case down
        case up
        case identity
    }
}
