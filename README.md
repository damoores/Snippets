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
  
    
In my TimeClock app, creating a CloudKit Record from a Shift instance went from:
```func makeCKRecordFrom(shift: Shift) {
    let shiftRecord = CKRecord(recordType: "Shift")
    shiftRecord["employeeName"] = shift.employeeName as CKRecordValue?
    shiftRecord["employeeId"] = shift.employeeId as CKRecordValue?
    shiftRecord["venueName"] = shift.venueName as CKRecordValue?
    shiftRecord["venueId"] = shift.venueId as CKRecordValue?
    shiftRecord["startTime"] = shift.startTime as CKRecordValue?
    shiftRecord["endTime"] = shift.endTime as CKRecordValue?
    shiftRecord["comments"] = shift.comments as CKRecordValue?
    shiftRecord["isUploadedToIntuit"] = shift.isUploadedToIntuit as CKRecordValue?
    shiftRecord["shiftRecordID"] = shift.shiftRecordID as CKRecordValue?
    
    return shiftRecord
}
```  
  
  
to  

```func makeCKRecordFrom(shift: Shift) -> CKRecord {
    let shiftRecord = CKRecord(recordType: shift.identifier)
    shift.propertyNames().flatMap { shiftRecord[$0] = shift.value(forKey: $0) as? CKRecordValue }
    return shiftRecord
}
```  
Concise and accurate.

