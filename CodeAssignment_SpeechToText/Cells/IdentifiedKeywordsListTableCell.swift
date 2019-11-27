//
//  IdentifiedKeywordsListTableCell.swift
//  CodeAssignment_SpeechToText
//
//  Created by Sri Divya Bolla on 21/11/19.
//  Copyright © 2019 Sri Divya Bolla. All rights reserved.
//

import UIKit

/**
 IdentifiedKeywordsListTableCellDelegate --> contains computeKeywordsIdentifiedDictionary method which identifies the user entered keywords from the speech that is converted to text
 */
protocol IdentifiedKeywordsListTableCellDelegate {
    func computeKeywordsIdentifiedDictionary()
}

/**
 IdentifiedKeywordsListTableCell --> This cell shows the  user keywords identified in the speech converted text
 */
class IdentifiedKeywordsListTableCell: UITableViewCell {

    /**
        IBOutlets
     */
    @IBOutlet weak var keywordsTableView: UITableView!
    
    /**
     Variables
     */
    var keywordsIdentifiedDictionary: [String: Int] = [:]
    var delegate: IdentifiedKeywordsListTableCellDelegate?
    
    /**
     Constants
     */
    enum Constants {
        static let keywordsTableViewCellIdentifier = "KeywordsTableViewCell"
        static let keywordsTableViewCellNibName = "KeywordsTableViewCell"
    }
    
    //Default Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /**
     IBAction identifyKeywordsAction --> called when Identify Keywords button is tapped
     */
    @IBAction func identifyKeywordsAction(_ sender: Any) {
        self.delegate?.computeKeywordsIdentifiedDictionary()
    }
    
    //Custom Methods
    /**
     setKeywordsTableViewDelegateAndReload --> this method sets the keywordsTableView delegate and dataSource, registers KeywordsTableViewCell, and reloads the keywordsTableView
     */
    func setKeywordsTableViewDelegateAndReload() {
        
        self.keywordsTableView.delegate = self
        self.keywordsTableView.dataSource = self
        
        self.keywordsTableView.register(UINib.init(nibName: Constants.keywordsTableViewCellNibName, bundle: nil), forCellReuseIdentifier: Constants.keywordsTableViewCellIdentifier)
        
        self.keywordsTableView.tableFooterView = UIView()
        self.reloadTableView()
    }
    
    /**
     reloadTableView --> reloads the keywordsTableView
     */
    func reloadTableView() {
        self.keywordsTableView.reloadData()
    }
    
}

/**
 Confirms to UITableViewDelegate and UITableViewDataSource
 */
extension IdentifiedKeywordsListTableCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keywordsIdentifiedDictionary.keys.sorted().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let keywordsTableViewCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.keywordsTableViewCellIdentifier, for: indexPath)
        let key = keywordsIdentifiedDictionary.keys.sorted()[indexPath.row]
        keywordsTableViewCell.textLabel?.text = key
        keywordsTableViewCell.detailTextLabel?.text = "\(keywordsIdentifiedDictionary[key] ?? 0)"
        return keywordsTableViewCell
    }
}

