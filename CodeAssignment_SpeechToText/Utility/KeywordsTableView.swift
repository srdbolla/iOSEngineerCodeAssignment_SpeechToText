//
//  KeywordsTableView.swift
//  CodeAssignment_SpeechToText
//
//  Created by Sri Divya Bolla on 05/12/19.
//  Copyright © 2019 Sri Divya Bolla. All rights reserved.
//

import Foundation
import UIKit

class KeywordsTableView: UITableView {
    
    //Code to make CollectionView height dynamic based on content size height
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}
