//
//  SCTDiscoveredBLETableViewCell.swift
//  Heart Rate
//
//  Created by 刘爽 on 2017/3/1.
//  Copyright © 2017年 智裳科技. All rights reserved.
//

import UIKit

class SCTDiscoveredBLETableViewCell: UITableViewCell {

    let label_Name = UILabel()
    
    let label_MacAddr = UILabel()
    
    let label_Distance = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(label_Name)
        self.contentView.addSubview(label_MacAddr)
        self.contentView.addSubview(label_Distance)
        
        label_Name.whc_Top(5).whc_Left(10).whc_Width(150).whc_Height(25)
        label_MacAddr.whc_BaseLine(5).whc_Left(10).whc_Width(self.frame.size.width - 50).whc_Height(15)
        label_Distance.whc_Width(200).whc_Right(20).whc_Top(10).whc_Height(15)
        
        label_Name.font = UIFont.systemFont(ofSize: 20)
        label_Name.textAlignment = .left
        label_Name.textColor = UIColor.black
        
        label_MacAddr.font = UIFont.systemFont(ofSize: 15)
        label_MacAddr.textAlignment = .left
        label_MacAddr.textColor = UIColor.brown
        
        label_Distance.font = UIFont.systemFont(ofSize: 15)
        label_Distance.textAlignment = .right
        label_Distance.textColor = UIColor.blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
