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

**CocoaPods - Podfile**

```ruby
pod 'AttributedString'
```

**Carthage - Cartfile**

```ruby
github "lixiang1994/AttributedString"
```

## Usage

First make sure to import the framework:

```swift
import AttributedString
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

#### Image:

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



## Properties available via `Style` class

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
