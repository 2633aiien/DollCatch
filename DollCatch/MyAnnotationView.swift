//
//  MyAnnotationView.swift
//  DollCatch
//
//  Created by allen on 2021/10/5.
//

import UIKit
import MapKit

class MyAnnotationView: MKPinAnnotationView {

    override var annotation: MKAnnotation? { didSet { configureDetailView() } }

       override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
           super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
           configure()
       }

       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           configure()
       }
   }

   private extension MyAnnotationView {
       func configure() {
           canShowCallout = true
           configureDetailView()
       }

       func configureDetailView() {
           guard let annotation = annotation else { return }

           let rect = CGRect(origin: .zero, size: CGSize(width: 300, height: 200))

           let snapshotView = UIView()
           snapshotView.translatesAutoresizingMaskIntoConstraints = false

           let options = MKMapSnapshotter.Options()
           options.size = rect.size
           options.mapType = .satelliteFlyover
           options.camera = MKMapCamera(lookingAtCenter: annotation.coordinate, fromDistance: 250, pitch: 65, heading: 0)

           let snapshotter = MKMapSnapshotter(options: options)
           snapshotter.start { snapshot, error in
               guard let snapshot = snapshot, error == nil else {
                   print(error ?? "Unknown error")
                   return
               }

               let view = SearchCollectionViewCell()
               snapshotView.addSubview(view)
           }

           detailCalloutAccessoryView = snapshotView
           NSLayoutConstraint.activate([
               snapshotView.widthAnchor.constraint(equalToConstant: rect.width),
               snapshotView.heightAnchor.constraint(equalToConstant: rect.height)
           ])
}
   }
