//
//  DisplayNewsView.swift
//  News Today
//
//  Created by Subendran on 25/07/21.
//  Copyright © 2021 Subendran. All rights reserved.
//

import UIKit

class DisplayNewsView: UIViewController {
    @IBOutlet weak var articleImageView: UIImageView!
    
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var discriptionLabel: UILabel!
    var displayNewsViewModel: DisplayNewsViewModel?
    
    @IBOutlet weak var textViewLink: UITextView!
    
    // MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.labelDate.text = self.displayNewsViewModel?.getDateInfo()
        self.discriptionLabel.text  = self.displayNewsViewModel?.getDiscription()
        let attributedString = NSMutableAttributedString(string: "For more details Click Here")
        let urlLink = URL(string: self.displayNewsViewModel?.getUrl() ?? "")
        
        // Set the 'click here' substring to be the link
        attributedString.setAttributes([.link: urlLink], range: NSMakeRange(5, 10))
        
        self.textViewLink.attributedText = attributedString
        self.textViewLink.isUserInteractionEnabled = true
        self.textViewLink.isEditable = false
        
        // Set how links should appear: blue and underlined
        self.textViewLink.linkTextAttributes = [
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let url = URL(string: self.displayNewsViewModel?.getImageURL() ?? "")!
        
        DispatchQueue.global().async {
            // Fetch Image Data
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    // Create Image and Update Image View
                    self.articleImageView.image = UIImage(data: data)
                }
            }
        }
    }
    
    @IBAction func actionDone(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        
    }
}
