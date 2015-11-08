//
//  InterfaceController.swift
//  e3-konkret WatchKit Extension
//
//  Created by Tino Langer on 08.11.15.
//  Copyright © 2015 Tino Langer. All rights reserved.
//

import WatchKit
import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}

enum Labels {
    case electricEnergy, photoVoltaic, battery
}

class InterfaceController: WKInterfaceController {

    // timer object
    var timer : NSTimer?
    
    // label outlets
    
    @IBOutlet var labelElectricEnergy: WKInterfaceLabel!
    @IBOutlet var labelPhotoVoltaic: WKInterfaceLabel!
    @IBOutlet var labelBattery: WKInterfaceLabel!
  
    var data : NSData = NSData()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
        print("start application...")
    }

    override func willActivate() {
        
        print("start timer...")
        self.timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("getDemoData"), userInfo: nil, repeats: true)
        
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        
        print("stopp timer...")
        timer?.invalidate()
        
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // MARK: get data
    
    func getDemoData() -> String {
        
        // define endpoint
        let endpoint1 = NSURL(string: "http://linkedfactory.iwu.fraunhofer.de/linkedfactory/demofactory/machine1/values?properties=value&limit=1")
        let endpoint2 = NSURL(string: "http://linkedfactory.iwu.fraunhofer.de/linkedfactory/demofactory/machine2/values?properties=value&limit=1")
        let endpoint3 = NSURL(string: "http://linkedfactory.iwu.fraunhofer.de/linkedfactory/demofactory/machine3/values?properties=value&limit=1")
        
        // new version using watchOS2-sprecific way
        let taskElectricEnergy = NSURLSession.sharedSession().dataTaskWithURL(endpoint1!) {(data, response, error) in
            let jsonSwift = JSON(data: data!)
            
            // calculate calue count - should be 1
            let valueCount = jsonSwift["http://linkedfactory.iwu.fraunhofer.de/linkedfactory/demofactory/machine1"]["value"].count
            
            if valueCount > 0 {
                
                var value = ((String)(jsonSwift["http://linkedfactory.iwu.fraunhofer.de/linkedfactory/demofactory/machine1"]["value"][0]["value"]))
                
                var doubleValue : Double = Double(value)!
                doubleValue = doubleValue.roundToPlaces(4)
                
                self.update(Labels.electricEnergy, readValue: String(doubleValue))
                
            } else {
                self.update(Labels.electricEnergy, readValue: "0")
            }
        }
        taskElectricEnergy.resume()
        
        let taskPhotoVoltaic = NSURLSession.sharedSession().dataTaskWithURL(endpoint2!) {(data, response, error) in
            let jsonSwift = JSON(data: data!)
            
            // calculate calue count - should be 1
            let valueCount = jsonSwift["http://linkedfactory.iwu.fraunhofer.de/linkedfactory/demofactory/machine2"]["value"].count
            
            if valueCount > 0 {
                
                var value = ((String)(jsonSwift["http://linkedfactory.iwu.fraunhofer.de/linkedfactory/demofactory/machine2"]["value"][0]["value"]))
                
                var doubleValue : Double = Double(value)!
                doubleValue = doubleValue.roundToPlaces(4)
                
                self.update(Labels.photoVoltaic, readValue: String(doubleValue))
                
            } else {
                self.update(Labels.photoVoltaic, readValue: "0")
            }
        }
        taskPhotoVoltaic.resume()
        
        let taskBattery = NSURLSession.sharedSession().dataTaskWithURL(endpoint3!) {(data, response, error) in
            let jsonSwift = JSON(data: data!)
            
            // calculate calue count - should be 1
            let valueCount = jsonSwift["http://linkedfactory.iwu.fraunhofer.de/linkedfactory/demofactory/machine3"]["value"].count
            
            if valueCount > 0 {
                
                var value = ((String)(jsonSwift["http://linkedfactory.iwu.fraunhofer.de/linkedfactory/demofactory/machine3"]["value"][0]["value"]))
                
                var doubleValue : Double = Double(value)!
                doubleValue = doubleValue.roundToPlaces(4)
                
                self.update(Labels.battery, readValue: String(doubleValue))
                
            } else {
                self.update(Labels.battery, readValue: "0")
            }
        }
        taskBattery.resume()

        
        // old version
        //let jsondata = NSData(contentsOfURL: endpoint!)
        /*
        // use SwiftyJSON
        let jsonSwift = JSON(data: jsondata)
        
        // calculate calue count - should be 1
        let valueCount = jsonSwift["http://linkedfactory.iwu.fraunhofer.de/linkedfactory/demofactory/machine1"]["value"].count
        
        if valueCount > 0 {
            return ((String)(jsonSwift["http://linkedfactory.iwu.fraunhofer.de/linkedfactory/demofactory/machine1"]["value"][0]["value"]))
        } else {
            return ("0")
        }*/
        return ""
    }
    
    // MARK: update data
    
    func update(label: Labels, readValue: String) {
        
        //let readValue = getDemoData()
        
        print("update with value: ", readValue, " for label ", label)
        
        switch label {
        case Labels.electricEnergy:
            labelElectricEnergy.setText(readValue)
        case Labels.photoVoltaic:
            labelPhotoVoltaic.setText(readValue)
        case Labels.battery:
            labelBattery.setText(readValue)
        }
        
        
        
        
        
    }

}
