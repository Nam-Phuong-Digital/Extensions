//
//  DayComponentCell.swift
//  Cabinbook
//
//  Created by Dai Pham on 15/10/2023.
//  Copyright © 2023 Nam Phuong Digital. All rights reserved.
//

import UIKit

public class DayComponentCell: UICollectionViewCell {

    public struct Config: Hashable {
        let day:String?
        let iconTask:UIImage?
        let bgIcon:UIColor?
        let isHighligted:Bool
        let isSelected:Bool
        let isBold:Bool
        
        init(
            day: String?,
            iconTask: UIImage?,
            bgIcon:UIColor?,
            isHighligted: Bool = false,
            isSelected: Bool = false,
            isBold:Bool = true
        )
        {
            self.day = day
            self.iconTask = iconTask
            self.bgIcon = bgIcon
            self.isHighligted = isHighligted
            self.isSelected = isSelected
            self.isBold = isBold
        }
    }
    
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblIconTask: UIImageView!
    
    let bgNormalView:UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    let bgSelectedView:UIView = {
        let v = UIView()
        v.backgroundColor = .mainColor
        return v
    }()
    
    let bgHightlightView:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor("#C0C5CA")
        return v
    }()
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func show(
        config:Config
    ) {
        lblDay.text = config.day
        lblIconTask.image = config.iconTask?.resizeImageWith(newSize: CGSize(width: 10, height: 10)).tint(with: .white)
        lblIconTask.isHidden = config.iconTask == nil
        lblIconTask.backgroundColor = config.bgIcon
        lblDay.font = config.isBold ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 16)
        lblDay.textColor =
        if config.isSelected {
            UIColor.white
        } else if config.isHighligted {
            UIColor.white
        } else if !config.isBold {
            UIColor.borderColor
        }  else {
            UIColor.black
        }
        
        if #available(iOS 14, *) {
            var bg = UIBackgroundConfiguration.clear()
            bg.customView =
            if config.isSelected {
                bgSelectedView
            } else if config.isHighligted {
                bgHightlightView
            } else {
                bgNormalView
            }
            self.backgroundConfiguration = bg
        } else {
            backgroundView =
            if config.isSelected {
                bgSelectedView
            } else if config.isHighligted {
                bgHightlightView
            } else {
                bgNormalView
            }
        }
    }

    public override func prepareForReuse() {
        if #available(iOS 14, *) {
            var bg = UIBackgroundConfiguration.clear()
            bg.customView = bgNormalView
            self.backgroundConfiguration = bg
        } else {
            backgroundView = bgNormalView
        }
        lblIconTask.isHidden = true
        lblIconTask.backgroundColor = .white
        lblDay.textColor = .black
    }
}
