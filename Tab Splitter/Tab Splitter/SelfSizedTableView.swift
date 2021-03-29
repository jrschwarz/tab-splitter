//
//  SelfSizedTableView.swift
//  Tab Splitter
//
//  Created by Joseph Schwarz on 3/29/21.
//

import UIKit

class SelfSizedTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            UIView.animate(withDuration: 0.3, animations: {
                self.invalidateIntrinsicContentSize()
                self.setNeedsLayout()
                self.layoutIfNeeded()
            })
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
