Pod::Spec.new do |s|

s.name         = "AttributedString"
s.version      = "2.2.0"
s.summary      = "基于Swift字符串插值快速构建你想要的富文本, 支持点击按住等事件获取, 支持多种类型过滤"

s.homepage     = "https://github.com/lixiang1994/AttributedString"

s.license      = { :type => "MIT", :file => "LICENSE" }

s.author       = { "LEE" => "18611401994@163.com" }

s.source       = { :git => "https://github.com/lixiang1994/AttributedString.git", :tag => s.version }

s.requires_arc = true

s.swift_versions = ["5.0"]

s.frameworks = "Foundation"
s.ios.frameworks = "UIKit"
s.osx.frameworks = "AppKit"
s.tvos.frameworks = "UIKit"
s.watchos.frameworks = "WatchKit"

s.ios.deployment_target = '9.0'
s.osx.deployment_target = "10.13"
s.tvos.deployment_target = "11.0"
s.watchos.deployment_target = "5.0"

s.source_files  = ["Sources/*.swift", "Sources/Extension/*.swift", "Sources/Extension/CoreGraphics/*.swift"]
s.ios.source_files = ["Sources/Extension/UIKit/*.swift", "Sources/Extension/UIKit/UILabel/*.swift"]
s.osx.source_files = ["Sources/Extension/AppKit/*.swift"]
s.tvos.source_files = ["Sources/Extension/UIKit/*.swift"]
s.watchos.source_files = ["Sources/Extension/WatchKit/*.swift"]

end
