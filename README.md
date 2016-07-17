EssentialTableView
![alt text](screenshots/file:///Users/sohambhattacharjee/Desktop/Simulator%20Screen%20Shot%2017-Jul-2016,%2012.21.10%20PM.png "Snap taken for a reference")

A Complete detailed project on UITableView which includes

1. Parallax Effects on UITableViewCell: 

You just have to take the UITableView subclass "ParallaxCell.swift" along with the XIB file "ParallaxCell.xib" and the
model class "CellModel.swift". In the "ViewController.swift" file there are three methods which you have to take out along
with the UITableView's required delegate & datasource methods:

a. func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
b. func scrollViewDidScroll(scrollView: UIScrollView)
c. func setCellImageOffset(cell: ParallaxCell, indexPath: NSIndexPath)



2. Expand/Collapse functionality on UITableViewCell:

For this, you can set your own data in two ways:
a. Header array
b. Content array

For setting your Header elements you can edit "stateArray" declared in "ViewController.swift" file and for setting
the content elements you have to edit the "cityArray" which contains of Dictionary kind of elements.
The Dictionary is a type of "<String, Array<City>>" i.e the dictionary will hold a "City" type object element for a 
particular key, you can take a look at the "City.swift" model file which is nothing but a simple class containg few variables.

Here I have created a Tap Gesture functionality on the UITableViewHeader for each section.
This gesture is completely being handled by the function:

func headerViewTapped(gesture: UITapGestureRecognizer)

you can take a look on this function and you will understand how this function is handling "collapsing/expanding" feature
on a UITableViewCell



3. 3D Touch on UITableViewCell:

For this functionality you can get a checking condition written in ViewDidLoad method:

if traitCollection.forceTouchCapability == UIForceTouchCapability.Available {
  // register UIViewControllerPreviewingDelegate to enable Peek & Pop
  registerForPreviewingWithDelegate(self, sourceView: self.view)
}

This checking ensures whether your device is capable of 3D Touch or not.
If this condition return true you have to take two more methods from the "ViewController.swift":

func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {}
func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {}

The first method will help you to present your DetailViewController (here this has been handled by "SBCityDetailsViewController.swift")
after a successful attempt of 3D Touch on any of the UITableViewcells.
