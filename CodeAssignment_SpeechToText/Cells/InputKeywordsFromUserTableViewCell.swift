//
//  InputKeywordsFromUserTableViewCell.swift
//  CodeAssignment_SpeechToText
//
//  Created by Sri Divya Bolla on 21/11/19.
//  Copyright © 2019 Sri Divya Bolla. All rights reserved.
//

import UIKit

/**
 InputKeywordsFromUserTableCellDelegate --> Delegate contains methods updateKeywords to update the keywords in the viewModel and presentAlertController to present the alert in the viewController characters.count =0 or if repeated words are entered
 */
protocol InputKeywordsFromUserTableCellDelegate {
    func updateKeywords(keywords: [KeywordCellViewModel])
    func presentAlertController(alertController: UIAlertController)
}

/**
 InputKeywordsFromUserTableViewCell --> This cell takes the input keywords from the user
 */
class InputKeywordsFromUserTableViewCell: UITableViewCell {

    /**
     IBOutlets
     */
    @IBOutlet weak var keywordsTextField: UITextField!
    @IBOutlet weak var keywordsCollectionView: UICollectionView!

    /**
     Variables
     */
    var keywordsArray: [KeywordCellViewModel] = []
    var delegate: InputKeywordsFromUserTableCellDelegate?
    
    /**
     Constants
     */
    enum Constants {
        static let collectionCellIdentifier = "KeywordCollectionViewCell"
        static let enterProperKeywordsMessageString = "Please do not enter repeated keywords or enter keywords with characters > 0"
        static let okString = "OK"
    }
    
    //Default methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /** IBAction addKeywordButtonAction --> this method is called when user taps on "Add Keyword" button
     */
    @IBAction func addKeywordButtonAction(_ sender: UIButton) {
        if let keywordsTextFieldText = keywordsTextField.text,
            keywordsTextFieldText.count > 0,
            !isNotNewKeyword() {
            
            keywordsArray.append(KeywordCellViewModel.init(keywordString: keywordsTextFieldText))
            self.delegate?.updateKeywords(keywords: keywordsArray)
            self.reloadKeywordsCollectionView()
            keywordsTextField.text = ""
        } else {
            let alertViewController: UIAlertController = UIAlertController.init(title: "", message: Constants.enterProperKeywordsMessageString, preferredStyle: .alert)
            let okAction: UIAlertAction = UIAlertAction.init(title: Constants.okString, style: .cancel, handler: nil)
            
            alertViewController.addAction(okAction)
            
            self.delegate?.presentAlertController(alertController: alertViewController)
        }
    }
    
    //Custom Methods
    
    /**
     Method to configure the keywordsCollectionView
     */
    func configureCollectionView() {
        self.keywordsCollectionView.register(UINib.init(nibName: Constants.collectionCellIdentifier, bundle: nil), forCellWithReuseIdentifier: Constants.collectionCellIdentifier)
    }
    /**
        isNotNewKeyword --> Method to check if keywordsTextField has existing keyword from keywordsArray
     */
    func isNotNewKeyword() -> Bool {
        keywordsArray.contains { (keywordCellViewModel) -> Bool in
            if keywordCellViewModel.keyword == keywordsTextField.text {
                return true
            }
            return false
        }
    }
    
    /**
        setKeywordsCollectionViewDelegateAndReload --> method to confirm to delegate, data source and reload the keywords collectionView
     */
    func setKeywordsCollectionViewDelegateAndReload() {
        self.keywordsCollectionView.delegate = self
        self.keywordsCollectionView.dataSource = self
        
        self.reloadKeywordsCollectionView()
    }
    
    /**
     reloadKeywordsCollectionView --> Method to reload the collectionView
    */
    func reloadKeywordsCollectionView() {
        self.keywordsCollectionView.reloadData()
    }

}

/**
 Confirming to UICollectionViewDelegate and UICollectionViewDataSource
 */
extension InputKeywordsFromUserTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keywordsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let keywordCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionCellIdentifier, for: indexPath) as? KeywordCollectionViewCell else {
            return UICollectionViewCell()
        }
        keywordCollectionCell.configureCell(keyword: keywordsArray[indexPath.item].keyword)
        
        keywordCollectionCell.delegate = self
            
        return keywordCollectionCell
    }

}

/**
 Confirming to KeywordCollectionCellDelegate
 */
extension InputKeywordsFromUserTableViewCell: KeywordCollectionCellDelegate {
    
    /**
        deleteButtonTappedFor --> method called when delete button of each keyword is tapped
     */
    func deleteButtonTappedFor(keyword: String?) {
        var indexValueOfTheKeyword: Int?
        if let nonNilKeywordValue = keyword {
            for keywordCellModelIndex in 0..<keywordsArray.count {
                if keywordsArray[keywordCellModelIndex].keyword == nonNilKeywordValue {
                    indexValueOfTheKeyword = keywordCellModelIndex
                }
            }
        }
        if let nonNilKeywordIndexValue = indexValueOfTheKeyword {
            keywordsArray.remove(at: nonNilKeywordIndexValue)
        }
        self.keywordsCollectionView.reloadData()
    }
}



