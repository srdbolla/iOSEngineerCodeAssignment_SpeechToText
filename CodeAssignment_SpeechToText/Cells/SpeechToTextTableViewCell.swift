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
     Constants
     */
    
    enum Constants {
        static let startSpeechRecordingString = "Start Recording Speech"
        static let stoppingString = "Stopping"
        static let stopSpeechRecordingString = "Stop recording Speech"
    }
    
    /**
     IBOutlets
     */
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var convertedTextFromSpeechLabel: UILabel!
    @IBOutlet weak var recordSpeechButton: UIButton!
    
    /**
     Variables
     */
    var audioEngine: AVAudioEngine = AVAudioEngine()
    var speechRecognizer: SFSpeechRecognizer?
    var speechRecognitionRequest: SFSpeechAudioBufferRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    var speechRecognitionTask: SFSpeechRecognitionTask?

    var delegate: SpeechToTextTableCellDelegate?
    var recordedSpeechString: String = ""
    
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
        startOrStopRecordingSpeech()
    }
    
    func startOrStopRecordingSpeech() {
        if audioEngine.isRunning {
            stopRecordingSpeech()
        } else {
            initializeVariables()
            convertedTextFromSpeechLabel.text = ""
            showActivityIndicator()
            recordSpeechButton.setTitle(Constants.stopSpeechRecordingString, for: [])

            recognizeSpeechAndConvertToText()
        }
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
        self.showTextLabelWhenSpeechIsNotRecorded()

        speechRecognizer = nonNilSpeechRecognizer
        speechRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        speechRecognitionTask = speechRecognizer?.recognitionTask(with: speechRecognitionRequest) { [weak self] (result, error) in
            if let speechRecognitionResult = result {
                DispatchQueue.main.async {
                    let convertedSpeechToTextString = speechRecognitionResult.bestTranscription.formattedString
                    self?.recordedSpeechString = convertedSpeechToTextString
                }
            }
        }
    }
    
    func stopRecordingSpeech() {
        self.convertedTextFromSpeechLabel.text = self.recordedSpeechString
        self.delegate?.updateSpeechTextString(text: self.recordedSpeechString)

        self.audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        self.speechRecognitionTask = nil
        self.recordSpeechButton.setTitle(Constants.startSpeechRecordingString, for: [])
        self.hideActivityIndicator()
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
