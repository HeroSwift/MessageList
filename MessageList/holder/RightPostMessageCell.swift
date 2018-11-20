
import UIKit

class RightPostMessageCell: PostMessageCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func create(configuration: MessageListConfiguration) {
        
        super.create(configuration: configuration)
        
        bubbleView.image = configuration.rightPostMessageBubbleImage
        
        titleView.font = configuration.rightPostMessageTitleTextFont
        titleView.textColor = configuration.rightPostMessageTitleTextColor
        
        descView.font = configuration.rightPostMessageDescTextFont
        descView.textColor = configuration.rightPostMessageDescTextColor
        
        dividerView.backgroundColor = configuration.rightPostMessageDividerColor
        
        brandView.font = configuration.rightPostMessageBrandTextFont
        brandView.textColor = configuration.rightPostMessageBrandTextColor
        
        contentView.addConstraints([
            
            NSLayoutConstraint(item: timeView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: timeView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: avatarView, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -configuration.messagePaddingHorizontal),
            NSLayoutConstraint(item: avatarView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: configuration.userAvatarWidth),
            NSLayoutConstraint(item: avatarView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.userAvatarHeight),
            
            NSLayoutConstraint(item: bubbleView, attribute: .right, relatedBy: .equal, toItem: avatarView, attribute: .left, multiplier: 1, constant: -configuration.rightPostMessageMarginRight),
            NSLayoutConstraint(item: bubbleView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -configuration.messagePaddingVertical),
            NSLayoutConstraint(item: bubbleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: configuration.rightPostMessageBubbleWidth),
            
            NSLayoutConstraint(item: titleView, attribute: .top, relatedBy: .equal, toItem: bubbleView, attribute: .top, multiplier: 1, constant: configuration.rightPostMessageTitleMarginTop),
            NSLayoutConstraint(item: titleView, attribute: .left, relatedBy: .equal, toItem: bubbleView, attribute: .left, multiplier: 1, constant: configuration.rightPostMessageTitleMarginLeft),
            NSLayoutConstraint(item: titleView, attribute: .right, relatedBy: .equal, toItem: bubbleView, attribute: .right, multiplier: 1, constant: -configuration.rightPostMessageTitleMarginRight),
            
            NSLayoutConstraint(item: thumbnailView, attribute: .top, relatedBy: .equal, toItem: titleView, attribute: .bottom, multiplier: 1, constant: configuration.rightPostMessageThumbnailMarginTop),
            NSLayoutConstraint(item: thumbnailView, attribute: .right, relatedBy: .equal, toItem: bubbleView, attribute: .right, multiplier: 1, constant: -configuration.rightPostMessageThumbnailMarginRight),
            NSLayoutConstraint(item: thumbnailView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: configuration.rightPostMessageThumbnailWidth),
            NSLayoutConstraint(item: thumbnailView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.rightPostMessageThumbnailHeight),
            
            NSLayoutConstraint(item: descView, attribute: .top, relatedBy: .equal, toItem: titleView, attribute: .bottom, multiplier: 1, constant: configuration.rightPostMessageDescMarginTop),
            NSLayoutConstraint(item: descView, attribute: .left, relatedBy: .equal, toItem: bubbleView, attribute: .left, multiplier: 1, constant: configuration.rightPostMessageDescMarginLeft),
            NSLayoutConstraint(item: descView, attribute: .right, relatedBy: .equal, toItem: thumbnailView, attribute: .left, multiplier: 1, constant: -configuration.rightPostMessageThumbnailMarginLeft),
            
            NSLayoutConstraint(item: dividerView, attribute: .top, relatedBy: .equal, toItem: thumbnailView, attribute: .bottom, multiplier: 1, constant: configuration.rightPostMessageDividerMarginTop),
            NSLayoutConstraint(item: dividerView, attribute: .left, relatedBy: .equal, toItem: bubbleView, attribute: .left, multiplier: 1, constant: configuration.rightPostMessageDividerMarginLeft),
            NSLayoutConstraint(item: dividerView, attribute: .right, relatedBy: .equal, toItem: bubbleView, attribute: .right, multiplier: 1, constant: -configuration.rightPostMessageDividerMarginRight),
            NSLayoutConstraint(item: dividerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.postMessageDividerWidth),
            
            NSLayoutConstraint(item: brandView, attribute: .left, relatedBy: .equal, toItem: bubbleView, attribute: .left, multiplier: 1, constant: configuration.rightPostMessageBrandMarginLeft),
            NSLayoutConstraint(item: brandView, attribute: .top, relatedBy: .equal, toItem: dividerView, attribute: .top, multiplier: 1, constant: configuration.rightPostMessageBrandMarginVertical),
            NSLayoutConstraint(item: brandView, attribute: .bottom, relatedBy: .equal, toItem: bubbleView, attribute: .bottom, multiplier: 1, constant: -configuration.rightPostMessageBrandMarginVertical),
            
            NSLayoutConstraint(item: spinnerView, attribute: .right, relatedBy: .equal, toItem: bubbleView, attribute: .left, multiplier: 1, constant: -configuration.rightStatusViewMarginRight),
            NSLayoutConstraint(item: spinnerView, attribute: .bottom, relatedBy: .equal, toItem: bubbleView, attribute: .bottom, multiplier: 1, constant: -configuration.rightStatusViewMarginBottom),
            
            NSLayoutConstraint(item: failureView, attribute: .right, relatedBy: .equal, toItem: bubbleView, attribute: .left, multiplier: 1, constant: -configuration.rightStatusViewMarginRight),
            NSLayoutConstraint(item: failureView, attribute: .bottom, relatedBy: .equal, toItem: bubbleView, attribute: .bottom, multiplier: 1, constant: -configuration.rightStatusViewMarginBottom),
            
        ])
        
        if configuration.rightUserNameVisible {
            
            nameView.font = configuration.rightUserNameTextFont
            nameView.textColor = configuration.rightUserNameTextColor
            nameView.textAlignment = .right
            
            contentView.addSubview(nameView)
            addClickHandler(view: nameView, selector: #selector(onUserNameClick))
            
            contentView.addConstraints([
                
                NSLayoutConstraint(item: nameView, attribute: .top, relatedBy: .equal, toItem: avatarView, attribute: .top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: nameView, attribute: .right, relatedBy: .equal, toItem: avatarView, attribute: .left, multiplier: 1, constant: -configuration.rightUserNameMarginRight),
                
                NSLayoutConstraint(item: bubbleView, attribute: .top, relatedBy: .equal, toItem: nameView, attribute: .bottom, multiplier: 1, constant: configuration.leftUserNameMarginBottom),
                
            ])
            
        }
        else {
            contentView.addConstraints([
                
                NSLayoutConstraint(item: bubbleView, attribute: .top, relatedBy: .equal, toItem: avatarView, attribute: .top, multiplier: 1, constant: 0),
                
            ])
        }
        
    }
    
}