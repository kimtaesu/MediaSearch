//
//  OptionMenuView.swift
//  MediaSearch
//
//  Created by tskim on 24/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import UIKit

class OptionMenuView: UIView, NibLoadable {
  @IBOutlet var container: UIView!
  @IBOutlet weak var closeButton: UIButton!
  @IBOutlet weak var favoriteButton: UIButton!
  @IBOutlet weak var saveButton: UIButton!

  var viewHeight: CGFloat = 0
  private var timer: Timer?

  open var fadeInOutInterval = 0.1

  override var intrinsicContentSize: CGSize {
    return CGSize(width: self.frame.width, height: viewHeight)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupFromNib()
    initMenus()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupFromNib()
    initMenus()
    timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] _ in
      self?.slideOut()
    }
  }
  private func initMenus() {
    self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    container.do {
      $0.backgroundColor = .clear
    }
    favoriteButton.do {
      $0.setImage(Asset.icFavoriteBorder36pt.image.withRenderingMode(.alwaysTemplate), for: .normal)
      $0.setImage(Asset.icFavoriteFill36pt.image.withRenderingMode(.alwaysTemplate), for: .selected)
      $0.tintColor = UIColor.white
    }
    saveButton.do {
      $0.setImage(Asset.icSave36pt.image.withRenderingMode(.alwaysTemplate), for: .normal)
      $0.tintColor = UIColor.white
    }
    closeButton.do {
      $0.setImage(Asset.icClose36pt.image.withRenderingMode(.alwaysTemplate), for: .normal)
      $0.tintColor = UIColor.white
    }
  }
  func setOptionMenu(_ rightMenuOption: ImageRightMenu) {
    favoriteButton.isHidden = true
    saveButton.isHidden = true
    if rightMenuOption.contains(.favorite) {
      favoriteButton.isHidden = false
    }
    if rightMenuOption.contains(.save) {
      saveButton.isHidden = false
    }
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    viewHeight = 50 + UIApplication.shared.statusBarFrame.height

    if ScreenUtils.isIPhoneXOver {
      viewHeight += UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    }
    invalidateIntrinsicContentSize()
  }
  func visibleToggle() {
    timer?.invalidate()
    if self.alpha <= 0 {
      slideIn()
      timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] _ in
        self?.slideOut()
      }
    } else {
      slideOut()
    }
  }
  func slideIn() {
    self.alpha = 1
    UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
        self.transform = .identity
      })
  }

  func slideOut() {
    UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
        self.transform = CGAffineTransform(translationX: 0, y: -self.viewHeight)
      }, completion: { _ in
        self.alpha = 0
      })
  }
  func resetTimer() {
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] _ in
      self?.slideOut()
    }
  }
  
  func cancelTimer() {
    timer?.invalidate()
  }
  deinit {
    timer?.invalidate()
  }
}
