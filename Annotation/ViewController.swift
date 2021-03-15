//
//  ViewController.swift
//  Annotation
//
//  Created by William Newman on 3/15/21.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    var annotation: MKPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        mapView.delegate = self
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.cancelsTouchesInView = true
        
        mapView.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.delegate = self
    }
    
    @objc func tapGesture(_ sender: UITapGestureRecognizer? = nil) {
        if let removeAnnotation = annotation {
            mapView.removeAnnotation(removeAnnotation)
        }
        
        guard let point = sender?.location(in: mapView) else { return }
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        annotation.title = "Title"
        annotation.subtitle = "Subtitle"
        mapView.addAnnotation(annotation)
        
        self.annotation = annotation
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Annotation"
        var annotationView: MKAnnotationView? = nil
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
          dequeuedView.annotation = annotation
          annotationView = dequeuedView
        } else {
            annotationView = MKAnnotationView(annotation: annotation,reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView?.image = UIImage(named: "icon")
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        if let annotation = views.first?.annotation {
            mapView.selectAnnotation(annotation, animated: true)
        }
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view is MKAnnotationView) {
            return false
        }

        return true;
    }
}

