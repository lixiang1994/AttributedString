AttributedString - 基于Swift插值方式优雅的构建富文本

[![](https://img.shields.io/cocoapods/l/AttributedString.svg)](LICENSE)&nbsp;
![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)


## 特性

- [x] 使用插值构建富文本 流畅的编码体验 优雅自然的样式设置.
- [x] 丰富的控件扩展支持.
- [x] 支持多层富文本嵌套并提供嵌套样式优先级策略.
- [x] 支持全部`NSAttributedString.Key`特性
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

**CocoaPods - Podfile**

```ruby
pod 'AttributedString'
```

**Carthage - Cartfile**

```ruby
github "lixiang1994/AttributedString"
```

## 使用

首先导入

```swift
import AttributedString
```

下面是一些简单示例. 支持所有设备和模拟器:


#### 字体:

```swift
textView.attributed.string = """

\("fontSize: 13", .font(.systemFont(ofSize: 13)))

\("fontSize: 20", .font(.systemFont(ofSize: 20)))

\("fontSize: 22 weight: semibold", .font(.systemFont(ofSize: 22, weight: .semibold)))

"""
```

#### 字色:

```swift
textView.attributed.string = """

\("foregroundColor", .color(.white))

\("foregroundColor", .color(.red))

"""
```

#### 删除线: 

```swift
textView.attributed.string = """

\("strikethrough: single", .strikethrough(.single))

\("strikethrough: double color: .red", .strikethrough(.double, color: .red))

"""
```

#### 图片:

```swift
textView.attributed.string = """

\(.image(UIImage(named: "xxxx")))

\(.image(UIImage(named: "xxxx"), .custom(size: .init(width: 200, height: 200))))

\(.image(UIImage(named: "xxxx"), .proposed(.center))).

"""
```

更多示例请查看工程应用.



## 通过`Style`类提供的属性

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




## 贡献

如果您需要实现特定功能或遇到错误，请打开issue。
如果您自己扩展了AttributedString的功能并希望其他人也使用它，请提交拉取请求。

## 协议

AttributedString 使用 MIT 协议. 有关更多信息，请参阅[LICENSE](LICENSE)文件.
