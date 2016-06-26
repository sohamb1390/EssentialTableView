//
//  SBCityDetailsViewController.swift
//  SBEssentialTableView
//
//  Created by Soham Bhattacharjee on 12/04/16.
//  Copyright © 2016 Soham Bhattacharjee. All rights reserved.
//

import UIKit
import MapKit

protocol CityDetailsDelegate {
    func shareLocation(image: UIImage)
}

class SBCityDetailsViewController: UIViewController {
    
    // Properties
    var detailLatitude: Double?
    var detailLongitude: Double?
    var detailAnnotation: String?
    var detailTitle: String?
    var newLocation = CLLocationCoordinate2D()
    var delegate: CityDetailsDelegate?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let title = self.detailTitle, subtitle = self.detailAnnotation, lat = self.detailLatitude, long = self.detailLongitude {
            self.navBar.topItem?.title = subtitle
            self.renderMap(title, subtitle: subtitle, lat: lat, long: long)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Preview action items
    // User swipes upward on a 3D Touch preview
    override func previewActionItems() -> [UIPreviewActionItem] {
        return previewDetailsActions
    }
    
    lazy var previewDetailsActions: [UIPreviewActionItem] = {
        func previewActionForTitle(title: String, style: UIPreviewActionStyle = .Default) -> UIPreviewAction {
            return UIPreviewAction(title: title, style: style) { previewAction, viewController in
                guard let detailViewController = viewController as? SBCityDetailsViewController,
                    item = detailViewController.detailAnnotation else {
                        return
                }
                
                if previewAction.title == "Share Location" {
                   self.shareMapSnapShot()
                }
                print("\(previewAction.title) triggered from `DetailsViewController` for item: \(item)")
            }
        }
        
        // I have taken only one button for example
        let actionDefault = previewActionForTitle("Share Location")
        
        // You can edit these buttons/groups
        // ** Editable ** //
        let actionDestructive = previewActionForTitle("Destructive Action", style: .Destructive)
        let subActionGoTo = previewActionForTitle("Go to coordinates")
        let subActionSave = previewActionForTitle("Save location")
        let groupedOptionsActions = UIPreviewActionGroup(title: "Options…", style: .Default, actions: [subActionGoTo, subActionSave] )
        
        return [actionDefault, actionDestructive, groupedOptionsActions]
    }()
    
    // MARK: MKMapView Delegates
    func renderMap(title: String, subtitle: String, lat: Double, long: Double) {
        self.newLocation.latitude = lat
        self.newLocation.longitude = long
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: self.newLocation, span: span)
        
        self.mapView?.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = self.newLocation
        annotation.title = title
        annotation.subtitle = subtitle
        self.mapView?.addAnnotation(annotation)
        self.mapView?.selectAnnotation(annotation, animated: true)
    }
    
    // MARK: 3D Touch Action -- Sharing Map Snapshot
    func shareMapSnapShot() {
        let options = MKMapSnapshotOptions()
        options.region = self.mapView.region
        options.scale = UIScreen.mainScreen().scale
        options.size = self.mapView.frame.size
        options.showsBuildings = true
        options.showsPointsOfInterest = true
        
        let snapShotter = MKMapSnapshotter(options: options)
        snapShotter.startWithCompletionHandler { (snapshot: MKMapSnapshot?, error: NSError?) in
            if let image = snapshot?.image, cityDetailsDelegate = self.delegate {
                cityDetailsDelegate.shareLocation(image)
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
