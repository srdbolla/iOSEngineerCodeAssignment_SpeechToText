//
//  ViewController.swift
//  CodeAssignment_SpeechToText
//
//  Created by Sri Divya Bolla on 13/11/19.
//  Copyright © 2019 Sri Divya Bolla. All rights reserved.
//

import UIKit
import Speech


class ViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var convertedTextFromSpeechLabel: UILabel!
    
    var audioEngine: AVAudioEngine = AVAudioEngine()
    var speechRecognizer: SFSpeechRecognizer?
    var speechRecognitionRequest: SFSpeechAudioBufferRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    var speechRecognitionTask: SFSpeechRecognitionTask?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        audioEngine = AVAudioEngine.init()
        speechRecognizer = SFSpeechRecognizer.init()

    }
    
    //When tapped on the button, clear speech label text, show activity indicator, start computing the text of the label from scratch
    @IBAction func recordSpeechAndConvertToTextAction(_ sender: UIButton) {
        convertedTextFromSpeechLabel.text = ""
        showActivityIndicator()
        
        hideTextLabelWhenSpeechIsNotRecorded()
        showActivityIndicator()
        
        recognizeSpeechAndConvertToText()
    }
    
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
                    
                    self?.convertedTextFromSpeechLabel.text =  speechRecognitionResult.bestTranscription.formattedString
                }
            }
        })
    }
    
    func hideTextLabelWhenSpeechIsNotRecorded() {
        convertedTextFromSpeechLabel.isHidden = true
    }
    
    func showTextLabelWhenSpeechIsNotRecorded() {
        convertedTextFromSpeechLabel.isHidden = false
    }
    
    func showActivityIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    

}

