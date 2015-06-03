Pod::Spec.new do |s|
  s.name          = "SFEventView"
  s.version       = "0.2"
  s.summary       = "SFEventView"
  s.description   = "SFEventView is a view like shareView in some app"
  s.homepage      = "https://github.com/shiweifu/SFEventView"
  s.license       = "MIT"
  s.author        = { "shiweifu" => "shiweifu@gmail.com" }
  s.platform      = :ios, '7.0'
  s.source        = { :git => "https://github.com/shiweifu/SFEventView.git", :tag => "0.2" }
  s.source_files  = "SFEventView/SFEventView.{h,m}"
  s.requires_arc = true
  s.dependency "SSDataSources"
end

