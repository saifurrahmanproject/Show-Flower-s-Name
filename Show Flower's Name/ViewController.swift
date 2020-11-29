//
//  ViewController.swift
//  Show Flower's Name
//
//  Created by Tonoy Rahman on 2020-11-12.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
   
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage)  else {
                
                fatalError("we could not conver UIImage into CIImage")
            }
            
            detect(image: ciimage )
        }
        
        imagePicker.dismiss(animated: true , completion: nil)
        
    }
    
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: FlowersMLModel().model)   else {
            
            fatalError("Loading CoreML Model failed.")
        }
        
        let request = VNCoreMLRequest(model:  model) { (request, error) in
            
            guard  let results = request.results as? [VNClassificationObservation] else {
                
                fatalError("Model failed to process image")
            }
            
            if let firstResult = results.first {
                
                if firstResult.identifier.contains("Jasmine") {
                    self.navigationItem.title = "Flower Name: Jasmine"
                }
                else if firstResult.identifier.contains("Lotus") {
                    self.navigationItem.title = "Flower Name: Lotus"
                }
                else if firstResult.identifier.contains("Marigold") {
                    self.navigationItem.title = "Flower Name: Marigold"
                }
                else if firstResult.identifier.contains("Orchid") {
                    self.navigationItem.title = "Flower Name: Orchid"
                }
                else if firstResult.identifier.contains("Rose") {
                    self.navigationItem.title = "Flower Name: Rose"
                }
                else if firstResult.identifier.contains("Sunflower") {
                    self.navigationItem.title = "Flower Name: Sunflower"
                }
                else if firstResult.identifier.contains("Tulip") {
                    self.navigationItem.title = "Flower Name: Tulip"
                }
             
                
                
                else {
                    
                    self.navigationItem.title = "Sorry it's not in list of food items we will add soon"
                }
            }
            
            
        }
        
        
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
           try handler.perform([request])
        }
        catch {
            
            print(error)
        }
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
}


