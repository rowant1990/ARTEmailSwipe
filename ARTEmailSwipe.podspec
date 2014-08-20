Pod::Spec.new do |s|
  
  s.name         = "ARTEmailSwipe"
  s.version      = "1.0.0"
  s.summary      = "Simple library to handle Touch ID verfification"
  s.homepage     = "https://github.com/rowant1990/ARTEmailSwipe"
  s.license      = { :type => 'MIT', :text => 'Copyright 2014. Rowan Townshend. This library is distributed under the terms of the MIT/X11.' }
  s.author             = { "Rowan Townshend" => "rowan.townshend@degree53.com" }
  s.platform = :ios, '6.0'
  s.source       = { :git => "https://github.com/rowant1990/ARTEmailSwipe.git", :tag => "1.0.0" }
  s.source_files  = "ARTEmailSwipe/*.{h,m}"
  s.requires_arc          = true

end