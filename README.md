# Snippets
### Collection of code snippets, extensions, etc. I have found useful and future-me may want to use as well.  
  
      
## UIResponder 'identifier' Extension 
This simple extension returns the stringified Class name on all sub-classes of UIResponder. Which is a bunch, including UIViewController, UIView, and many more. 
```Swift
extension UIResponder {
    static var identifier : String {
        return String(describing: self)
    }
}
``` 
   
#### Example  
  
  
Leverages autocomplete to cut out a lot of repetive typing. And typos. Typos suck.  
  
```Swift 
if segue.identifier == "MyCustomViewController"
```  
in every prepareForSegue becomes:  
```Swift
if segue.identifier == MyCustomViewController.identifier
```  
  
Doesn't look much shorter, but with autocomplete, **MUCH** quicker. And more accurate.  
  
  
## PropertyNames Protocol/Extension  
This protocol and conforming extension will (generally) return a list of the Swift object's property names as an array of Strings.
I stumbled across while trying to re-factor my CloudKit Record constructor methods. It bothered me to repeatedly pass in Keys as String, because DRY and Strings are prone to typos. Typos suck. Also, use of flatMap removes need for optional unwrapping.  
  
```Swift
protocol PropertyNames {
    func propertyNames() -> [String]
}

extension PropertyNames {
    func propertyNames() -> [String] {
        return Mirror(reflecting: self).children.flatMap { $0.label }
    }
}
``` 
  
#### Example  
  
    
In my TimeClock app, creating a CloudKit Record from a Location instance went from:
```Swift
func createCKRecordFrom(location: Location) -> CKRecord? {
        let locationRecord = CKRecord(recordType: "Location")
        locationRecord["displayName"] = location.displayName as? CKRecordValue
        locationRecord["id"] = location.id as? CKRecordValue
        locationRecord["billableRate"] = location.rate as? CKRecordValue
        locationRecord["isEnabled"] = location.isEnabled as? CKRecordValue
        if let address = location.address {
            locationRecord["address"] = address as? CKRecordValue
        }
        if let city = location.city {
            locationRecord["city"] = city as? CKRecordValue
        }
        if let state = location.state {
            locationRecord["state"] = state as? CKRecordValue
        }
        if let zipCode = location.zipCode {
            locationRecord["zipCode"] = zipCode as? CKRecordValue
        }
        return locationRecord
```  
  
  
to  

```Swift
func makeCKRecordFrom(location: Location) -> CKRecord {
    let locationRecord = CKRecord(recordType: location.identifier)
    location.propertyNames().flatMap { locationRecord[$0] = location.value(forKey: $0) as? CKRecordValue }
    return locationRecord
}
```  
Concise and accurate.  
**NOTE:** value(forKey:) on line 54 works because Location conforms to NSObject (for NSCoding purposes.)  
H/T to **NSHipster** for another great discussion/explanation:  
http://nshipster.com/mirrortype/
