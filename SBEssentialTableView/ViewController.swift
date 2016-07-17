//
//  ViewController.swift
//  SBEssentialTableView
//
//  Created by Soham Bhattacharjee on 12/04/16.
//  Copyright © 2016 Soham Bhattacharjee. All rights reserved.
//

import UIKit

let sectionHeaderViewIdentifier = "SectionHeaderViewIdentifier";
let cellIdentifierForCity = "ParallaxCellIdentifier";
let cellIdentifierForState = "CityCellIdentifier";

let storyboardID = "SBCityDetailsViewController"
let segueID = "showDetails"

class ViewController: UIViewController {
    
    // Declaring the Mutable array of PopularCities Structure
    var cityArray:[Dictionary<String, Array<City>>] = []
    var stateArray:[String] = []
    var booleanArray:[NSNumber] = []
    
    var selectedIndexPath: NSIndexPath?
    var selectedHeaderIndexPath: NSIndexPath?
    
    @IBOutlet weak var tblCity: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblCity.registerNib(UINib(nibName: "CityTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifierForState)
        self.tblCity.registerNib(UINib.init(nibName: "ParallaxCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "ParallaxCellIdentifier")
        
        self.tblCity!.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
        
        self.populateData()
        
        // Checking 3DTouch availablity
        if traitCollection.forceTouchCapability == UIForceTouchCapability.Available {
            // register UIViewControllerPreviewingDelegate to enable Peek & Pop
            registerForPreviewingWithDelegate(self, sourceView: self.view)
        }
        else {
            let alertController = UIAlertController(title: "3DTouch unavailable", message: "Unsupported device", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (actionStyle) in
                print("Not able to load 3DTouch")
            })
            alertController.addAction(action)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Populate Data
    func populateData() {
        
        self.stateArray = ["Maharashtra", "Delhi", "Karnataka", "Tamil Nadu", "West Bengal", "Gujarat", "Andhra Pradesh", "Rajasthan"]
        
        for _ in 0 ..< self.stateArray.count {
            self.booleanArray.append(NSNumber(bool: false))
        }
        
        var dict = Dictionary<String, Array<City>>()
        
        for item in self.stateArray {
            switch item {
            case "Maharashtra":
                dict[item] = [City(cityName: "Mumbai", annotation: "Marine Drive", latitude: 18.9438, longitude: 72.8227, imageName: "MarineDrive.jpg"),
                City(cityName: "Pune", annotation: "Aga Khan Palace", latitude: 18.5523, longitude: 73.9015, imageName: "AgaKhanPalace.jpg")]
                break
            case "Delhi":
                dict[item] = [City(cityName: "Delhi", annotation: "India Gate", latitude: 28.6129, longitude: 77.2295, imageName: "IndiaGate.jpg")]
                break
            case "Karnataka":
                dict[item] = [City(cityName: "Bengaluru", annotation: "Wonderla", latitude: 12.8343, longitude: 77.4010, imageName: "Wonderla.jpg")]
                break
            case "Tamil Nadu":
                dict[item] = [City(cityName: "Chennai", annotation: "Marina Beach", latitude: 13.0500, longitude: 80.2824, imageName: "MerinaBeach.jpg")]
                break
            case "West Bengal":
                dict[item] = [City(cityName: "Kolkata", annotation: "Victoria Memorial", latitude: 22.5448, longitude: 88.3426, imageName: "VictoriaMemorial.jpg")]
                break
            case "Gujarat":
                dict[item] = [City(cityName: "Surat", annotation: "Dumas Beach", latitude: 21.0838, longitude: 72.7093, imageName: "DumasBeach.jpg"),
                City(cityName: "Ahmedabad", annotation: "Sabarmati Ashram", latitude: 23.0608, longitude: 72.5809, imageName: "SabarmartiAshram.jpg")]
                break
            case "Andhra Pradesh":
                dict[item] = [City(cityName: "Hyderabad", annotation: "Golconda Fort", latitude: 17.3833, longitude: 78.4011, imageName: "GolcondaFort.jpg")]
                break
            case "Rajasthan":
                dict[item] = [City(cityName: "Jaipur", annotation: "City Palace", latitude: 26.9255, longitude: 75.8236, imageName: "CityPalace.jpg")]
                break
            default:
                break
            }
            self.cityArray.append(dict)
        }
    }
    
    // MARK: Tap Gesture Action
    func headerViewTapped(gesture: UITapGestureRecognizer) {
        self.selectedHeaderIndexPath = NSIndexPath(forRow: 0, inSection: (gesture.view?.tag)!)
        if self.selectedHeaderIndexPath!.row == 0 {
            var isCollapsed = self.booleanArray[(self.selectedHeaderIndexPath?.section)!].boolValue
            isCollapsed = !isCollapsed
            
            for (idx, _) in self.booleanArray.enumerate() {
                if idx == self.selectedHeaderIndexPath?.section {
                    self.booleanArray[idx] = NSNumber(bool: isCollapsed)
                    break
                }
            }
            
            let range = NSMakeRange(self.selectedHeaderIndexPath!.section, 1)
            let sectionToReload = NSIndexSet(indexesInRange: range)
            self.tblCity?.reloadSections(sectionToReload, withRowAnimation: .Fade)
            if gesture.view?.tag == self.stateArray.count - 1 {
                
                self.tblCity.scrollToRowAtIndexPath(self.selectedHeaderIndexPath!, atScrollPosition: .Bottom, animated: true)
            }
        }
    }
    
    // MARK: Iteration
    func loopThroughArray(stateName: String)-> [City]? {
        for item in self.cityArray {
            let dict = item as Dictionary<String, Array<City>>
            for key in Array(dict.keys) {
                if key == stateName {
                   return dict[key]! as [City]
                }
            }
        }
        return nil
    }
    
    // MARK: Segue delegate
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueID && self.selectedIndexPath != nil {
            let detailsVC = segue.destinationViewController as! SBCityDetailsViewController
            
            
            if let stateName: String = self.stateArray[self.selectedHeaderIndexPath!.section] as String {
                if let arrCities:[City] = self.loopThroughArray(stateName) {
                    let previewCityObj = arrCities[self.selectedIndexPath!.row]
                    detailsVC.detailAnnotation = previewCityObj.annotation
                    detailsVC.detailLatitude = previewCityObj.latitude
                    detailsVC.detailLongitude = previewCityObj.longitude
                    detailsVC.detailTitle = previewCityObj.cityName
                }
            }
        }
    }
}

// MARK: UIViewControllerPreviewingDelegate
extension ViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        // Getting indexPath for location and respective cell for that particular indexPath
        let cellPosition = self.tblCity?.convertPoint(location, fromView: view)
        
        guard let indexPath = self.tblCity?.indexPathForRowAtPoint(cellPosition!), cell = self.tblCity?.cellForRowAtIndexPath(indexPath) as? ParallaxCell else {
            return nil
        }
        
        // Instantiate VC with Identifier (Storyboard ID)
        guard let previewViewController = storyboard?.instantiateViewControllerWithIdentifier(storyboardID) as? SBCityDetailsViewController else {
            return nil
        }
        previewViewController.delegate = self
        
        if let stateName: String = self.stateArray[indexPath.section] as String {
            if let arrCities:[City] = self.loopThroughArray(stateName) {
                    if let previewCityObj: City = arrCities[self.selectedIndexPath!.row] {
                        detailsVC.detailAnnotation = previewCityObj.annotation
                        detailsVC.detailLatitude = previewCityObj.latitude
                        detailsVC.detailLongitude = previewCityObj.longitude
                        detailsVC.detailTitle = previewCityObj.cityName
                    }
                }
        }
        
        // Preferred Content Size for Preview (CGSize)
        previewViewController.preferredContentSize = CGSize(width: 0.0, height: 0.0)
        
        // Current context Source.
        let cellFrame = cell.frame
        previewingContext.sourceRect = view.convertRect(cellFrame, fromView: self.tblCity)
        
        return previewViewController
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        showViewController(viewControllerToCommit, sender: self)
    }
}

// MARK: UITableView Delegates & DataSource
extension ViewController: UITabBarDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.stateArray.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.booleanArray[section].boolValue {
            for item in self.cityArray {
                let dict = item as Dictionary<String, Array<City>>
                if (dict[self.stateArray[section]] != nil) {
                    return (dict[self.stateArray[section]]! as [City]).count
                }
            }
        }
        return 1
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionTitle = self.stateArray[section] as String
        let headerView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        headerView.backgroundColor = self.navigationController?.navigationBar.tintColor
        headerView.tag = section
        let headerLabel = UILabel(frame: CGRectMake(10, 0, self.view.frame.size.width-20-50, 50))
        headerLabel.backgroundColor = UIColor.clearColor()
        headerLabel.font = UIFont(name: "Helvetica Neue-Light", size: 17.0)
        headerLabel.textColor = UIColor.whiteColor()
        headerLabel.text = sectionTitle
        headerView.addSubview(headerLabel)
        
