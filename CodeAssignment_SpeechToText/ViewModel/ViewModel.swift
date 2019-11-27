//
//  ViewModel.swift
//  CodeAssignment_SpeechToText
//
//  Created by Sri Divya Bolla on 21/11/19.
//  Copyright © 2019 Sri Divya Bolla. All rights reserved.
//

import Foundation

/**
 ViewModel helps to handle the business logic and communicate with the viewController
 */
class ViewModel {
    /**
     Variables
     */
    var keywords: [KeywordCellViewModel] = []
    var speechToTextString: String = ""
    var identifiedKeywordsDictionary: [String: Int] = [:]
    
    typealias TaggedToken = (String, String?)
    
    
    //Custom Methods
    /**
     Helps to add keyword of type KeywordCellViewModel to the keywords array
     */
    func addKeyword(keyword: KeywordCellViewModel) {
        self.keywords.append(keyword)
    }
    
    /**
    Helps to remove keyword of type KeywordCellViewModel from the keywords array given an index
    */
    func removeKeywordKeywordAt(index: Int) {
        self.keywords.remove(at: index)
    }
    
    /**
     assignIdentifiedKeywordsDictionary --> assigns the identifiedKeywordsDictionary with key as keyword and value as the keyword occurance count
     */
    func assignIdentifiedKeywordsDictionary() {
        self.identifiedKeywordsDictionary = self.identifyMatchedWordsWithCount()
    }
    
    /**
            findWordsThatMatch --> returns an array of words of the text after performing lemmatization
     */
    func findWordsThatMatch(text: String, scheme: NSLinguisticTagScheme) -> [TaggedToken] {
        let options: NSLinguisticTagger.Options = [.omitWhitespace, .omitPunctuation , .omitOther]
        let tagger = NSLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemes(forLanguage: "en"),
            options: Int(options.rawValue))
        tagger.string = text
        
        let range: NSRange = NSRange.init(location: 0, length: text.utf16.count)
        var tokens: [TaggedToken] = []

        tagger.enumerateTags(in: range, unit: .word, scheme: scheme, options: options) { (tag, tokenRange, _) in
            let token = (text as NSString).substring(with: tokenRange)
            tokens.append((token, tag.map { $0.rawValue }))
        }

        return tokens
    }
    
    /**
            identifyMatchedWordsWithCount --> Method to identify the words given by the user in the speech text
     */
    func identifyMatchedWordsWithCount() -> [String: Int] {
        var matchedKeywordsDictionary: [String: Int] = [:]
        let taggedTokensArray = findWordsThatMatch(text: speechToTextString, scheme: .lemma)
        let lemmatizedTokens = taggedTokensArray.compactMap { (originalWord, lemmatizedWord) -> String? in
            return lemmatizedWord ?? nil
        }
        var lemmatizedDictionary: [String: Int] = [:]
        
        for lemmatizedWord in lemmatizedTokens {
            if let dictionaryValue = lemmatizedDictionary[lemmatizedWord] {
                lemmatizedDictionary[lemmatizedWord] = dictionaryValue + 1
            } else {
                lemmatizedDictionary[lemmatizedWord] = 1
            }
        }
        
        for keyword in keywords {
            if let keywordCountValue = lemmatizedDictionary[keyword.keyword] {
                matchedKeywordsDictionary[keyword.keyword] = keywordCountValue
            }
        }
        return matchedKeywordsDictionary
    }
}

/**
 KeywordCellViewModel has been created to handle the data of each KeywordCell
 */
class KeywordCellViewModel {
    var keyword: String = ""
    
    /**
     Initializer
     */
    init(keywordString: String) {
        self.keyword = keywordString
    }
}
