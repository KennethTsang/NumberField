# NumberField

[![Version](https://img.shields.io/cocoapods/v/NumberField.svg?style=flat)](http://cocoapods.org/pods/NumberField)
[![License](https://img.shields.io/cocoapods/l/NumberField.svg?style=flat)](http://cocoapods.org/pods/NumberField)
[![Platform](https://img.shields.io/cocoapods/p/NumberField.svg?style=flat)](http://cocoapods.org/pods/NumberField)
[![Language](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)](http://cocoapods.org/pods/NumberField)

<img src="DEMO.png" border=1 style="border-color:#eeeeee">

## Requirements

iOS 9.0 or above

## Installation

#### CocoaPods

NumberField is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "NumberField"
```

## Usage

**Programmatically**<br>

```swift
let numberField = NumberField()
numberField.delegate = self
numberField.value = 123.45
addSubview(numberField)
```

**Storyboard**<br>

1. Drag an UIView into Storyboard.
2. Set class to "NumberField".

## NumberField Parameters

| Parameter       | Type                 | Description                              | Default  |
| --------------- | -------------------- | ---------------------------------------- | -------- |
| *value*         | Double               | Actual value.                            | *0*      |
| *maxValue*      | Double               | Maximum value.                           | *true*   |
| *decimalPlace*  | Int                  | Number of decimal place. 0 means integer. | *0*      |
| *font*          | UIFont               | Text Font.                               | -        |
| *textColor*     | UIColor              | Text Color.                              | *5.0*    |
| *textAlignment* | NumberFieldAlignment | Text Alignment. (.left / .right)         | *.right* |

#### Examples

```swift
numberField.textAlignment = .left
numberField.decimalPlace = 2
numberField.maxValue = 9999
```

## Delegate

```swift
class ViewController: UIViewController, NumberFieldDelegate {
    func numberFieldDidEndEditing(_ sender: NumberField, value: Double) {
	    ...
    }
    
    func numberFieldDidReceiveWrongInput(_ sender: NumberField) {
    	...
    }
    
    func numberFieldDidBeginEditing(_ sender: NumberField, value: Double) {
    	...
    }
}
```



## Author

Kenneth Tsang, kenneth.tsang@me.com

## License

NumberField is available under the MIT license. See the LICENSE file for more info.
