//
//  FMDetalFooterView.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/14.
//

import UIKit

class FMDetalFooterView: UITableViewHeaderFooterView {
    
    lazy var maskLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0.5, width: self.bounds.width, height: self.bounds.height), byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 5, height: 5))
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
}
