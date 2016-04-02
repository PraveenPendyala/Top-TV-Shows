//
//  XMLCell.swift
//  XMLParsing
//
//  Created by Naga Praveen Kumar Pendyala on 2/20/16.
//  Copyright (c) 2016 Naga Praveen Kumar Pendyala. All rights reserved.
//

import UIKit

class XMLCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    @IBOutlet weak var episodeImageView: UIImageView!
    
    //adding values to the labels in the cell
    
    var XMLentry: Entry!{
        
        didSet{
            titleLabel.text = XMLentry.title
            summaryLabel.text = XMLentry.summary
        }
    }
    
    
}
