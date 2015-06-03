Pod::Spec.new do |s|
  s.name         = "SFEventView"
  s.version      = "0.1"
  s.summary      = "SFEventView"
  s.description  = "SFEventView is a view like shareView in some app"
  s.homepage     = "https://github.com/shiweifu/SFEventView"
  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "shiweifu" => "shiweifu@gmail.com" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/shiweifu/SFTagView.git", :tag => "0.1" }
  s.source_files  = "SFEventView/SFEventView.{h,m}"
  s.requires_arc = true
  s.dependency "SSDataSources"
end
