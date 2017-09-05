//
//  ViewController.swift
//  StretchyHeader
//
//  Created by Chad on 8/31/17.
//  Copyright © 2017 LintLabs. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    let tableView = UITableView()
    var dataArray = ["Cell 1","Cell 2","Cell 3","Cell 4","Cell 5"]
    let myIdentifier = "stretchCell";
    var rootTransform = CGAffineTransform.identity
    var stretchyImageView = UIImageView()
    var startRatio: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up table
        self.tableView.frame = self.view.bounds
        // Allow table view to resize to match superview
        self.tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: myIdentifier)
        self.view.addSubview(tableView)
        
        // Set up stretchy header
        // To function it also needs to include scrollViewDidScroll
        if let headImage = UIImage(named: "biker.jpg"){
            // scale factor for original image
            let imageRatio = self.view.bounds.width / headImage.size.width
            self.startRatio = 1.0 / imageRatio
            // Header container view
            let headView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: imageRatio * headImage.size.height))
            headView.clipsToBounds = false
            headView.backgroundColor = UIColor.red
            // ClippingView to hold transformed image
            let clipYOffset = headView.bounds.size.height - self.view.bounds.height
            let maxView = UIView(frame: CGRect(x: 0, y: clipYOffset, width: self.view.bounds.width, height: self.view.bounds.height))
            maxView.clipsToBounds = true
            // imageview at original size.
            self.stretchyImageView = UIImageView(image: headImage)
            self.stretchyImageView.contentMode = .center
            self.stretchyImageView.image = headImage
            // Center imageView on header
            self.stretchyImageView.frame = CGRect(
                x: 0,
                y: 0 - clipYOffset,
                width: headView.bounds.width,
                height: headView.bounds.height
            )
            // Then scale it to match header size
            self.rootTransform = self.rootTransform.scaledBy(x: imageRatio, y: imageRatio)
            self.stretchyImageView.transform = self.rootTransform
            
            maxView.addSubview(self.stretchyImageView)
            headView.addSubview(maxView)
            self.tableView.tableHeaderView = headView
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Table
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // We could check the text to see how big of a cell we need to fit it all.
        return 40
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        // create reusable cell object
        let cell = tableView.dequeueReusableCell(withIdentifier: myIdentifier, for: indexPath)
        
        let dataString: String = self.dataArray[indexPath.row]
        cell.textLabel?.text = dataString
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        // Check if we have data
        return dataArray.count
    }
    // MARK: ScrollView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Update header image
        if scrollView.contentOffset.y < 0 {
            // Zoom image to fit
            if let headView = tableView.tableHeaderView{
                // I think the math will be cleaner if we restart from identity each time...
                //var newTransform = CGAffineTransform.identity
                var newTransform = self.rootTransform
                // Center in new space, half scroll distance and compensate for starting transform
                newTransform = newTransform.translatedBy(x: 0.0, y: (scrollView.contentOffset.y * 0.5) * self.startRatio)
                // Scale to new size
                let startHeight = headView.bounds.height
                let newHeight = startHeight - scrollView.contentOffset.y
                let newRatio = newHeight / startHeight
                newTransform = newTransform.scaledBy(x: newRatio, y: newRatio)
                
                stretchyImageView.transform = newTransform
            }
        }
        else {
            // Paralax image
            var newTransform = self.rootTransform
            // Offset by half offset
            newTransform = newTransform.translatedBy(x: 0.0, y: (scrollView.contentOffset.y / 2.0))
            stretchyImageView.transform = newTransform
        }
    }

}
