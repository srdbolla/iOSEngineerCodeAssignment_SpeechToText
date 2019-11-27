//
//  KeywordCollectionViewCell.swift
//  CodeAssignment_SpeechToText
//
//  Created by Sri Divya Bolla on 21/11/19.
//  Copyright © 2019 Sri Divya Bolla. All rights reserved.
//

import UIKit

/**
 KeywordCollectionCellDelegate --> contains deleteButtonTappedFor method which is called on tap of delete button in each keyword
 */
protocol KeywordCollectionCellDelegate {
    func deleteButtonTappedFor(keyword: String?)
}

/**
 KeywordCollectionViewCell --> Cell which shows each keyword and a delete button
 */
class KeywordCollectionViewCell: UICollectionViewCell {
    
    /**
     IBOutlets
     */
    @IBOutlet weak var keywordLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    /**
     Variables
     */
    var delegate: KeywordCollectionCellDelegate?
    var keywordCellViewModel: KeywordCellViewModel?
    
    //Default methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /**
        deleteButtonAction --> method called on tap of delete button of each keyword
     */
    @IBAction func deleteButtonAction(_ sender: Any) {
        self.delegate?.deleteButtonTappedFor(keyword: keywordCellViewModel?.keyword)
    }
    
    /**
    configureCell --> configures the cell and assigns the keyword string to each keywordLabel
     */
    func configureCell(keyword: String) {
        keywordLabel.text = keyword
        
        self.keywordCellViewModel = KeywordCellViewModel.init(keywordString: keyword)
    }
}


/**
 cornerRadius, borderWidth and borderColor have been given
 */
extension KeywordCollectionViewCell {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
}
