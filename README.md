# Generic Game Model

The Generic Game Model (GGM) project seeks to provide relatively simple classes to facilitate easy creation of 2D games for iOS, primarily using `UIKit`. GGM classes (`GGM_BaseModel` and `GGM_UIView` for example) should not generally be instantiated directly, but rather sublcassed by your project to meet your specific needs.


## Installation / Requirements

GenericGameModel is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "GenericGameModel"

If you don't want to use CocoaPods, you may instead simply copy all the files in the GenericGameModel/ folder into your project, but note that there is one requirement, the excellent BaseModel class by Nick Lockwood, which you may find here: https://github.com/nicklockwood/BaseModel


## Usage

To run the example project; clone the repo, and run `pod install` from the Example directory first.

Generally speaking, you should subclass `GGM_BaseModel` and `GGM_UIView`. See the example project.


## Author

Martin Grider -- http://chesstris.com -- http://twitter.com/livingtech


## License

GenericGameModel is available under the MIT license. See the LICENSE file for more info.


# CHANGELOG

Unfortunately, the first few versions of this library pretty regularly broke the previous API. Additionally, they weren't using the propper semantic versioning.

## 4.0.3

Added support for Apple TV to the podspec.

## 4.0.0

Added `GGM_UIView+Hexagons` category. Made the `GGM_UIView` `shouldDragContinuous` property a little more automagical. (You can uncomment a line in `GGMEx_ViewController` to test it out.) Very minor API changes, but enough to bump the version, probably.

## 3.1.1

Added less weird hex grid type `GGM_GRIDTYPE_HEX_SQUARE`.

## 3.0.0 (tag 0.0.3)

Added support for triangular grids. More API changes.

## 2.0.0 (tag 0.0.2)

Added support for hex grids. Various refactoring (apologies).

## 0.1.0 (tag 0.0.1)

Initial release.
