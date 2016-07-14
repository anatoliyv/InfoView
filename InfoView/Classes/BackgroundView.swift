//
//  BackgroundView.swift
//  Pods
//
//  Created by Anatoliy Voropay on 5/12/16.
//
//

import UIKit

/**
 Background view that handle touches
 */
internal protocol BackgroundViewDelegate : class {
    func pressedBackgorund(_ view: BackgroundView)
}

internal class BackgroundView: UIView {

    var delegate: BackgroundViewDelegate?

    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        customize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customize()
    }

    private func customize() {
        isUserInteractionEnabled = true

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(BackgroundView.pressedBackground(_:)))
        addGestureRecognizer(tapRecognizer)
    }

    @objc func pressedBackground(_ sender: AnyObject?) {
        delegate?.pressedBackgorund(self)
    }
}
