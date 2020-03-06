Pod::Spec.new do |s|

s.name         = "AttributedString"
s.version      = "1.1.2"
s.summary      = "基于Swift字符串插值快速构建你想要的富文本"

s.homepage     = "https://github.com/lixiang1994/AttributedString"

s.license      = { :type => "MIT", :file => "LICENSE" }

s.author       = { "LEE" => "18611401994@163.com" }

s.platform     = :ios, "9.0"

s.source       = { :git => "https://github.com/lixiang1994/AttributedString.git", :tag => s.version }

s.source_files  = "Sources/**/*.swift"

s.requires_arc = true

s.frameworks = "UIKit", "Foundation"

s.swift_versions = ["5.0"]

end
