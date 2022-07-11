//
//  ViewController.swift
//  Egg Timer
//
//  Created by Daniel on 08.07.2022.
//

import UIKit

class ViewController: UIViewController {
    
    let softButton = DNButton(title: "Soft")
    let mediumButton = DNButton(title: "Medium")
    let hardButton = DNButton(title: "Hard")
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "How do you like your eggs?"
        label.textColor = UIColor(named: "colorText")
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 25)
        label.layer.cornerRadius = 16
        return label
    }()
    
    let timerLabel: UILabel = {
        let timerLabel = UILabel()
        timerLabel.text = "Time"
        timerLabel.textColor = UIColor(named: "colorText")
        timerLabel.textAlignment = .center
        timerLabel.font = .boldSystemFont(ofSize: 50)
        return timerLabel
    }()
    
    let shapeView: UIImageView = {
        let progressBar = UIImageView()
        progressBar.image = UIImage(named: "progressBar")
        return progressBar
    }()
    
    var timer = Timer()
    var durationTimer = 0
    var isCounting = false
    var shapeLayer = CAShapeLayer()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.animateCircular()
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        timerLabel.text = "\(durationTimer)"
        
        view.backgroundColor = UIColor(named: "colorBackground")
        
        timerLabel.isHidden = true
        
        animateCircular()
        
        softButton.addTarget(self, action: #selector(keyPressedUp), for: .touchUpInside)
        mediumButton.addTarget(self, action: #selector(keyPressedUp), for: .touchUpInside)
        hardButton.addTarget(self, action: #selector(keyPressedUp), for: .touchUpInside)
        
        softButton.addTarget(self, action: #selector(keyPressedDown), for: .touchDown)
        mediumButton.addTarget(self, action: #selector(keyPressedDown), for: .touchDown)
        hardButton.addTarget(self, action: #selector(keyPressedDown), for: .touchDown)
        
        
        let hStack = UIStackView(arrangedSubviews: [
            softButton,
            mediumButton,
            hardButton
        ])
        
        view.addSubview(label)
        view.addSubview(hStack)
        view.addSubview(shapeView)
        shapeView.addSubview(timerLabel)
        
        hStack.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        shapeView.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        //setting up horizontal Stack
        hStack.axis = .horizontal
        hStack.distribution = .fillEqually
        hStack.spacing = 3
        hStack.clipsToBounds = true
        
        
        //settinng constraints for autolayout
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            hStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            hStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            hStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -400),
            
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            shapeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150),
            shapeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shapeView.heightAnchor.constraint(equalToConstant: 200),
            shapeView.widthAnchor.constraint(equalToConstant: 200),
            
            timerLabel.centerXAnchor.constraint(equalTo: shapeView.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: shapeView.centerYAnchor)
        ])
        label.sizeToFit()
        timerLabel.sizeToFit()
    }
    
    
    //setting up actions + connections with code
    
    @objc
    func keyPressedDown (_ sender: UIButton){
        sender.alpha = 0.5
    }
    
    @objc
    func keyPressedUp(_ sender: UIButton){
        
        sender.alpha = 1
        
        if !isCounting {
            isCounting = true
            guard let senderTitle = sender.titleLabel?.text else { return }
            
            
            
            if senderTitle == "Soft" {
                durationTimer = 5
            } else if senderTitle == "Medium" {
                durationTimer = 10
            } else if senderTitle == "Hard" {
                durationTimer = 15
            }
            
            timerLabel.text = "\(durationTimer)"
            timerLabel.isHidden = false
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            basicAnimation()
        }
        
    }
    
    @objc
    func timerAction() {
        durationTimer -= 1
        timerLabel.text = "\(durationTimer)"
        
        if durationTimer == 0 {
            timer.invalidate()
            isCounting = false
            timerLabel.isHidden = true
        }
    }
    
    //MARK: Animation
    
    func animateCircular() {
        
        let center = CGPoint(x: shapeView.frame.width / 2, y: shapeView.frame.height / 2)
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        let circularPath = UIBezierPath(arcCenter: center, radius: 92, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = 18
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeColor = UIColor.systemBlue.cgColor
        shapeView.layer.addSublayer(shapeLayer)
    }
    
    func basicAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 0
        basicAnimation.duration = CFTimeInterval(durationTimer)
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = true
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
        
    }
    
}

