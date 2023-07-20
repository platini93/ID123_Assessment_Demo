import Foundation

class RestaurantData {
    var businesses:[Business] = []
    var total:Int = 0
}

class Business {
    var name:String = ""
    var imageURL:String = ""
    var isClosed:Bool = false
    var ratings:Double = 0.0
    var distance:Double = 0.0
    var location:Address = Address()
}

class Address {
    var address1:String = ""
}

class RestaurantsModel {
    
    func fetchRestaurantsData(radius: Int, offset: Int, completion: @escaping (_ allData:RestaurantData?, _ error:Error?) -> Void) {
        
        let listData:RestaurantData = RestaurantData()
        
        var urlString:String = "\(URLConstants.restaurantSearchURL)?term=restaurants&location=NYC&radius=\(radius)&limit=\(GlobalConstants.pageLimit)&sort_by=distance&offset=\(offset)"
        
        NetworkRequest.shared.getRequest(urlString: urlString, completion: { data, error in
            
            if error != nil {
                print("Error = \(String(describing: error))")
                completion(nil, error)
            } else if data != nil {
                print("Data inside closure = \(String(describing: data))")
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                    print("Json Data = \(String(describing: json))")
                    
                    let total = json?["total"] as? Int ?? 0
                    listData.total = total
                    
                    let businesses = json?["businesses"] as? [[String:Any]] ?? []
                    
                    for bus in businesses {
                        
                        let location = bus["location"] as? [String:Any] ?? [:]
                        let address1 = location["address1"] as? String ?? ""
                        let address = Address()
                        address.address1 = address1
                        
                        let business = Business()
                        business.name = bus["name"] as? String ?? ""
                        business.distance = bus["distance"] as? Double ?? 0.0
                        business.imageURL = bus["image_url"] as? String ?? ""
                        business.isClosed = bus["is_closed"] as? Bool ?? false
                        business.ratings = bus["rating"] as? Double ?? 0.0
                        business.location = address
                        
                        listData.businesses.append(business)
                        
                    }
                    
                    completion(listData,nil)
                    
                } catch {
                    print("error Msg")
                    completion(nil, error)
                }
            }
            
        })
    }
}
