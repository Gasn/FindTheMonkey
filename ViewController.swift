//
//  ViewController.swift
//  FindTheMonkey
//
//  Created by Sang Luu on 9/7/17.
//  Copyright © 2017 Sang Luu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let numViewPerRow = 9
    
    var cells = [String: UIView]()
    
    var selectedView: UIView?
    
    var randomXPosition = Int()
    
    var randomYPosition = Int()
    
    var count = Int()
    
    var numViewPerColumn = Int()
    
    var monkeyName = String()
    
    var dictionnary = [String: UIImage]()
    
    var width = CGFloat()
    
    let radialGradientView: RadialGradientView = {
        let gradientView = RadialGradientView()
        gradientView.colors = [UIColor.red, UIColor.clear]
        return gradientView
    }()
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = true
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        initMap()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))
    }
    
    func initMap(){
        count = 0
        width = view.frame.width / CGFloat(numViewPerRow)
        numViewPerColumn = Int(view.frame.height / width)
        
        dictionnary["Mizaru"] = UIImage(named: "see_no_evil_monkey")
        dictionnary["Kikazaru"] = UIImage(named: "hear_no_evil_monkey")
        dictionnary["Iwazaru"] = UIImage(named: "speak_no_evil_monkey")
        dictionnary["Songoku"] = UIImage(named: "son_goku")
        dictionnary["Luffy"] = UIImage(named: "luffy")
        dictionnary["Super"] = UIImage(named: "super_saiyan")
        
        //get random integers for monkey position
        randomXPosition = Int(arc4random_uniform(UInt32(numViewPerRow)))
        randomYPosition = Int(arc4random_uniform(UInt32(numViewPerColumn)))
        
        
        //add radial gradient background color
        view.addSubview(radialGradientView)
        
        radialGradientView.frame = view.frame
        radialGradientView.centerGradient = CGPoint(x:  CGFloat(randomXPosition) * width, y:  CGFloat(randomYPosition) * width)
        
        
        //add monkey
        imageView.frame = CGRect(x: CGFloat(randomXPosition) * width, y: CGFloat(randomYPosition) * width, width: width, height: width)
        view.addSubview(imageView)

        //add grid cells
        for j in 0...numViewPerColumn{
            for i in 0...numViewPerRow{
                let cellView = UIView()
                cellView.backgroundColor = UIColor.darkGray
                cellView.frame = CGRect(x: CGFloat(i) * width, y: CGFloat(j) * width, width: width, height: width)
                cellView.layer.borderWidth = 0.5
                cellView.layer.borderColor = UIColor.black.cgColor
                
                view.addSubview(cellView)
                
                let key = "\(i)|\(j)"
                cells[key] = cellView
                
            }
        }
    }
    
    func handleTap(gesture: UITapGestureRecognizer){
        let location = gesture.location(in: view)
        
        let width = view.frame.width / CGFloat(numViewPerRow)
        
        let i = Int(location.x/width)
        let j = Int(location.y/width)
        let key = "\(i)|\(j)"
        guard let cellView = cells[key] else{
            return
        }
        
        if i == randomXPosition && j == randomYPosition {
            if count < 1{
                imageView.image = dictionnary["Super"]
                monkeyName = "THE SUPER SAIYAN!"
            }
            else if count < 2{
                imageView.image = dictionnary["Songoku"]
                monkeyName = "SONGOKU - The Saiyan man"
            } else if count < 3{
                imageView.image = dictionnary["Luffy"]
                monkeyName = "Luffy - The rubber man"
            } else if count < 5 {
                imageView.image = dictionnary["Mizaru"]
                monkeyName = "Mizaru - The see-no-evil monkey"
            } else if count < 8 {
                imageView.image = dictionnary["Kikazaru"]
                monkeyName = "Kikazaru - The hear-no-evil monkey"
            } else if count < 11 {
                imageView.image = dictionnary["Iwazaru"]
                monkeyName = "Iwazaru - The speak-no-evil monkey"
            } else{
                imageView.image = UIImage(named: "normal-monkey")
                monkeyName = "the monkey"
            }
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .transitionCrossDissolve, animations: {
        
            cellView.backgroundColor = UIColor.clear
            cellView.layer.borderColor = UIColor.clear.cgColor
            
            self.count += 1
            
        }, completion: { (_) in
        })
        
        if i == randomXPosition && j == randomYPosition{
            ClearMap(row: 0, col: 0)
        } else{
            CalculateStepAways(i: i, j: j)
        }
    }
    
    func CalculateStepAways(i : Int, j : Int){
        let steps = abs(i - randomXPosition) + abs(j - randomYPosition)
        showToast(message: "You are \(steps) \(steps > 1 ? "steps" : "step") away from the monkey.")
    }
    
    
    func handleLongPress(gesture: UILongPressGestureRecognizer){
        let location = gesture.location(in: view)
        
        let i = Int(location.x/width)
        let j = Int(location.y/width)
        let key = "\(i)|\(j)"
        guard let cellView = cells[key] else{
            return
        }
        
        if gesture.state == .began{
            view.bringSubview(toFront: cellView)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                cellView.layer.transform = CATransform3DMakeScale(2, 2, 2)
                
            }, completion: nil
            )
            
        }

        if gesture.state == .changed{
            if selectedView != cellView{
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    
                    self.selectedView?.layer.transform = CATransform3DIdentity
                    
                }, completion: nil)
                
            }
            selectedView = cellView
            view.bringSubview(toFront: cellView)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                cellView.layer.transform = CATransform3DMakeScale(2, 2, 2)
                
            }, completion: nil
            )

        }
        
        
        if gesture.state == .ended{
            
            if i == randomXPosition && j == randomYPosition {
                if count < 1{
                    imageView.image = dictionnary["Super"]
                    monkeyName = "THE SUPER SAIYAN!"
                } else if count < 2{
                    imageView.image = dictionnary["Songoku"]
                    monkeyName = "SONGOKU - The Saiyan man"
                } else if count < 3{
                    imageView.image = dictionnary["Luffy"]
                    monkeyName = "Luffy - The rubber man"
                } else if count < 5 {
                    imageView.image = dictionnary["Mizaru"]
                    monkeyName = "Mizaru - The see-no-evil monkey"
                } else if count < 8 {
                    imageView.image = dictionnary["Kikazaru"]
                    monkeyName = "Kikazaru - The hear-no-evil monkey"
                } else if count < 11 {
                    imageView.image = dictionnary["Iwazaru"]
                    monkeyName = "Iwazaru - The speak-no-evil monkey"
                } else{
                    imageView.image = UIImage(named: "normal-monkey")
                    monkeyName = "the monkey"
                }
            }
            
            
            
            UIView.animate(withDuration: 0.5, delay: 0.25, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                
                cellView.layer.transform = CATransform3DIdentity
                cellView.backgroundColor = UIColor.clear
                cellView.layer.borderColor = UIColor.clear.cgColor
                self.count += 1
                
            }, completion: { (_) in
                
                
            })
            
            if i == randomXPosition && j == randomYPosition{
                ClearMap(row: 0, col: 0)
            } else{
                CalculateStepAways(i: i, j: j)
            }

        }
        
       
    }
    
    func ClearMap(row: Int, col: Int){
        
        if(col >= numViewPerColumn){
            promtUser()
            return
        }
        
        let key = "\(row)|\(col)"
        guard let cellView = cells[key] else{
            return
        }
        
        UIView.animate(withDuration: 0.02, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            cellView.backgroundColor = UIColor.clear
            cellView.layer.borderColor = UIColor.clear.cgColor
            
        }, completion: { (_) in
            
            var nextR = row + 1
            var nextC = col
            if nextR >= self.numViewPerRow{
                nextR = 0
                nextC = col + 1
            }
            self.ClearMap(row: nextR, col: nextC)
            
        })
    }
    
    func promtUser(){
        
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.imageView.frame = self.view.frame
            
        }, completion: nil)
        
        let alertController = UIAlertController(title: "Congratz! You found \(monkeyName)!!.", message: "Your attempts: \(count). Do you want to retry?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Retry", style: .default) { (_) in
            self.resetMap()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func resetMap(){
        count = 0
        
        //get random integers for monkey position
        randomXPosition = Int(arc4random_uniform(UInt32(numViewPerRow)))
        randomYPosition = Int(arc4random_uniform(UInt32(numViewPerColumn)))
        
        radialGradientView.centerGradient = CGPoint(x:  CGFloat(randomXPosition) * width, y:  CGFloat(randomYPosition) * width)
        
        //add monkey
        imageView.frame = CGRect(x: CGFloat(randomXPosition) * width, y: CGFloat(randomYPosition) * width, width: width, height: width)
        
        for j in 0...numViewPerColumn{
            for i in 0...numViewPerRow{
                
                let key = "\(i)|\(j)"
                guard let cellView = cells[key] else{
                    return
                }

                cellView.backgroundColor = UIColor.darkGray
                cellView.layer.borderColor = UIColor.black.cgColor
                
                
            }
        }

    }
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-100, width: 300, height: 35))
        
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont.systemFont(ofSize: 13)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        
        view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}

























