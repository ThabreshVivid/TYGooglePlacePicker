//
//  ViewController.swift
//  TYGooglePlacePicker
//
//  Created by Thabu on 3/26/16.
//  Copyright © 2016 vivid. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {
var placesClient: GMSPlacesClient?
    @IBOutlet var txtCoordinate: UITextView!
    @IBOutlet var txtAddress: UITextView!
    @IBOutlet var LoadActivity: UIActivityIndicatorView!
    @IBOutlet var BckView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.BckView.hidden = true
        self.LoadActivity.stopAnimating()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func ClickOnPickAddress(sender: AnyObject) {
        self.BckView.hidden = true
        self.LoadActivity.startAnimating()
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.presentViewController(autocompleteController, animated: true, completion: nil)
    }
    @IBAction func ClickOncurrntLoc(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let aVariable = appDelegate.Apikey
        if(aVariable?.length==0)
        {
            self.BckView.hidden = true
            LoadActivity.stopAnimating()
            let alert = UIAlertController(title: "", message:"Please Give Your API Key in AppDelegate", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }else
        {
            LoadActivity.startAnimating()
            placesClient = GMSPlacesClient()
            placesClient?.currentPlaceWithCallback({
                (placeLikelihoodList: GMSPlaceLikelihoodList?, error: NSError?) -> Void in
                if let error = error {
                    self.BckView.hidden = true
                    self.LoadActivity.stopAnimating()
                    let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    return
                }
                if let placeLikelihoodList = placeLikelihoodList {
                    let place = placeLikelihoodList.likelihoods.first?.place
                    if let place = place {
                        self.txtAddress.text=place.formattedAddress
                        let appendString2 = "Latitude : \(place.coordinate.latitude)\n\nLongitude : \(place.coordinate.longitude)"
                        self.txtCoordinate.text=appendString2
                        self.LoadActivity.stopAnimating()
                        self.BckView.hidden = false
                    }}
            })
        }}
}
extension ViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(viewController: GMSAutocompleteViewController, didAutocompleteWithPlace place: GMSPlace) {
        print("Place name: ", place.name)
        print("Place address: ", place.formattedAddress)
        print("Place attributions: ", place.attributions)
        self.dismissViewControllerAnimated(true, completion: nil)
        self.txtAddress.text=place.formattedAddress
        let appendString2 = "Latitude : \(place.coordinate.latitude)\n\nLongitude : \(place.coordinate.longitude)"
        self.txtCoordinate.text=appendString2
        self.LoadActivity.stopAnimating()
        self.BckView.hidden = false
    }
    func viewController(viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: NSError) {
        print("Error: ", error.description)
         LoadActivity.stopAnimating()
    }
    func wasCancelled(viewController: GMSAutocompleteViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
         LoadActivity.stopAnimating()
    }
    func didRequestAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    func didUpdateAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}
