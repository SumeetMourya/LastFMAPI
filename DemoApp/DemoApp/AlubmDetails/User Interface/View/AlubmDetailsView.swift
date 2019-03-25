//
//  AlubmDetailsView.swift
//  Demo
//
//  Created by sumeet mourya on 03/23/2019.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

class AlubmDetailsViewController: UIViewController, AlubmDetailsViewProtocol {
    
    var presenter: AlubmDetailsPresenterProtocol?
//    var listOfTracks: [AlbumTrackItem] = [AlbumTrackItem]()
    var albumInformationData: AlbumInfoItem?
    
    @IBOutlet var btnStoreDataToggle: UIButton!
    @IBOutlet var actionButtonParentView: UIView!
    @IBOutlet var imgAlbumCover: UIImageView!
    @IBOutlet var lblArtistName: UILabel!
    @IBOutlet var lblAlbumName: UILabel!
    @IBOutlet var lblErrorText: UILabel!
    @IBOutlet var tblvTrackList: UITableView!
    @IBOutlet var tracksIsEmpty: UILabel!
    @IBOutlet var layoutTrackListHeight: NSLayoutConstraint!
    @IBOutlet var layoutPhoneXBottomHeight: NSLayoutConstraint!
    
    @IBAction func actionOnToggleForStoringData(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblvTrackList.tableFooterView = UIView(frame: .zero)
        tblvTrackList.rowHeight = UITableView.automaticDimension
        tblvTrackList.estimatedRowHeight = 40
        tblvTrackList.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 20, right: 0)
        tblvTrackList.delaysContentTouches = false
        
        self.title = self.presenter?.getAlbumName()
        self.lblErrorText.text = "Loading..."
        
        self.lblAlbumName.text = self.presenter?.getAlbumName()
        self.lblArtistName.text = self.presenter?.getArtistName()
            
        self.presenter?.getAlbumInformationWithAPI()
        
        layoutPhoneXBottomHeight.constant = (UIDevice.isHavingCurved ? 34 : 0)
        
        actionButtonParentView.layer.shadowColor = UIColor.darkGray.cgColor;
        actionButtonParentView.layer.masksToBounds = false;
        actionButtonParentView.layer.shadowOffset = CGSize(width: 0, height: -3)
        actionButtonParentView.layer.shadowRadius = 3
        actionButtonParentView.layer.shadowOpacity = 0.25
        actionButtonParentView.layer.shouldRasterize = true
        actionButtonParentView.layer.rasterizationScale = UIScreen.main.scale

        btnStoreDataToggle.isHidden = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func updateToggleButton() {
        
        if let data = self.albumInformationData {
            
            btnStoreDataToggle.isHidden = false
            if (data.albumSaved) {
                btnStoreDataToggle.setTitle("Delete", for: .normal)
                btnStoreDataToggle.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            } else {
                btnStoreDataToggle.setTitle("Add", for: .normal)
                btnStoreDataToggle.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            }
        }
    }
    
    
    
    //MARK: AlubmDetailsViewProtocol Methods
    
    func errorInLoadingDataWith(error: Error?, errorCode: ApiStatusType) {
        
        var alertMSG: String = ""
        
        switch errorCode {
        case .apiSucceed:
            alertMSG = ""
            break
            
        case .netWorkIssue:
            alertMSG = "Please check your network connectivity."
            break
            
        case .apiIssue:
            alertMSG = "Server issue"
            break
            
        case .apiParsingIssue:
            alertMSG = "Server data parsing issue"
            break
            
        case .apiEncodingIssue:
            alertMSG = "Server decoding issue"
            break
            
        case .none:
            break
            
        default:
            break
        }
        
        print("alertMSG: \(alertMSG)")
        
        DispatchQueue.main.async() {
            self.lblErrorText.text = alertMSG
            self.tblvTrackList.isHidden = true
            self.lblErrorText.isHidden = false
        }
        
    }
    
    func updateAlbumInfoDetailView(albumInforData: AlbumInfoItem) {
        
        DispatchQueue.main.async() {
            
            self.tblvTrackList.isHidden = false
            self.lblErrorText.isHidden = true
            
            if let urlStringValue = albumInforData.albumCoverLargeImageURL, let urlObject = URL(string: urlStringValue) {
                self.imgAlbumCover.af_setImage(withURL: urlObject, placeholderImage: UIImage(named: "profileicon")!)
            }
            self.albumInformationData = albumInforData
            self.tblvTrackList.reloadData()
            self.tracksIsEmpty.isHidden = (albumInforData.tracks.count > 0) ? true : false
            self.layoutTrackListHeight.constant = self.tblvTrackList.contentSize.height
            
            self.updateToggleButton()
        }
    }
    
    func hideActivityIndicatorWithError(title: String?, subtitle: String?) {
        self.lblErrorText.text = title
        self.tblvTrackList.isHidden = true
        self.lblErrorText.isHidden = false
    }

}

// MARK: UITableViewDelegate methods

extension AlubmDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

// MARK: UITableViewDataSource methods

extension AlubmDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let listOfTracks = self.albumInformationData?.tracks else {
            return 0
        }
        return listOfTracks.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:SoundTrackCell? = tableView.dequeueReusableCell(withIdentifier: SoundTrackCell.identifier) as? SoundTrackCell
        
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: SoundTrackCell.identifier) as? SoundTrackCell
        }
        cell?.selectionStyle = .none
        cell?.contentView.backgroundColor = UIColor.clear
        cell?.backgroundColor = UIColor.clear
        
        if let listOfTracks = self.albumInformationData?.tracks {
            cell?.bindDataToUI(data: listOfTracks[indexPath.row])
        }
        
        return cell!
    }
   
    
}
