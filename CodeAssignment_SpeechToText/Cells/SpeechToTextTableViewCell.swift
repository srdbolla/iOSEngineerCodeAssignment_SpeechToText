//
//  SpeechToTextTableViewCell.swift
//  CodeAssignment_SpeechToText
//
//  Created by Sri Divya Bolla on 21/11/19.
//  Copyright © 2019 Sri Divya Bolla. All rights reserved.
//

import UIKit
import Speech

/**
 SpeechToTextTableCellDelegate --> It has a method updateSpeechTextString to update the speech text string in the ViewModel
 */
protocol SpeechToTextTableCellDelegate {
    func updateSpeechTextString(text: String)
}

/**
 SpeechToTextTableViewCell --> Used for recording the speech and converting speech to text
 */
class SpeechToTextTableViewCell: UITableViewCell {

    /**
     IBOutlets
     */
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var convertedTextFromSpeechLabel: UILabel!
    
    /**
     Variables
     */
    var audioEngine: AVAudioEngine = AVAudioEngine()
    var speechRecognizer: SFSpeechRecognizer?
    var speechRecognitionRequest: SFSpeechAudioBufferRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    var speechRecognitionTask: SFSpeechRecognitionTask?

    var delegate: SpeechToTextTableCellDelegate?
    
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
     IBAction --> recordSpeechAndConvertToTextAction --> method called when "Tap to record speech" button is tapped
     */
    @IBAction func recordSpeechAndConvertToTextAction(_ sender: UIButton) {
        initializeVariables()
        convertedTextFromSpeechLabel.text = ""
        showActivityIndicator()
        
        hideTextLabelWhenSpeechIsNotRecorded()
        showActivityIndicator()
        
        recognizeSpeechAndConvertToText()
    }
    
    //Custom Methods
    
    /**
     initializeVariables --> Method to initialize the variables
     */
    func initializeVariables() {
        audioEngine = AVAudioEngine.init()
        speechRecognizer = SFSpeechRecognizer.init()
        speechRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    }
        
    /**
     recognizeSpeechAndConvertToText --> recognizes speech and converts it to text
     */
    func recognizeSpeechAndConvertToText() {
        let node = audioEngine.inputNode
        let outputFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: outputFormat) { (buffer, audioTime) in
            self.speechRecognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch let error as NSError  {
            print(error)
            hideActivityIndicator()
        }
        
        guard let nonNilSpeechRecognizer = SFSpeechRecognizer() else {
            hideActivityIndicator()
            return
        }
        if !nonNilSpeechRecognizer.isAvailable {
            hideActivityIndicator()
            return
        }
        
        speechRecognizer = nonNilSpeechRecognizer
        
        speechRecognitionTask = speechRecognizer?.recognitionTask(with: speechRecognitionRequest, resultHandler: { [weak self] (result, error) in
            if let speechRecognitionResult = result {
                DispatchQueue.main.async {
                    self?.showTextLabelWhenSpeechIsNotRecorded()
                    self?.hideActivityIndicator()
                    
                    let convertedSpeechToTextString = speechRecognitionResult.bestTranscription.formattedString
                    self?.convertedTextFromSpeechLabel.text =  convertedSpeechToTextString
                    
                    self?.delegate?.updateSpeechTextString(text: convertedSpeechToTextString)
                    
                }
            }
        })
    }
    
    /**
     hideTextLabelWhenSpeechIsNotRecorded --> to hide convertedTextFromSpeechLabel
     */
    func hideTextLabelWhenSpeechIsNotRecorded() {
        convertedTextFromSpeechLabel.isHidden = true
    }
    
    /**
        showTextLabelWhenSpeechIsNotRecorded --> to show convertedTextFromSpeechLabel
     */
    func showTextLabelWhenSpeechIsNotRecorded() {
        convertedTextFromSpeechLabel.isHidden = false
    }
    
    /**
        showActivityIndicator --> shows the activity indicator and starts animating
     */
    func showActivityIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    /**
        hideActivityIndicator --> hides activity indicator and stops animating
     */
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }

}
