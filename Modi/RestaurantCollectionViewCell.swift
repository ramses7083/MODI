//
//  RestaurantCollectionViewCell.swift
//  Modi
//
//  Created by Ramses Miramontes Meza on 06/05/15.
//  Copyright (c) 2015 RASOFT. All rights reserved.
//

import UIKit

class RestaurantCollectionViewCell: UICollectionViewCell {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var ModiPosImageView: UIImageView!
    @IBOutlet weak var RestaurantLabel: UILabel!
    @IBOutlet weak var RestaurantImageView: UIImageView!
    //var textLabel: UILabel = UILabel()
    //var imageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        /*imageView = UIImageView(frame: CGRect(x: 0, y: 16, width: frame.size.width, height: frame.size.height*2/3))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        contentView.addSubview(imageView)
        
        let textFrame = CGRect(x: 0, y: 32, width: frame.size.width, height: frame.size.height/3)
        textLabel = UILabel(frame: textFrame)
        textLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        textLabel.textAlignment = .Center
        contentView.addSubview(textLabel)*/
    }

}
