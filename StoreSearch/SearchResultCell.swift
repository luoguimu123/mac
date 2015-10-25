//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by lgm on 15/10/25.
//  Copyright © 2015年 lgm. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

    @IBOutlet weak var nameLable:UILabel!;
    
    @IBOutlet weak var artistNameLabel:UILabel!;
    
    @IBOutlet weak var artworkImageView:UIImageView!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let selectedView = UIView(frame: CGRect.zero);
        selectedView.backgroundColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 1);
        selectedBackgroundView = selectedView;
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
