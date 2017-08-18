//
//  cellModel.swift
//  WiredArticlesApp
//
//  Created by Onur Can on 14.08.2017.
//  Copyright © 2017 Olmaditekrar. All rights reserved.
//

import UIKit

class cellModel: UITableViewCell {

    @IBOutlet weak var articleName: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
