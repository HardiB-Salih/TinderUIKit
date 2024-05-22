//
//  SegmentedBarView.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/22/24.
//

import UIKit

class SegmentedBarView: UIStackView {
    
    //MARK: - Properties
    
    //MARK: - Life cycle
    init(numberOfSegments: Int) {
        super.init(frame: .zero)
        
        (0..<numberOfSegments).forEach { index in
            let barView = UIView()
            barView.backgroundColor = .barDeselectedColor
            barView.layer.cornerRadius = 2
            barView.layer.cornerCurve = .continuous
            addArrangedSubview(barView)
        }
        
        arrangedSubviews.first?.backgroundColor = .white.withAlphaComponent(0.8)
        spacing = 6
        distribution = .fillEqually
        
    }
    
    

    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: Helpers
    func setHighlighted(index: Int) {
        arrangedSubviews.forEach({ $0.backgroundColor = .barDeselectedColor })
        arrangedSubviews[index].backgroundColor = .white.withAlphaComponent(0.8)
    }
}

