# Generic Game Model

The Generic Game Model (GGM) project seeks to provide relatively simple classes to facilitate easy creation of 2D games for iOS. GGM classes (`GGM_BaseModel` and `GGM_View` for example) should not generally be instantiated directly, but rather sublcassed by your project to meet your specific needs.

[![Version](http://cocoapod-badges.herokuapp.com/v/GenericGameModel/badge.png)](http://cocoadocs.org/docsets/GenericGameModel)
[![Platform](http://cocoapod-badges.herokuapp.com/p/GenericGameModel/badge.png)](http://cocoadocs.org/docsets/GenericGameModel)


## Installation / Requirements

GenericGameModel is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "GenericGameModel"

If you don't want to use Cocoapods, you may instead simply copy all the files in the GenericGameModel/ folder into your project, but note that there is one requirement, the excellent BaseModel class by Nick Lockwood, which you may find here: https://github.com/nicklockwood/BaseModel


## Usage

To run the example project; clone the repo, and run `pod install` from the Example directory first.

Generally speaking, you should subclass `GGM_BaseModel` and `GGM_View` (or any of its subclasses). See the example project.


## Author

Martin Grider -- http://chesstris.com -- http://twitter.com/livingtech


## License

GenericGameModel is available under the MIT license. See the LICENSE file for more info.


# CHANGELOG

Unfortunately, the first few versions of this library pretty regularly broke the previous API. Additionally, they weren't using the propper semantic versioning.

## 3.0.0 (tag 3.0.0)

Added support for triangular grids. More API changes.

## 2.0.0 (tag 0.0.2)

Added support for hex grids. Various refactoring (apologies).

## 0.1.0 (tag 0.0.1)

Initial release.
