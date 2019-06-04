//
//  CustomCollectionReusableView.swift
//  Character Collector
//
//  Created by alien on 2019/6/3.
//  Copyright © 2019 Razeware, LLC. All rights reserved.
//

import UIKit

class CustomCollectionReusableView: UICollectionReusableView {
        
    @IBOutlet weak var headerBackgroundImageView: UIImageView!
    @IBOutlet weak var headerLogoImageView: UIImageView!
    @IBOutlet weak var headerBackgroundImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerLogoImageViewHeightConstraint: NSLayoutConstraint!
    
    var backgroundImageViewHeight: CGFloat = 0.0
    var logoImageViewHeight: CGFloat = 0.0
    var previousHeught: CGFloat = 0.0
    var isFirstTime = true
    var customAttribute: CustomHeaderViewLayoutAttributes?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundImageViewHeight = headerBackgroundImageView.bounds.height
        logoImageViewHeight = headerLogoImageView.bounds.height
        
        
//        headerLogoImageView.translatesAutoresizingMaskIntoConstraints = false
//        headerBackgroundImageView.heightAnchor.constraint(equalToConstant: 600).isActive = true
//        headerBackgroundImageViewHeightConstraint = headerBackgroundImageView.constraints.first
//        print(headerBackgroundImageViewHeightConstraint.constant)
        
        headerBackgroundImageView.contentMode = .scaleToFill
//        headerBackgroundImageView.frame = self.frame
        
        
        print("-----")
        print("back fram in awake \(headerBackgroundImageView.frame)")
        
//        self.headerBackgroundImageView.backgroundColor = .red
//        self.headerLogoImageView.backgroundColor = .orange
//        self.backgroundColor = .green
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isFirstTime {
//            self.headerBackgroundImageView.bounds = CGRect(x: 0, y: 0, width: 600, height: 600)
            isFirstTime.toggle()
        }
        
//        self.headerBackgroundImageView.bounds = CGRect(x: 0, y: 0, width: 600, height: 600)
//        self.headerBackgroundImageView.bounds.size = CGSize(width: 600, height: 600)
        if customAttribute != nil {
            let height = customAttribute!.frame.height
            if previousHeught != height {
                headerBackgroundImageViewHeightConstraint.constant = backgroundImageViewHeight - customAttribute!.deltaY
                headerLogoImageViewHeightConstraint.constant = logoImageViewHeight + customAttribute!.deltaY
                previousHeught = height
                //            self.headerBackgroundImageView.bounds = CGRect(x: 0, y: 0, width: 600, height: 600)
            }
        }
        
        
        print("......")
        print(self.frame)
        print(self.headerBackgroundImageView.frame)
        print(self.headerLogoImageView.frame)
    }
    
    
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        customAttribute = layoutAttributes as? CustomHeaderViewLayoutAttributes
        
//        let height = customAttribute.frame.height
//        if previousHeught != height {
//            headerBackgroundImageViewHeightConstraint.constant = backgroundImageViewHeight - customAttribute.deltaY
//            headerLogoImageViewHeightConstraint.constant = logoImageViewHeight + customAttribute.deltaY
//            previousHeught = height
////            self.headerBackgroundImageView.bounds = CGRect(x: 0, y: 0, width: 600, height: 600)
//        }
        
    }
}
