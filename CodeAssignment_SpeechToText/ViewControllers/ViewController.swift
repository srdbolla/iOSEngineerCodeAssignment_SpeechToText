//
//  ViewController.swift
//  CodeAssignment_SpeechToText
//
//  Created by Sri Divya Bolla on 13/11/19.
//  Copyright © 2019 Sri Divya Bolla. All rights reserved.
//

import UIKit
import Speech

/**
 ViewController --> The main controller which displays the view of all three actions (enter keywords, recognize speech and convert to text, Identify the uder entered keywords in the text)
 */
class ViewController: UIViewController {

    /**
     IBOutlets
     */
    @IBOutlet weak var tableView: UITableView!
    
    /**
     ViewModel
     */
    var viewModel: ViewModel = ViewModel()
        
    /**
     Constants
     */
    enum Constants {
        static let inputKeywordsFromUserCellIdentifier = "InputKeywordsFromUserTableViewCell"
        static let speechToTextTableCellIdentifier = "SpeechToTextTableViewCell"
        static let identifiedKeywordsListCellIdentifier = "IdentifiedKeywordsListTableCell"
        
        static let inputKeywordsFromUserNibName = "InputKeywordsFromUser"
        static let speechToTextTableCellNibName = "SpeechToTextTableViewCell"
        static let identifiedKeywordsListCellNibName = "IdentifiedKeywordsListCell"

        static let numberOfSectionsInTableView: Int = 2
        static let numberOfRowsIn1SectionTableView: Int = 1
        static let numberOfRowsIn2SectionTableView: Int = 2
        
        static let tableViewRowHeight: CGFloat = 201
        
        static let section0Row1IndexPath = IndexPath.init(row: 0, section: 1)
        static let section1Row1IndexPath = IndexPath.init(row: 1, section: 1)

    }
    
    //Default Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureTableView()
        
        self.tableView.tableFooterView = UIView()

    }
    
    /**
     Method to configure the tableView by registering with the cells
     */
    func configureTableView() {
        tableView.register(UINib.init(nibName: Constants.inputKeywordsFromUserNibName, bundle: nil), forCellReuseIdentifier: Constants.inputKeywordsFromUserCellIdentifier)
        tableView.register(UINib.init(nibName: Constants.speechToTextTableCellNibName, bundle: nil), forCellReuseIdentifier: Constants.speechToTextTableCellIdentifier)
        tableView.register(UINib.init(nibName: Constants.identifiedKeywordsListCellNibName, bundle: nil), forCellReuseIdentifier: Constants.identifiedKeywordsListCellIdentifier)
                
        tableView?.estimatedRowHeight = CGFloat(Constants.tableViewRowHeight)
        tableView?.rowHeight = UITableView.automaticDimension

    }
    
}

/**
 ViewController confirms to UITableViewDelegate and UITableViewDataSource
 */
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.numberOfSectionsInTableView
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return Constants.numberOfRowsIn1SectionTableView
        } else {
            return Constants.numberOfRowsIn2SectionTableView
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            return createInputKeywordsFromUserCell(tableView: tableView, indexPath: indexPath)
        case 1:
            if indexPath.row == 0 {
                return createSpeechToTextTableViewCell(tableView: tableView, indexPath: indexPath)
            } else {
                return createIdentifiedKeywordsListTableCell(tableView: tableView, indexPath: indexPath)
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
}


extension ViewController {
    /**
     Method to create InputKeywordsFromUserTableViewCell
     */
    func createInputKeywordsFromUserCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let inputKeywordsFromUserCell = tableView.dequeueReusableCell(withIdentifier: Constants.inputKeywordsFromUserCellIdentifier, for: indexPath) as? InputKeywordsFromUserTableViewCell else {
            return UITableViewCell()
        }
        inputKeywordsFromUserCell.delegate = self
        inputKeywordsFromUserCell.configureCollectionView()
        inputKeywordsFromUserCell.setKeywordsCollectionViewDelegateAndReload()
                
        return inputKeywordsFromUserCell
    }
    
    /**
     Method to create SpeechToTextTableViewCell
     */
    func createSpeechToTextTableViewCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let speechToTextTableCell = tableView.dequeueReusableCell(withIdentifier: Constants.speechToTextTableCellIdentifier, for: indexPath) as? SpeechToTextTableViewCell else {
            return UITableViewCell()
        }
        speechToTextTableCell.delegate = self
        speechToTextTableCell.convertedTextFromSpeechLabel.text = self.viewModel.speechToTextString
        
        return speechToTextTableCell
    }
    
    /**
     Method to create IdentifiedKeywordsListTableCell
     */
    func createIdentifiedKeywordsListTableCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let identifiedKeywordsListTableCell = tableView.dequeueReusableCell(withIdentifier: Constants.identifiedKeywordsListCellIdentifier, for: indexPath) as? IdentifiedKeywordsListTableCell else {
            return UITableViewCell()
        }
        
        identifiedKeywordsListTableCell.delegate = self
            
        identifiedKeywordsListTableCell.setKeywordsTableViewDelegateAndReload()
        
        identifiedKeywordsListTableCell.keywordsIdentifiedDictionary = self.viewModel.identifiedKeywordsDictionary

        identifiedKeywordsListTableCell.keywordsTableView.reloadData()
                
        return identifiedKeywordsListTableCell
    }
    
}

/**
 ViewController confirms to InputKeywordsFromUserTableCellDelegate
 */
extension ViewController: InputKeywordsFromUserTableCellDelegate {
    func updateKeywords(keywords: [KeywordCellViewModel]) {
        self.viewModel.keywords = keywords
        self.tableView.reloadData()
    }
    
    func presentAlertController(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
}

/**
 ViewController confirms to SpeechToTextTableCellDelegate
 */
extension ViewController: SpeechToTextTableCellDelegate {
    func updateSpeechTextString(text: String) {
        self.viewModel.speechToTextString = text
        
        self.tableView.reloadRows(at: [Constants.section0Row1IndexPath], with: .automatic)

    }
    
    func computeViewModelKeywordsDictionaryAndReload() {
        self.viewModel.assignIdentifiedKeywordsDictionary()
        reloadIdentifiedKeywordsListCellTableView()
    }
        
    func reloadIdentifiedKeywordsListCellTableView() {
        self.tableView.reloadRows(at: [Constants.section1Row1IndexPath], with: .automatic)
    }
}

/**
 ViewController confirms to IdentifiedKeywordsListTableCellDelegate
 */
extension ViewController: IdentifiedKeywordsListTableCellDelegate {
    func computeKeywordsIdentifiedDictionary() {
        computeViewModelKeywordsDictionaryAndReload()
    }
}