        // Adding Tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.headerViewTapped(_:)))
        headerView.addGestureRecognizer(tapGesture)
        
        return headerView
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRectZero)
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.booleanArray[indexPath.section].boolValue {
            return 250.0
        }
        return 1.0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let tempCell = UITableViewCell()
        if let stateName: String = self.stateArray[indexPath.section] as String {
            
            let manyCells = self.booleanArray[indexPath.section].boolValue
            if !manyCells {
              let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifierForState) as! CityTableViewCell
                cell.lblCityName?.text = stateName
                return cell
            }
            else {
                if let arrCities:[City] = self.loopThroughArray(stateName) {
                    let cityObject = arrCities[indexPath.row]
                    
                    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifierForCity) as! ParallaxCell
                    cell.model = CellModel(imageName: cityObject.imageName!, title: cityObject.annotation!)
                    return cell
                }
            }
        }
        return tempCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndexPath = indexPath
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier(segueID, sender: self)
    }
    
    // MARK: - Parallax helpers
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let imageCell:UITableViewCell = cell where imageCell.isKindOfClass(ParallaxCell) {
            self.setCellImageOffset(imageCell as! ParallaxCell, indexPath: indexPath)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView == self.tblCity) {
            if let indexArrays = self.tblCity.indexPathsForVisibleRows {
                for indexPath in indexArrays {
                    if let cell = self.tblCity.cellForRowAtIndexPath(indexPath) {
                        if cell.isKindOfClass(ParallaxCell) {
                            self.setCellImageOffset(cell as! ParallaxCell, indexPath: indexPath)
                        }
                    }
                }
            }
        }
    }
    
    func setCellImageOffset(cell: ParallaxCell, indexPath: NSIndexPath) {
        let cellFrame = self.tblCity.rectForRowAtIndexPath(indexPath)
        let cellFrameInTable = self.tblCity.convertRect(cellFrame, toView:self.tblCity.superview)
        let cellOffset = cellFrameInTable.origin.y + cellFrameInTable.size.height
        let tableHeight = self.tblCity.bounds.size.height + cellFrameInTable.size.height
        let cellOffsetFactor = cellOffset / tableHeight
        cell.setBackgroundOffset(cellOffsetFactor)
    }
}

// MARK: - Share Map Snapshot Delegate Method

extension ViewController: CityDetailsDelegate {
    func shareLocation(image: UIImage) {
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.presentViewController(controller, animated: true, completion: nil)
    }
}

