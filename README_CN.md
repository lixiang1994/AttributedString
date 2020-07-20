![Logo](Resources/logo.png)

AttributedString - 基于Swift插值方式优雅的构建富文本

[![License](https://img.shields.io/cocoapods/l/AttributedString.svg)](LICENSE)&nbsp;
![Swift](https://img.shields.io/badge/Swift-5.2-orange.svg)&nbsp;
![Platform](https://img.shields.io/cocoapods/p/AttributedString.svg?style=flat)&nbsp;
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-4BC51D.svg?style=flat")](https://swift.org/package-manager/)&nbsp;
[![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Cocoapods](https://img.shields.io/cocoapods/v/AttributedString.svg)](https://cocoapods.org)&nbsp;

## 特性

- [x] 使用插值构建富文本 流畅的编码体验 优雅自然的样式设置.
- [x] 丰富的控件扩展支持.
- [x] 支持多层富文本嵌套并提供嵌套样式优先级策略.
- [x] 支持全部`NSAttributedString.Key`特性.
- [x] 支持 iOS & macOS & watchOS & tvOS.
- [x] 支持文本和附件点击或长按事件回调, 支持高亮样式.
- [x] 支持视图附件, 可以将自定义视图通过富文本添加到`UITextView`中.
- [x] 更多新特性的不断加入.


## 截屏

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


## 安装

#### CocoaPods - Podfile

```ruby
pod 'AttributedString'
```

#### Carthage - Cartfile

```ruby
github "lixiang1994/AttributedString"
```

#### [Swift Package Manager for Apple platforms](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app)

选择 Xcode 菜单 `File > Swift Packages > Add Package Dependency` 输入仓库地址.  
```
Repository: https://github.com/lixiang1994/AttributedString
```

#### [Swift Package Manager](https://swift.org/package-manager/)

将以下内容添加到你的 `Package.swift`:
```swift
.package(url: "https://github.com/lixiang1994/AttributedString.git", from: "version")
```


## 使用

首先导入

```swift
import AttributedString
```



初始化

```swift
// 常规初始化
let a: AttributedString = .init("lee", .font(.systemFont(ofSize: 13)))
// 插值初始化
let b: AttributedString = "\("lee", .font(.systemFont(ofSize: 13)))"
```



下面是一些简单示例. 支持所有设备和模拟器:


#### 字体:

```swift
textView.attributed.text = """

\("fontSize: 13", .font(.systemFont(ofSize: 13)))

\("fontSize: 20", .font(.systemFont(ofSize: 20)))

\("fontSize: 22 weight: semibold", .font(.systemFont(ofSize: 22, weight: .semibold)))

"""
```

#### 字色:

```swift
textView.attributed.text = """

\("foregroundColor", .foreground(.white))

\("foregroundColor", .foreground(.red))

"""
```

#### 删除线: 

```swift
textView.attributed.text = """

\("strikethrough: single", .strikethrough(.single))

\("strikethrough: double color: .red", .strikethrough(.double, color: .red))

"""
```

#### 附件: (不包括 watchOS)

```swift
// AttributedString.Attachment

textView.attributed.text = """

\(.data(xxxx, type: "zip"))

\(.file(try!.init(url: .init(fileURLWithPath: "xxxxx"), options: [])))

\(.attachment(NSTextAttachment()))

"""
```

#### 附件 图片: (不包括 watchOS)

```swift
// AttributedString.ImageAttachment

textView.attributed.text = """

\(.image(UIImage(named: "xxxx")))

\(.image(UIImage(named: "xxxx"), .custom(size: .init(width: 200, height: 200))))

\(.image(UIImage(named: "xxxx"), .proposed(.center))).

"""
```

#### 附件 视图: (仅支持 iOS: UITextView)

```swift
// AttributedString.ViewAttachment

textView.attributed.text = """

\(.view(xxxxView))

\(.view(xxxxView, .custom(size: .init(width: 200, height: 200))))

\(.view(xxxxView, .proposed(.center))).

"""
```

#### 包装:

```swift
let a: AttributedString = .init("123", .background(.blue))
let b: AttributedString = .init("456", .background(.red))
textView.attributed.text = "\(wrap: a) \(wrap: b, .paragraph(.alignment(.center)))"

// 默认为嵌入模式, 嵌套的内部样式优先于外部样式
textView.attributed.text = "\(wrap: a, .paragraph(.alignment(.center)))"
textView.attributed.text = "\(wrap: .embedding(a), .paragraph(.alignment(.center)))"
// 覆盖模式, 嵌套的外部样式优先于内部样式
textView.attributed.text = "\(wrap: .override(a), .paragraph(.alignment(.center)))"
```

#### 拼接:

```swift
let a: AttributedString = .init("123", .background(.blue))
let b: AttributedString = .init("456", .background(.red))
let c: AttributedString = .init("789", .background(.gray))
textView.attributed.text = a + b
textView.attributed.text += c
```

#### 检查:

```swift
var string: AttributedString = .init("我的电话号码是+86 18611401994.", .background(.blue))
string.add(attributes: [.foreground(color)], checkings: [.phoneNumber])
textView.attributed.text = string
```

```swift
var string: AttributedString = .init("打开 https://www.apple.com 和 https://github.com/lixiang1994/AttributedString", .background(.blue))
string.add(attributes: [.foreground(color)], checkings: [.link])
textView.attributed.text = string
```

```swift
var string: AttributedString = .init("123456789", .background(.blue))
string.add(attributes: [.foreground(color)], checkings: [.regex("[0-6]")])
textView.attributed.text = string
```

#### 动作: (仅支持 iOS: UILabel / UITextView 和 macOS: NSTextField)

##### 点击:    

```swift
// 文本
let a: AttributedString = .init("lee", .action({  }))
// 附件 (图片)
let b: AttributedString = .init(.image(image), action: {
    // code
})

// 建议使用函数作为参数 语法上比直接使用闭包更加整洁.
func clicked() {
    // code
}
// 正常初始化
let c: AttributedString = .init("lee", .action(clicked))
let d: AttributedString = .init(.image(image), action: clicked)
// 字面量初始化
let e: AttributedString = "\("lee", .action(clicked))"
let f: AttributedString = "\(.image(image), action: clicked)"

// 获取更多信息 
func clicked(_ result: AttributedString.Action.Result) {
    switch result.content {
    case .string(let value):
        print("点击了文本: \(value) range: \(result.range)")
                
    case .attachment(let value):
        print("点击了附件: \(value) range: \(result.range)")
    }
}

label.attributed.text = "This is \("Label", .font(.systemFont(ofSize: 20)), .action(clicked))"
textView.attributed.text = "This is a picture \(.image(image, .custom(size: .init(width: 100, height: 100))), action: clicked) Displayed in custom size."
```

##### 按住:  

```swift
func pressed(_ result: AttributedString.Action.Result) {
    switch result.content {
    case .string(let value):
        print("按住了文本: \(value) range: \(result.range)")
                
    case .attachment(let value):
        print("按住了附件: \(value) range: \(result.range)")
    }
}

label.attributed.text = "This is \("Long Press", .font(.systemFont(ofSize: 20)), .action(.press, pressed))"
textView.attributed.text = "This is a picture \(.image(image, .custom(size: .init(width: 100, height: 100))), trigger: .press, action: pressed) Displayed in custom size."
```

##### 高亮样式:    

```swift
func clicked(_ result: AttributedString.Action.Result) {
    switch result.content {
    case .string(let value):
        print("点击了文本: \(value) range: \(result.range)")
                
    case .attachment(let value):
        print("点击了附件: \(value) range: \(result.range)")
    }
}

label.attributed.text = "This is \("Label", .font(.systemFont(ofSize: 20)), .action([.foreground(.blue)], clicked))"
```

##### 自定义: 

```swift
// 触发方式为 按住, 高亮样式为 蓝色背景色和白色文字
let custom = AttributedString.Action(.press, highlights: [.background(.blue), .foreground(.white)]) { (result) in
    switch result.content {
    case .string(let value):
        print("按住了文本: \(value) range: \(result.range)")
        
    case .attachment(let value):
        print("按住了附件: \(value) range: \(result.range)")
    }
}

label.attributed.text = "This is \("Custom", .font(.systemFont(ofSize: 20)), .action(custom))"
textView.attributed.text = "This is a picture \(.image(image, .original(.center)), action: custom) Displayed in original size."
```

#### 监听: (仅支持 iOS: UILabel / UITextView 和 macOS: NSTextField)

```swift
// 监听 电话号码类型的点击事件 并设置点击时高亮样式为蓝色字体
label.attributed.observe([.phoneNumber], highlights: [.foreground(.blue)]) { (result) in
    print("当前点击了 \(result)")
}

// 监听 链接和时间类型的点击事件 并设置点击时高亮样式为蓝色字体
textView.attributed.observe([.link, .date], highlights: [.foreground(.blue)]) { (result) in
    print("当前点击了 \(result)")
}
```

更多示例请查看工程应用.



## 通过`Attribute`类提供的属性

以下属性可用：

| 属性              | 类型                                 | 描述                                         |
| ----------------- | ------------------------------------ | -------------------------------------------- |
| font              | `UIFont`                             | 字体                                         |
| color             | `UIColor`                            | 字色                                         |
| background        | `UIColor`                            | 背景色                                       |
| paragraph         | `ParagraphStyle`                     | 段落样式                                     |
| ligature          | `Bool`                               | 连体字                                       |
| kern              | `CGFloat`                            | 字间距                                       |
| strikethrough     | `NSUnderlineStyle` . `UIColor`       | 删除线样式与颜色 (如果颜色为空 则和字色一致) |
| underline         | `NSUnderlineStyle` , `UIColor`       | 下划线样式与颜色 (如果颜色为空 则和字色一致) |
| link              | `String` / `URL`                     | 链接                                         |
| baselineOffset    | `CGFloat`                            | 基准线偏移                                   |
| shadow            | `NSShadow`                           | 阴影                                         |
| stroke            | `CGFloat`, `UIColor`                 | 描线宽度与颜色                               |
| textEffect        | `NSAttributedString.TextEffectStyle` | 文本效果                                     |
| obliqueness       | `CGFloat`                            | 斜体                                         |
| expansion         | `CGFloat`                            | 拉伸/压缩                                    |
| writingDirection  | `WritingDirection` / `[Int]`         | 书写方式                                     |
| verticalGlyphForm | `Bool`                               | 垂直排版 (当前在iOS上, 它始终是水平的)       |


## 通过`Attribute.Checking`枚举提供的Case

| CASE                                 | 描述                                         |
| ------------------------------------ | -------------------------------------------- |
| `range(NSRange)`                              | 自定义范围                                                         |
| `regex(String)`                                    | 正则表达式                                                         |
| `action`                                                | 动作                                                                    |
| `date`                                                   | 时间 (基于`NSDataDetector`)                         |
| `link`                                                     | 链接 (基于`NSDataDetector`)                         |
| `address`                                             | 地址 (基于`NSDataDetector`)                         |
| `phoneNumber`                                  | 电话 (基于`NSDataDetector`)                         |
| `transitInformation`                            | 航班 (基于`NSDataDetector`)                         |


## 贡献

如果您需要实现特定功能或遇到错误，请打开issue。
如果您自己扩展了AttributedString的功能并希望其他人也使用它，请提交拉取请求。

## 协议

AttributedString 使用 MIT 协议. 有关更多信息，请参阅[LICENSE](LICENSE)文件.
