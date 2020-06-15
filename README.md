![Logo](Resources/logo.png)

# AttributedString - 基于Swift插值方式优雅的构建富文本

[![](https://img.shields.io/cocoapods/l/AttributedString.svg)](LICENSE)&nbsp;
![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)

## [天朝子民](README_CN.md)

## Features

- [x] Constructing rich text using interpolation, Smooth coding, Elegant and natural style.
- [x] More control extension support.
- [x] Support for multi-level rich text cascading and provide other style priority strategies.
- [x] Support for all `NSAttributedString.Key` functions.
- [x] Support iOS & macOS & watchOS & tvOS.
- [x] Support text and attachment click event callback.
- [x] Continue to add more new features.

## Screenshot

<img src="Resources/simple.png" alt="Simple" width="80%" />

<img src="Resources/coding.gif" alt="Coding" width="80%" />

<div align="center">
<img src="Resources/all.png" alt="All" width="40%" />
<img src="Resources/font.png" alt="Font" width="40%" />
</div>


<div align="center">
<img src="Resources/kern.png" alt="Kern" width="40%" />
<img src="Resources/stroke.png" alt="Stroke" width="40%" />
</div>


## Installation

#### CocoaPods - Podfile

```ruby
pod 'AttributedString'
```

#### Carthage - Cartfile

```ruby
github "lixiang1994/AttributedString"
```

#### [Swift Package Manager for Apple platforms](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app)

Select Xcode menu `File > Swift Packages > Add Package Dependency` and enter repository URL with GUI.  
```
Repository: https://github.com/lixiang1994/AttributedString
```

#### [Swift Package Manager](https://swift.org/package-manager/)

Add the following to the dependencies of your `Package.swift`:
```swift
.package(url: "https://github.com/lixiang1994/AttributedString.git", from: "version")
```


## Usage

First make sure to import the framework:

```swift
import AttributedString
```



How to initialize:

```swift
// Normal
let a: AttributedString = .init("lee", .font(.systemFont(ofSize: 13)))
// Interpolation
let b: AttributedString = "\("lee", .font(.systemFont(ofSize: 13)))"
```



Here are some usage examples. All devices are also available as simulators:


#### Font:

```swift
textView.attributed.text = """

\("fontSize: 13", .font(.systemFont(ofSize: 13)))

\("fontSize: 20", .font(.systemFont(ofSize: 20)))

\("fontSize: 22 weight: semibold", .font(.systemFont(ofSize: 22, weight: .semibold)))

"""
```

#### ForegroundColor:

```swift
textView.attributed.text = """

\("foregroundColor", .color(.white))

\("foregroundColor", .color(.red))

"""
```

#### Strikethrough: 

```swift
textView.attributed.text = """

\("strikethrough: single", .strikethrough(.single))

\("strikethrough: double color: .red", .strikethrough(.double, color: .red))

"""
```

#### Image:	(Does not include watchOS)

```swift
textView.attributed.text = """

\(.image(UIImage(named: "xxxx")))

\(.image(UIImage(named: "xxxx"), .custom(size: .init(width: 200, height: 200))))

\(.image(UIImage(named: "xxxx"), .proposed(.center))).

"""
```

#### Wrap:

```swift
let a: AttributedString = .init("123", .background(.blue))
let b: AttributedString = .init("456", .background(.red))
textView.attributed.text = "\(wrap: a) \(wrap: b, .paragraph(.alignment(.center)))"

// Defalut embedding mode, Nested internal styles take precedence over external styles
textView.attributed.text = "\(wrap: a, .paragraph(.alignment(.center)))"
textView.attributed.text = "\(wrap: .embedding(a), .paragraph(.alignment(.center)))"
// Override mode, Nested outer style takes precedence over inner style
textView.attributed.text = "\(wrap: .override(a), .paragraph(.alignment(.center)))"
```

#### Append:

```swift
let a: AttributedString = .init("123", .background(.blue))
let b: AttributedString = .init("456", .background(.red))
let c: AttributedString = .init("789", .background(.gray))
textView.attributed.text = a + b
textView.attributed.text += c
```

#### Click:	(Only supports iOS: UILabel / UITextView & macOS: NSTextField)

```swift
// Text
let a: AttributedString = .init("lee", .action({  }))
// Attachment (image)
let b: AttributedString = .init(.image(image), action: {
    // code
})

// It is recommended to use functions as parameters.
func click() {
    // code
}
// Normal
let c: AttributedString = .init("lee", .action(click))
let d: AttributedString = .init(.image(image), action: click)
// Interpolation
let e: AttributedString = "\("lee", .action(click))"
let f: AttributedString = "\(.image(image), action: click)"

// More information. 
func click(_ action: AttributedString.Action) {
    switch action.content {
    case .string(let value):
       	print("Currently clicked text: \(value) range: \(action.range)")
				
    case .attachment(let value):
	print("Currently clicked attachment: \(value) range: \(action.range)")
    }
}

label.attributed.text = "This is \("Label", .font(.systemFont(ofSize: 20)), .action(click))"
textView.attributed.text = "This is a picture \(.image(image, .custom(size: .init(width: 100, height: 100))), action: click) Displayed in custom size."
```



For more examples, see the sample application.



## Properties available via `Attribute` class

The following properties are available:

| PROPERTY          | TYPE                                 | DESCRIPTION                                                  |
| ----------------- | ------------------------------------ | ------------------------------------------------------------ |
| font              | `UIFont`                             | font                                                         |
| color             | `UIColor`                            | foreground color                                             |
| background        | `UIColor`                            | background color                                             |
| paragraph         | `ParagraphStyle`                     | paragraph attributes                                         |
| ligature          | `Bool`                               | Ligatures cause specific character combinations to be rendered using a single custom glyph that corresponds to those characters |
| kern              | `CGFloat`                            | kerning                                                      |
| strikethrough     | `NSUnderlineStyle` . `UIColor`       | strikethrough style and color (if color is nil foreground is used) |
| underline         | `NSUnderlineStyle` , `UIColor`       | underline style and color (if color is nil foreground is used) |
| link              | `String` / `URL`                     | URL                                                          |
| baselineOffset    | `CGFloat`                            | character’s offset from the baseline, in point               |
| shadow            | `NSShadow`                           | shadow effect of the text                                    |
| stroke            | `CGFloat`, `UIColor`                 | stroke width and color                                       |
| textEffect        | `NSAttributedString.TextEffectStyle` | text effect                                                  |
| obliqueness       | `CGFloat`                            | text obliqueness                                             |
| expansion         | `CGFloat`                            | expansion / shrink                                           |
| writingDirection  | `WritingDirection` / `[Int]`         | initial writing direction used to determine the actual writing direction for text |
| verticalGlyphForm | `Bool`                               | vertical glyph (Currently on iOS, it's always horizontal.)   |




## Contributing

If you have the need for a specific feature that you want implemented or if you experienced a bug, please open an issue.
If you extended the functionality of AttributedString yourself and want others to use it too, please submit a pull request.


## License

AttributedString is under MIT license. See the [LICENSE](LICENSE) file for more info.
