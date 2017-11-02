//
//  LotteryCell.swift
//  hala
//
//  Created by MAC on 01/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit

class LotteryCell: UICollectionViewCell {
    
    let kCardBackTag : Int = 0
    let kCardFrontTag : Int = 1
    var centerPoint : CGPoint!
    var cardViews :(frontView : UIImageView , backView : UIImageView)?
    var bringjalImage : UIImage!
    var imgViewFront : UIImageView!
    var imgViewBack : UIImageView!
    var selfSize : CGSize!
    var yellowImage : UIImage!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgViewFront = self.createCardViewWithImage(imageName: "lottery", tag: self.kCardFrontTag)
        imgViewFront.contentMode = .scaleAspectFit
        imgViewBack = self.createCardViewWithImage(imageName: "lottery", tag: self.kCardBackTag)
        imgViewBack.contentMode = .scaleAspectFit
        cardViews = (frontView : imgViewFront , backView : imgViewBack)
        contentView.addSubview(imgViewBack)
        
    }
    
    private func createCardViewWithImage(imageName : String , tag : Int) -> UIImageView{
        let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let sizeWidth : CGFloat = (app.window!.frame.size.width/3) - 20
        selfSize = CGSize(width : sizeWidth, height : sizeWidth)
        let newCardImageView = UIImageView(frame : CGRect(x: 0 , y : 0 , width : sizeWidth , height : sizeWidth))
        centerPoint = CGPoint(x: sizeWidth / 2  , y : sizeWidth / 2)
        
        yellowImage = UIImage(color: GlobalConstants.DEFAULT_SELECTED_YELLOW, size: CGSize(width: sizeWidth, height: sizeWidth))
        
        if tag == 1{
            bringjalImage = UIImage(color: GlobalConstants.DEFAULT_SELECTED_YELLOW, size: CGSize(width: sizeWidth, height: sizeWidth))
            newCardImageView.image = bringjalImage
            newCardImageView.layer.cornerRadius = 10
            newCardImageView.clipsToBounds = true
            
        }else{
            newCardImageView.image = UIImage(named : imageName)
        }
        
        
        newCardImageView.tag = tag
        
        return newCardImageView
    }
    
    func flipCell(text : String){
        
        
        let image : UIImage =  self.textToImage(drawText: text as NSString , inImage: yellowImage)
        
        if imgViewBack.superview != nil{
            imgViewFront.image = image
            cardViews = (frontView : imgViewFront , backView : imgViewBack)
        }else{
            cardViews = (frontView : imgViewBack , backView : imgViewFront)
        }
        
        let transitionOptions = UIViewAnimationOptions.transitionFlipFromLeft
        
        UIView.transition(with: self.contentView, duration: 0.5, options: transitionOptions, animations: {
            
            self.cardViews?.backView.removeFromSuperview()
            self.contentView.addSubview((self.cardViews?.frontView)!)
            
        }, completion: nil)
        
    }
    
    
    func textToImage(drawText text: NSString, inImage image: UIImage) -> UIImage {
        //draw image first
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        //text attributes
        let font = UIFont(name: "Avenir", size: 45)!
        let text_style=NSMutableParagraphStyle()
        text_style.alignment=NSTextAlignment.center
        let text_color=UIColor.white
        
        
        
        let attributes=[NSAttributedStringKey.font:font, NSAttributedStringKey.paragraphStyle:text_style, NSAttributedStringKey.foregroundColor:text_color]
        
        
        
        
        
        //vertically center (depending on font)
        let text_h=font.lineHeight
        let text_y=(image.size.height-text_h)/2
        let text_rect=CGRect(x: 0, y: text_y, width: image.size.width, height: text_h)
        text.draw(in: text_rect.integral, withAttributes: attributes)
        let result=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result!
    }
    
    
    
    
    
    func textToImage(drawText: NSString, inImage: UIImage, atPoint: CGPoint) -> UIImage{
        
        // Setup the font specific variables
        let textColor = GlobalConstants.DEFAULT_COLOR_BRINJAL
        let textFont = UIFont(name: "Avenir", size: 45)!
        
        // Setup the image context using the passed image
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(inImage.size, false, scale)
        
        // Setup the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSAttributedStringKey.font: textFont,
            NSAttributedStringKey.foregroundColor: textColor,
            ] as [NSAttributedStringKey : Any]
        
        // Put the image into a rectangle as large as the original image
        inImage.draw(in: CGRect(x : 0, y : 0, width : inImage.size.width,height : inImage.size.height))
        
        // Create a point within the space that is as bit as the image
        let rect = CGRect(x : atPoint.x,y : atPoint.y,width: inImage.size.width,height : inImage.size.height)
        
        // Draw the text into an image
        drawText.draw(in: rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //Pass the image back up to the caller
        return newImage!
        
    }
    
    
    
    
    
    
    
    
}
extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
