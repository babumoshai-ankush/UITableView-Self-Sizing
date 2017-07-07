//
//  ViewController.swift
//  TableViewSelfSizingDemo
//
//  Created by Ankush Chakraborty on 05/07/17.
//  Copyright © 2017 Ankush Chakraborty. All rights reserved.
//

import UIKit

struct Data {
    var title: String?
    var description: String?
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var sliderFont: UISlider!
    @IBOutlet weak var lblFontSize: UILabel!

    var arrData: [Data]?
    var fontSize: Int = UIDevice.current.userInterfaceIdiom == .pad ? 22 : 15
    
    //MARK: - View Controller Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.estimatedRowHeight = 64.0
        tblView.rowHeight = UITableViewAutomaticDimension
        sliderFont.value = Float(fontSize)
        lblFontSize.text = "\(lblFontSize.text!) \(fontSize)"
        arrData = loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - UITableViewDataSource Methods Implementation -
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (arrData?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier") as! CustomTableViewCell
        let d = arrData?[indexPath.row]
        cell.lblTitle.text = d?.title
        cell.lblDescription.text = d?.description
        cell.lblTitle.font = UIFont(name: cell.lblTitle.font.fontName, size: CGFloat(fontSize))
        cell.lblDescription.font = UIFont(name: cell.lblDescription.font.fontName, size: CGFloat(fontSize))
        cell.contentView.backgroundColor = (indexPath.row % 2 == 0 ? UIColor.white : UIColor(red: 242.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0))
        return cell
    }
    
    //MARK: - Button Actions -
    
    @IBAction func sliderFontDidValueChange(_ sender: Any) {
        let slider = sender as! UISlider
        if fontSize != (Int(slider.value) / 1) {
            fontSize = Int(slider.value) / 1
            lblFontSize.text = "Font Size \(fontSize)"
            let cells = self.tblView.visibleCells as! [CustomTableViewCell]
            for cell in cells {
                cell.lblTitle.font = UIFont(name: cell.lblTitle.font.fontName, size: CGFloat(fontSize))
                cell.lblDescription.font = UIFont(name: cell.lblDescription.font.fontName, size: CGFloat(fontSize))
            }
            tblView.reloadRows(at: tblView.indexPathsForVisibleRows!, with: .fade)
        }
    }
    
    //MARK: - Internal Methods -
    
    func loadData() -> [Data] {
        var aData = [Data]()
        let path = Bundle.main.path(forResource: "data", ofType: "plist")
        if let p = path {
            if let arr = NSArray(contentsOfFile: p) {
                for data in arr as! [Dictionary<String, String>] {
                    aData.append(Data(title: data["title"]!, description: data["desc"]!))
                }
            }
        }
        return aData
    }
}

