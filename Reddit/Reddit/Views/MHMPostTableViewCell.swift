//
//  MHMPostTableViewCell.swift
//  Reddit
//
//  Created by Michael Moore on 8/20/19.
//  Copyright © 2019 Michael Moore. All rights reserved.
//

import UIKit

class MHMPostTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var upsCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    var post: MHMPost? {
        didSet {
            updateViews()
        }
    }
    
    var thumbnail: UIImage? {
        didSet{
            updateViews()
        }
    }

    func updateViews() {
        guard let post = post else { return }
        titleLabel.text = post.title
        upsCountLabel.text = "\(post.ups) 👍"
        commentCountLabel.text = "\(post.commentCount) 💬"
        thumbnailImageView.image = thumbnail
    }
}
