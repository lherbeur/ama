//
//  ViewController.swift
//  Marshabiter
//
//  Created by Olawunmi GEORGE on 5/17/20.
//  Copyright © 2020 Olawunmi GEORGE. All rights reserved.
//

import UIKit
import CoreML
import Vision

class MainScreen: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    var parentVC:UIViewController? = nil
    @IBOutlet weak var pickedImgView: UIImageView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var cameraIcon: UIImageView!
    @IBOutlet weak var pictureIcon: UIImageView!
    @IBOutlet weak var predictionLabel: UILabel!
    
    @IBOutlet weak var tellMeLabel: UILabel!
    @IBOutlet weak var thumbsUpButton: UIButton!
    @IBOutlet weak var thumbsDownButton: UIButton!
    
    @IBOutlet weak var launchCameraImg: UIImageView!
    @IBOutlet weak var launchAlbumImg: UIImageView!
    
    var model:VNCoreMLModel? = nil
    var userDefaults: UserDefaults = .standard
    var correct = 0
    var total = 0
    
    var num: Int? = Optional(2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        initModel()
        getUserDefaults()
        setTapRecognizers()
        disableButtons()
        predict_image(isStartup: true)
        setStatusValue()
        
//        print("navigationController - \(parentVC?.navigationController?.viewControllers)")
//
//        if var cntrlers = navigationController?.viewControllers
//        {
//            navigationController?.setViewControllers([self], animated: true)
//        }
        
    }
    
    func setStatusValue()
    {
        if total != 0
        {
            let label = "Correct: \(correct), Total: \(total) \nI'm \(correct * 100/total) % smarter than you!"
            
            percentageLabel.text = label
        }
        percentageLabel.sizeToFit()
        
    }
    
    func setTapRecognizers()
    {
        let albumGestureRec = UITapGestureRecognizer(target: self, action: #selector(launchPhotoAlbum))
        launchAlbumImg.isUserInteractionEnabled = true
        launchAlbumImg.addGestureRecognizer(albumGestureRec)
        
        let camGestureRec = UITapGestureRecognizer(target: self, action: #selector(launchCamera(_:)))
        launchCameraImg.isUserInteractionEnabled = true
        launchCameraImg.addGestureRecognizer(camGestureRec)
    }
    
    func disableButtons()
    {
        thumbsUpButton.isEnabled = false
        thumbsDownButton.isEnabled = false
    }
    
    func enableButtons()
    {
        thumbsUpButton.isEnabled = true
        thumbsDownButton.isEnabled = true
    }
    
    func setUserDefaults()
    {
        print("setting user defaults")
        userDefaults.set(correct, forKey: "correct")
        userDefaults.set(total, forKey: "total")
        
    }
    
    func getUserDefaults()
    {
        correct = userDefaults.integer(forKey: "correct")
        total = userDefaults.integer(forKey: "total")
    }
    
    func initModel()
    {
        do
        {
            model = try VNCoreMLModel(for: Resnet50().model)
            print(model)
        }
        catch
        {
            print("Error caught")
        }
    }
    
    @objc func launchCamera(_ sender: Any) {
      
        let imgPickerCtrlr = UIImagePickerController()
        imgPickerCtrlr.sourceType = .camera
        imgPickerCtrlr.allowsEditing = true
        imgPickerCtrlr.delegate = self

        present(imgPickerCtrlr, animated: true)
    }
    
  
    
    @objc func launchPhotoAlbum() {
        
        let imgPickerCtrlr = UIImagePickerController()
        imgPickerCtrlr.sourceType = .savedPhotosAlbum
        imgPickerCtrlr.allowsEditing = true
        imgPickerCtrlr.delegate = self

        present(imgPickerCtrlr, animated: true)

    }
    
    
    @IBAction func gotPrediction(_ sender: Any) {
        
        correct += 1
        
        displayAlertCtrler(title:"Yep!", message: "Always told you I'm awesome! 😎")
        setUserDefaults()
        disableButtons()
        setStatusValue()
    }
    
    @IBAction func missedPrediction(_ sender: Any) {
        
        displayAlertCtrler(title:"Ow!", message: "Can't believe I missed that! 😞")
        
        setUserDefaults()
        disableButtons()
        setStatusValue()
    }
    
    func displayAlertCtrler(title: String, message: String)
    {
        let alertCtrler = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertCtrler.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        present(alertCtrler, animated: true, completion:  nil)
    }
    
    func predict_image(isStartup: Bool)
    {
        let request = VNCoreMLRequest(model: model!, completionHandler: prediction_handler)
        let vnHandler = VNImageRequestHandler(cgImage: (pickedImgView.image?.cgImage!)!)
        
        try? vnHandler.perform([request])
        
        if !isStartup
        {
            incrementTotal()
        }
        
    }
    
    func incrementTotal()
    {
        total += 1
    }
    
    func prediction_handler(vnRequest: VNRequest, err: Error?)
    {
        guard let results = vnRequest.results as? [VNClassificationObservation]
        else
        {
            print("Err")
            return
        }
        
        let label = "A \(results[0].identifier) or a \(results[1].identifier)!"
        
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.hyphenationFactor = 0.2
//        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
//        let attrString = NSMutableAttributedString(string: label, attributes: [NSMutableAttributedString.Key.paragraphStyle: paragraphStyle])
        
        predictionLabel.text = label
        
//        predictionLabel.isHidden = false
//        tellMeLabel.isHidden = false
//        thumbsUpButton.isHidden = false
//        thumbsDownButton.isHidden = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage
       else {
//           print("")
           return
        }
        
        pickedImgView.image = image
        predict_image(isStartup: false)
        enableButtons()
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        
    }


}

