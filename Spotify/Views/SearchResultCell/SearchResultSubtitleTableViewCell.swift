//
//  SearchResultSubtitleTableViewCell.swift
//  Spotify
//
//  Created by Tarık Nasuhoğlu on 26.10.2021.
//

import UIKit
import SDWebImage

class SearchResultSubtitleTableViewCell: UITableViewCell {
    static let identifier = "SearchResultSubtitleTableViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    private let subTitlelabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(subTitlelabel)
        contentView.addSubview(iconImageView)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = contentView.height - 10
        
        iconImageView.frame = CGRect(
            x: 10,
            y: 5,
            width: imageSize,
            height: imageSize
        )
        let labelHeight = contentView.height/2
        let labelWidth = contentView.width-iconImageView.right-20
        label.frame = CGRect(
            x: iconImageView.right + 10,
            y: 0,
            width: labelWidth,
            height: labelHeight
        )
        subTitlelabel.frame = CGRect(
            x: iconImageView.right + 10,
            y: label.bottom,
            width: labelWidth,
            height: labelHeight
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
        subTitlelabel.text = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(with model:SearchResultSubtitleTableViewCellViewModel){
        label.text = model.title
        subTitlelabel.text = model.subtitle
        iconImageView.sd_setImage(with: model.artworkURL, placeholderImage: UIImage(systemName:"photo"), completed: nil)
    }
}
