
import Foundation

protocol RestaurantsViewProtocol {
   func showActIndicator()
   func hideActIndicator()
   func showAlertView(message:String)
}

class RestaurantsViewModel {
        
    private var restaurantsModel:RestaurantsModel = RestaurantsModel()
    
    var restData: RestaurantData = RestaurantData() {
           didSet {
               self.bindRestaurantsViewModelToController()
           }
       }
    
    var bindRestaurantsViewModelToController:(() -> ()) = {}
    
    var view: RestaurantsViewProtocol?
    
    init(view: RestaurantsViewProtocol) {
        self.view = view
    }
    
    
    func callAPIToGetRestaurantData(radius: Int, offset: Int) {
        
       // self.view?.showActIndicator()
        
        restaurantsModel.fetchRestaurantsData(radius: radius, offset: offset, completion: { allData, error in
            
           // self.view?.hideActIndicator()
            if error != nil {
                self.view?.showAlertView(message: "\(String(describing: error))")
                
            } else if allData != nil {
                self.restData = allData ?? RestaurantData()
            }
            
        })
        
    }
    
}
