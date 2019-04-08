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
    
    private var albumInformationData: AlbumInfoItem?
    private var rippelLayer:CAShapeLayer!

    @IBOutlet var btnStoreDataToggle: AnimatedColoringButton!
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
        
        guard let dataNeedToChange = albumInformationData else {
            return
        }
        if (sender.tag == 1000) {
            if self.presenter?.deleteAlbumData(albumInforData: dataNeedToChange) ?? false {
                albumInformationData?.updateAlbumSaveStatus(value: false)
            } else {
                albumInformationData?.updateAlbumSaveStatus(value: true)
            }
        } else {
            if self.presenter?.saveAlbumData(albumInforData: dataNeedToChange) ?? false {
                albumInformationData?.updateAlbumSaveStatus(value: true)
            } else {
                albumInformationData?.updateAlbumSaveStatus(value: false)
            }
        }
        
        NotificationCenter.default.post(name: CoreDataManager.AlbumStoringModifiedNotification, object: nil)
        
        self.updateToggleButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblvTrackList.tableFooterView = UIView(frame: .zero)
        tblvTrackList.rowHeight = UITableView.automaticDimension
        tblvTrackList.estimatedRowHeight = 40
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
        
        self.layoutTrackListHeight.constant = self.tblvTrackList.contentSize.height
    }
    
    func updateToggleButton() {
        
        if let data = self.albumInformationData {
            
            btnStoreDataToggle.isHidden = false
            
            btnStoreDataToggle.isSelected = data.albumSaved
            btnStoreDataToggle.setTitle(btnStoreDataToggle.isSelected ? "Delete" : "Add", for: .normal)
//            btnStoreDataToggle.backgroundColor = btnStoreDataToggle.isSelected ? #colorLiteral(red: 0.9058823529, green: 0.2980392157, blue: 0.2352941176, alpha: 1) : #colorLiteral(red: 0.1803921569, green: 0.8, blue: 0.4431372549, alpha: 1)
            btnStoreDataToggle.tag =  btnStoreDataToggle.isSelected ? 1000 : 2000
            btnStoreDataToggle.setButtonColor()
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
                self.imgAlbumCover.af_setImage(withURL: urlObject, placeholderImage: UIImage(named: "imagePlaceHolderBig")!)
            } else {
                self.imgAlbumCover.image = UIImage(named: "imagePlaceHolderBig")!
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



class AnimatedColoringButton: UIButton {
    
    @IBInspectable public var rippeleRadius: CGFloat = 0
    var setRippeleRadius: CGFloat? = 0 {
        didSet {
            rippeleRadius = setRippeleRadius!
        }
    }
    
    @IBInspectable public var rippeleTrueColor: UIColor = UIColor.black.withAlphaComponent(0.3)
    var setRippeleTrueColor: UIColor? {
        didSet {
            self.rippeleTrueColor = setRippeleTrueColor!
        }
    }

    @IBInspectable public var rippeleFalseColor: UIColor = UIColor.black.withAlphaComponent(0.3)
    var setRippeleFalseColor: UIColor? {
        didSet {
            self.rippeleFalseColor = setRippeleFalseColor!
        }
    }

    
    //create a new layer to render the various circles
    var pathLayer:CAShapeLayer!
    var rippelLayer:CAShapeLayer!
    let animationDuration = 0.8
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    //common set up code
    func setup(){
        
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        
        self.pathLayer = CAShapeLayer()
        self.pathLayer.path = self.currentInnerPath().cgPath
        self.pathLayer.strokeColor = nil
        self.layer.addSublayer(self.pathLayer)
        
        self.rippelLayer = CAShapeLayer()
        self.rippelLayer.path = UIBezierPath(roundedRect: CGRect(x:  (self.frame.size.width) / 2, y: (self.frame.size.height) / 2, width: 0, height: 0), cornerRadius: 0).cgPath
        self.rippelLayer.strokeColor = nil
        self.rippelLayer.fillColor = UIColor.init(white: 1, alpha: 0.25).cgColor
        self.layer.addSublayer(self.rippelLayer)
        
    }
    
    func setButtonColor() {
        //set the color for the inner shape
        self.pathLayer.fillColor = self.isSelected ? self.rippeleFalseColor.cgColor : self.rippeleTrueColor.cgColor
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        //add out target for event handling
        self.addTarget(self, action: #selector(touchUpInside), for: UIControl.Event.touchUpInside)
        self.addTarget(self, action: #selector(touchDown(sender:forEvent:)), for: UIControl.Event.touchDown)

    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    @objc func touchUpInside(sender:UIButton) {
        
        self.isEnabled = false

        //Create the animation to restore the color of the button
        let colorChange = CABasicAnimation(keyPath: "fillColor")
        colorChange.duration = animationDuration;
        colorChange.fromValue = !self.isSelected ? self.rippeleFalseColor.cgColor : self.rippeleTrueColor.cgColor
        colorChange.toValue = self.isSelected ? self.rippeleFalseColor.cgColor : self.rippeleTrueColor.cgColor
        
        //make sure that the color animation is not reverted once the animation is completed
        colorChange.fillMode = CAMediaTimingFillMode.forwards
        colorChange.isRemovedOnCompletion = false
        
        //indicate which animation timing function to use, in this case ease in and ease out
        colorChange.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

        colorChange.setValue("AddingFillingColor", forKey: "EnabledAnimationKey")
        colorChange.delegate = self

        //add the animation
        self.pathLayer.add(colorChange, forKey:"darkColor")
        
    }
    
    @objc func touchDown(sender:UIButton, forEvent event: UIEvent) {

        self.isSelected = !self.isSelected
        
        let touches: Set<UITouch>? = event.touches(for: sender)
        let touch: UITouch? = touches?.first
        let touchPoint: CGPoint? = touch?.location(in: sender)
        self.rippleAnimationOnButton(point: touchPoint!)
    }
    
    func currentInnerPath () -> UIBezierPath {
        
        //choose the correct inner path based on the control state
        var returnPath:UIBezierPath;
        
        if (self.isEnabled) {
            returnPath = self.backgraoundPath()
        } else {
            returnPath = self.centerPath()
        }
        
        return returnPath
    }
    
    func centerPath() -> UIBezierPath {
        return UIBezierPath(roundedRect: CGRect(x:(self.frame.size.width / 2.0) - 1.0, y:(self.frame.size.height / 2.0) - 1.0, width:1, height:1), cornerRadius: 1)
    }
    
    func backgraoundPath() -> UIBezierPath {
        
        let radius = CGFloat(sqrt(Double((self.frame.size.width * self.frame.size.width) + (self.frame.size.height * self.frame.size.height))))
        
        return UIBezierPath(roundedRect: CGRect(x:  (self.frame.size.width - radius) / 2, y: (self.frame.size.height - radius) / 2, width: radius, height: radius), cornerRadius: radius)
    }
    
    
    func rippleAnimationOnButton(point: CGPoint) {
        
        //change the inner shape to match the state
        let morph = CABasicAnimation(keyPath: "path")
        morph.duration = (animationDuration);
        morph.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        morph.fromValue = self.rippleInitialPath(point: point).cgPath
        morph.toValue = self.rippleFinalPath(point: point).cgPath
        
        //ensure the animation is not reverted once completed
        morph.fillMode = CAMediaTimingFillMode.forwards
        
        //add the animation
        self.rippelLayer.add(morph, forKey:"")
    }
    
    func rippleInitialPath (point: CGPoint) -> UIBezierPath {
        return UIBezierPath(arcCenter: point, radius: 1, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
    }
    
    func rippleFinalPath (point: CGPoint) -> UIBezierPath {
        return UIBezierPath(arcCenter: point, radius: self.rippeleRadius(point: point), startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
    }
    
    func rippeleRadius(point: CGPoint) -> CGFloat {
        
        if self.rippeleRadius != 0 {
            return self.rippeleRadius
        }
        
        var xComponent = self.frame.size.width / 2
        if (point.x > xComponent) {
            xComponent = point.x
        } else {
            xComponent = (self.frame.size.width - point.x)
        }
        
        var yComponent = self.frame.size.height / 2
        
        if (point.y > yComponent) {
            yComponent = point.y
        } else {
            yComponent = (self.frame.size.height - point.y)
        }
        
        return max(xComponent, yComponent)
    }
    
}


extension AnimatedColoringButton: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let value = anim.value(forKey: "EnabledAnimationKey") as? String, value == "AddingFillingColor" {
            self.isEnabled = true
        }
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        
        if let value = anim.value(forKey: "EnabledAnimationKey") as? String, value == "AddingFillingColor" {
        }
    }
    
}

