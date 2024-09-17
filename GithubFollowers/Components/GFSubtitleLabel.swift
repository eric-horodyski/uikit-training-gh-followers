//
//  GFSubtitleLabel.swift
//  GithubFollowers
//
//  Created by Eric Horodyski on 8/21/24.
//

import UIKit

class GFSubtitleLabel: UILabel {

	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	convenience init(fontSize: CGFloat) {
		self.init(frame: .zero)
		font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func configure() {
		textColor = .secondaryLabel
		adjustsFontSizeToFitWidth = true
		minimumScaleFactor = 0.90
		lineBreakMode = .byTruncatingTail
		translatesAutoresizingMaskIntoConstraints = false
	}

}
