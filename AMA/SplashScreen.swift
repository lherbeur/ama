//
//  SplashScreen.swift
//  AMA
//
//  Created by Olawunmi GEORGE on 7/4/20.
//  Copyright © 2020 Olawunmi GEORGE. All rights reserved.
//

import UIKit

class SplashScreen: UIViewController {

    @IBOutlet weak var splashLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        customiseSplashLabel()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        do
        {
            sleep(1)
        }

        let destVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainScreen")

        navigationController?.popViewController(animated: true)
        navigationController?.pushViewController(destVC, animated: true)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender:Any?)
//    {
//        if (segue.identifier == "mainPageSegue")
//        {
//            if let destVC = segue.destination as? MainScreen
//            {
//                destVC.parentVC = self
//            }
//
//        }
//    }
    
    func customiseSplashLabel()
    {
        let font = UIFont.italicSystemFont(ofSize: 17.0)
        let attrString = NSAttributedString(string: "Ask Me Anything!", attributes: [NSAttributedString.Key.font: font])
        splashLabel.attributedText = attrString
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
