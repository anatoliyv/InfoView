//
//  ViewController.swift
//  InfoView
//
//  Created by Anatoliy Voropay on 05/11/2016.
//  Copyright (c) 2016 Anatoliy Voropay. All rights reserved.
//

import UIKit
import InfoView

class ViewController: UIViewController {

    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var button4: UIButton!
    @IBOutlet var button5: UIButton!
    @IBOutlet var button6: UIButton!
    @IBOutlet var button7: UIButton!
    @IBOutlet var button8: UIButton!

    private lazy var buttons: [UIButton] = {
        return [ self.button1, self.button2, self.button3, self.button4, self.button5, self.button6, self.button7, self.button8 ]
    }()

    private let gradient: CAGradientLayer = CAGradientLayer()

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        gradient.frame = view.bounds
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let colorTop = UIColor(red: 178.0/255.0, green: 219.0/255.0, blue: 191.0/255.0, alpha: 1.0)
        let colorBottom = UIColor(red: 36.0/255.0, green: 123.0/255.0, blue: 160.0/255.0, alpha: 1.0)

        gradient.colors = [colorTop.cgColor, colorBottom.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        view.layer.insertSublayer(gradient, at: 0)

        segmentedControl.tintColor = .white()
        segmentedControl.setTitle("None", forSegmentAt: 0)
        segmentedControl.setTitle("FadeIn", forSegmentAt: 1)
        segmentedControl.setTitle("Fade & Scale", forSegmentAt: 2)
        segmentedControl.setTitle("Custom", forSegmentAt: 3)
        view.backgroundColor = .gray()

        let image = UIImage(named: "Info")
        for button in buttons {
            button.setImage(image!, for: UIControlState())
            button.adjustsImageWhenHighlighted = false
        }
    }

    @IBAction func pressedButton(_ button: UIButton) {
        var text = ""
        var arrowPosition: InfoViewArrowPosition = .automatic
        var animation: InfoViewAnimation = .fadeIn

        switch segmentedControl.selectedSegmentIndex {
        case 0:
            text = "Animation: None"
            animation = .none
        case 1:
            text = "Animation: Fade In"
            animation = .fadeIn
        case 2:
            text = "Animation: Fade In and Scale"
            animation = .fadeInAndScale
        case 3:
            text = "Animation: Fade In"
            animation = .fadeIn
        default:
            break
        }

        let infoView = InfoView(text: text, arrowPosition: arrowPosition, animation: animation, delegate: self)

        switch button {
        case button1:
            text += "\nArrow: left side."
            arrowPosition = .left

            if segmentedControl.selectedSegmentIndex == 3 {
                text += "\nCustom font and corner radius."
                infoView.font = UIFont.boldSystemFont(ofSize: 18)
                infoView.layer.cornerRadius = 15
            }

        case button2:
            text += "\nArrow: right side."
            arrowPosition = .right

            if segmentedControl.selectedSegmentIndex == 3 {
                text += "\nCustom font and color."
                infoView.font = UIFont(name: "AvenirNextCondensed-Regular", size: 16)
                infoView.textColor = UIColor.gray()
            }

        case button3:
            text += "\nArrow: on the top."
            arrowPosition = .top

            if segmentedControl.selectedSegmentIndex == 3 {
                text += "\nCustom background and shadow colors."
                text += "\nWill hide after 5 seconds delay automatically"
                infoView.backgroundColor = UIColor.black()
                infoView.textColor = UIColor.white()
                infoView.layer.shadowColor = UIColor.white().cgColor
                infoView.hideAfterDelay = 5
            }

        case button4:
            text += "\nArrow from a bottom and much more text.\n\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
            arrowPosition = .bottom

        case button5:
            text += "\nAutomaticaly selected arrow position"
            arrowPosition = .automatic

        case button6:
            text += "\nAutomaticaly selected arrow position and much more text.\n\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
            arrowPosition = .automatic

        case button7:
            text += "\nAutomaticaly selected arrow position"
            arrowPosition = .automatic

        case button8:
            text += "\nAutomaticaly selected arrow position and much more text.\n\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
            arrowPosition = .automatic

        default:
            break
        }

        infoView.text = text
        infoView.show(onView: view, centerView: button)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

extension ViewController: InfoViewDelegate {

    func infoViewDidHide(_ view: InfoView) {
        print("infoViewDidHide")
    }

    func infoViewDidShow(_ view: InfoView) {
        print("infoViewDidShow")
    }

    func infoViewWillHide(_ view: InfoView) {
        print("infoViewWillHide")
    }

    func infoViewWillShow(_ view: InfoView) {
        print("infoViewWillShow")
    }
}

