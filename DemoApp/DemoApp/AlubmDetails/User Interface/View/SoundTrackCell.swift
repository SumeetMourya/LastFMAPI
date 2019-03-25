//
//  SoundTrackCell.swift
//  DemoApp
//
//  Created by sumeet mourya on 25/03/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import Foundation
import AlamofireImage

class SoundTrackCell: UITableViewCell {
    
    static let identifier = "SoundTrackCellID"
    
    @IBOutlet var shadowContainer: UIView!
    @IBOutlet var soundTrack: UILabel!
    @IBOutlet var soundTrackDuration: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        TableCellUtils.createShadow(cardLayer: layer, contentLayer: shadowContainer.layer, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 0.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindDataToUI(data: AlbumTrackItem) {
        
        soundTrack.text = data.trackName
        if let duration = data.trackDuration, let durationInInt = Int(duration), durationInInt > 0 {
            soundTrackDuration.text = SoundTrackCell.stringFromTimeInterval(TimeInterval(durationInInt))
        }
    }

    
    static func stringFromTimeInterval(_ timeInterval: TimeInterval, alwaysShowHours: Bool = false) -> String {
        
        let ti = Int(timeInterval)
        let seconds = ti % 60 as NSNumber
        let minutes = (ti / 60) % 60 as NSNumber
        let hours = (ti / 3600) as NSNumber
        
        let formatter: NumberFormatter = NumberFormatter.init()
        formatter.maximumFractionDigits = 0
        formatter.minimumIntegerDigits = 2
        
        if (alwaysShowHours || hours.intValue > 0) {
            return "\(formatter.string(from: hours)!):\(formatter.string(from: minutes)!):\(formatter.string(from: seconds)!)"
        } else {
            return "\(formatter.string(from: minutes)!):\(formatter.string(from: seconds)!)"
        }
    }
}

