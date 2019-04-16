//
//  Review.swift
//  Snacktacular
//
//  Created by Victoria Wong on 4/15/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Review {
    var title: String
    var text: String
    var rating: Int
    var reviewUserID: String
    var date: Date
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["title" : title, "text": text, "rating" : rating, "reviewUserID": reviewUserID, "date" : date, "documentID" : documentID]
    }
    
    init(title: String, text: String, rating: Int, reviewUserID: String, date: Date, documentID: String) {
        self.title = title
        self.text = text
        self.rating = rating
        self.reviewUserID = reviewUserID
        self.date = date
        self.documentID = documentID
    }
    convenience init() {
        let currentUserID = Auth.auth().currentUser?.email ?? "Unknown User"
        self.init(title: "", text: "", rating: 0, reviewUserID: currentUserID, date: Date(), documentID: "")
    }
    func saveData(spot: Spot, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let dataToSave = self.dictionary
        //if we have saved a record we'll have a documentID
        if self.documentID != "" {
            let ref = db.collection("spots").document(spot.documentID).collection("reviews").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print ("*** ERROR Updating docuemnt \(self.documentID) \(error.localizedDescription)")
                    completed (false)
                } else {
                    print ("^^^ Document updated with ref ID \(ref.documentID)")
                    completed (true)
                }
            }
        } else {
            var ref: DocumentReference? = nil // let firestore create the new documentID
            ref = db.collection("spots").document(spot.documentID).collection("reviews").addDocument(data: dataToSave) { error in
                if let error = error {
                    print ("*** ERROR creating document in spot \(spot.documentID) for new review doucmentID \(error.localizedDescription)")
                    completed (false)
                } else {
                    print ("^^^ Document updated with ref ID \(ref?.documentID ?? "unknown")")
                    completed (true)
                }
            }
        }
    }
}
