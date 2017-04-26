# Snippets
### Collection of code snippets, extensions, etc. I have found useful and future-me may want to use as well.  
  
    
## UIResponder 'identifier' Extension 
This simple extension returns the stringified Class name on all sub-classes of UIResponder. Which is a bunch, including UIViewController, UIView, and many more. 

#### Example  
  
  
Leverages autocomplete to cut out a lot of repetive typing. And typos. Typos suck.  
  
```if segue.identifier == "MyCustomViewController"```  in every prepareForSegue  
becomes  
```if segue.identifier == MyCustomViewController.identifier```  
  
Doesn't look much shorter, but with autocomplete, **MUCH** quicker. And more accurate.  
  
  
## PropertyNames Protocol/Extension
This protocol and conforming extension will (generally) return a list of the Swift object's property names as an array of Strings.
I stumbled across while trying to re-factor my CloudKit Record constructor methods. It bothered me to repeatedly pass in Keys as String, because DRY and Strings are prone to typos. Also, use of flatMap removes need for optional unwrapping.

#### Example  
  
    
In my TimeClock app, creating a CloudKit Record from a Location instance went from:
```func createCKRecordFrom(location: Location) -> CKRecord? {
        let venueRecord = CKRecord(recordType: "Location")
        venueRecord["displayName"] = venue.displayName as CKRecordValue
        venueRecord["id"] = venue.id as CKRecordValue
        venueRecord["billableRate"] = venue.billableRate as CKRecordValue
        venueRecord["isEnabled"] = venue.isEnabled as CKRecordValue
        if let address = venue.address {
            venueRecord["address"] = address as CKRecordValue
        }
        if let city = venue.city {
            venueRecord["city"] = city as CKRecordValue
        }
        if let state = venue.state {
            venueRecord["state"] = state as CKRecordValue
        }
        if let zipCode = venue.zipCode {
            venueRecord["zipCode"] = zipCode as CKRecordValue
        }
        return venueRecord
```  
  
  
to  

```func makeCKRecordFrom(location: Location) -> CKRecord {
    let locationRecord = CKRecord(recordType: location.identifier)
    location.propertyNames().flatMap { locationRecord[$0] = location.value(forKey: $0) as? CKRecordValue }
    return locationRecord
}
```  
Concise and accurate.  
**NOTE:** value(forKey:) on line 54 works because Location conforms to NSObject (for NSCoding purposes.)
