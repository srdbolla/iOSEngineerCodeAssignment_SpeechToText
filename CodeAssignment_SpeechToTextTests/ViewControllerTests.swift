//
//  ViewControllerTests.swift
//  CodeAssignment_SpeechToTextTests
//
//  Created by Sri Divya Bolla on 27/11/19.
//  Copyright © 2019 Sri Divya Bolla. All rights reserved.
//

import XCTest
@testable import CodeAssignment_SpeechToText

class ViewControllerTests: XCTestCase {

    var viewController: ViewController?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "ViewController") as? ViewController
        self.configureViewModel()
        _ = viewController?.view
    }
        
    func configureViewModel() {
        viewController?.viewModel = ViewModel()

        viewController?.viewModel.keywords = [KeywordCellViewModel.init(keywordString: "dog"), KeywordCellViewModel.init(keywordString: "cat"), KeywordCellViewModel.init(keywordString: "the"), KeywordCellViewModel.init(keywordString: "chase")]
//        viewController?.updateKeywords(keywords: )

        viewController?.viewModel.speechToTextString = "The dog has been chasing the cat since morning"
        viewController?.viewModel.assignIdentifiedKeywordsDictionary()

//        viewController?.updateSpeechTextString(text: "The dog has been chasing the cat since morning")
    }

    func testIBOutletsAndVariables() {
        XCTAssertNotNil(viewController?.tableView, "tableView outlet is not proper")
        XCTAssertNotNil(viewController?.viewModel, "viewModel is not nil")
    }

    func testConfigureTableView() {
        XCTAssertNotNil(viewController?.configureTableView())
    }

    func testNumberOfSections() {
        if let tableView = viewController?.tableView {
            XCTAssert(tableView.numberOfSections > 0, "Number of sections is zero")
        }
    }

    func testNumberOfRowsInSection() {
        if let tableView = viewController?.tableView {
            let numberOfSections = tableView.numberOfSections
            for section in 0..<numberOfSections {
                let numberOfRows = tableView.numberOfRows(inSection: section)
                if section == 0 {
                    XCTAssert(numberOfRows == 1, "Number of rows didn't match")
                } else {
                    XCTAssert(numberOfRows == 2, "Number of rows didn't match")
                }
            }
        }
    }

    func testCellForRowAtIndexPath() {
        if let tableView = viewController?.tableView {
            let numberOfSections = tableView.numberOfSections
            for section in 0..<numberOfSections {
                let numberOfRows = tableView.numberOfRows(inSection: section)
                for row in 0..<numberOfRows {
                    let indexPath = IndexPath.init(row: row, section: section)
                    var cell = tableView.cellForRow(at: indexPath)
                    switch cell {
                    case is InputKeywordsFromUserTableViewCell:
                        testInputKeyworrdsFromUserTableCell(cell: cell as? InputKeywordsFromUserTableViewCell)
                        break
                    case is SpeechToTextTableViewCell:
                        testSpeechToTextTableViewCell(cell: cell as? SpeechToTextTableViewCell)
                        break
                    case is IdentifiedKeywordsListTableCell:

                        break
                    default:
                        break

                    }
                }
            }
        }
    }

    func testInputKeyworrdsFromUserTableCell(cell: InputKeywordsFromUserTableViewCell?) {
        XCTAssertNotNil(cell?.keywordsTextField, "keywordsTextField is nil")
        XCTAssertNotNil(cell?.keywordsCollectionView, "keywordsCollectionView is nil")

        cell?.keywordsArray = viewController?.viewModel.keywords ?? []
        cell?.delegate = viewController
        cell?.keywordsTextField.text = "Hello"
        cell?.addKeywordButtonAction(UIButton())
        cell?.setKeywordsCollectionViewDelegateAndReload()

        XCTAssertNotNil(cell?.configureCollectionView())

        XCTAssert(cell?.keywordsArray.contains(where: { (keywordCellViewModel) -> Bool in
            return keywordCellViewModel.keyword == "Hello"
        }) == true, "cell?.keywordsArray doesn't contain Hello keyword")

        cell?.keywordsTextField.text = "dog"
        XCTAssert(cell?.isNotNewKeyword() == true, "should not be a new keyword")

        XCTAssertNotNil(cell?.deleteButtonTappedFor(keyword: "Hello"))
        XCTAssert(cell?.keywordsArray.contains(where: { (keywordCellViewModel) -> Bool in
            return keywordCellViewModel.keyword == "Hello"
        }) == false, "keywordsArray should not contain Hello keyword")
        
        cell?.keywordsCollectionView.reloadData()
        if let collectionView = cell?.keywordsCollectionView {
            let sections = collectionView.numberOfSections
            for section in 0..<sections {
                XCTAssert(collectionView.numberOfItems(inSection: section) == cell?.keywordsArray.count)
                let numberOfItems = collectionView.numberOfItems(inSection: section)

                for item in 0..<numberOfItems {
                    let indexPath = IndexPath.init(item: item, section: section)
                    XCTAssert((collectionView.cellForItem(at: indexPath) != nil))
                    if let keywordCollectionCell = cell?.keywordsCollectionView.dequeueReusableCell(withReuseIdentifier: InputKeywordsFromUserTableViewCell.Constants.collectionCellIdentifier, for: indexPath) as? KeywordCollectionViewCell {
                        keywordCollectionCell.configureCell(keyword: cell?.keywordsArray[indexPath.item].keyword ?? "")
                        
                        keywordCollectionCell.delegate = cell
                        cell?.keywordsCollectionView.addSubview(keywordCollectionCell)
                    }
                    if let keywordCollectionViewCell = (cell?.keywordsCollectionView.subviews.last as? KeywordCollectionViewCell) {
                        XCTAssertNotNil(keywordCollectionViewCell.keywordLabel)
                        XCTAssertNotNil(keywordCollectionViewCell.deleteButton)

                        XCTAssertNotNil(keywordCollectionViewCell.keywordCellViewModel)
                    }
                }

            }
        }
    }

    func testSpeechToTextTableViewCell(cell: SpeechToTextTableViewCell?) {
        XCTAssert(((cell?.activityIndicator) != nil))
        XCTAssert(((cell?.convertedTextFromSpeechLabel) != nil))
        recognizeSpeechAndConvertToTextPart(cell: cell)
        
        XCTAssertNotNil(cell?.hideActivityIndicator())
        XCTAssertNotNil(cell?.hideTextLabelWhenSpeechIsNotRecorded())
        XCTAssertNotNil(cell?.showActivityIndicator())
        XCTAssertNotNil(cell?.showTextLabelWhenSpeechIsNotRecorded())
    }
    
    func recognizeSpeechAndConvertToTextPart(cell: SpeechToTextTableViewCell?) {
        XCTAssertNotNil(cell?.recognizeSpeechAndConvertToText())
    }

    func testIdentifiedKeywordsListTableViewCell(cell: IdentifiedKeywordsListTableCell?) {
        XCTAssertNotNil(cell?.keywordsTableView)
        XCTAssertNotNil(cell?.keywordsIdentifiedDictionary)
        XCTAssertNotNil(cell?.keywordsIdentifiedDictionary.keys.count ?? 0 > 0)
        cell?.delegate = viewController
        XCTAssertNotNil(cell?.identifyKeywordsAction(UIButton()))

        XCTAssertNotNil(cell?.setKeywordsTableViewDelegateAndReload())

        if let tableView = cell?.keywordsTableView {
            let sections = tableView.numberOfSections
            for section in 0..<sections {
                XCTAssert(tableView.numberOfRows(inSection: section) == cell?.keywordsIdentifiedDictionary.keys.sorted().count)
                let numberOfRows = tableView.numberOfRows(inSection: section)
                for row in 0..<numberOfRows {
                    let indexPath = IndexPath.init(row: row, section: section)
                    let tableViewCell = tableView.cellForRow(at: indexPath)
                    XCTAssertNotNil(tableViewCell)
                    XCTAssert(tableViewCell?.textLabel?.text?.count ?? 0 > 0)
                    XCTAssert(tableViewCell?.detailTextLabel?.text?.count ?? 0 > 0)
                }
            }
        }
    }

    func testCreateInputKeywordsFromUserCell() {
        if let tableView = viewController?.tableView {
            XCTAssertNotNil(viewController?.createInputKeywordsFromUserCell(tableView: tableView, indexPath: IndexPath.init(row: 0, section: 0)))

        }
    }

    func testCreateSpeechToTextTableViewCell() {
        if let tableView = viewController?.tableView {
            XCTAssertNotNil(viewController?.createSpeechToTextTableViewCell(tableView: tableView, indexPath: IndexPath.init(row: 0, section: 1)))
        }
    }

    func testCreateIdentifiedKeywordsListTableCell() {
        if let tableView = viewController?.tableView {
            XCTAssertNotNil(viewController?.createIdentifiedKeywordsListTableCell(tableView: tableView, indexPath: IndexPath.init(row: 1, section: 1)))
        }
    }

    func testPresentAlertController() {
        XCTAssertNotNil(viewController?.presentAlertController(alertController: UIAlertController.init(title: "Test Alert", message: "", preferredStyle: .alert)))
    }

    func testComputeKeywordsIdentifiedDictionary() {
        XCTAssertNotNil(viewController?.computeKeywordsIdentifiedDictionary())
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
