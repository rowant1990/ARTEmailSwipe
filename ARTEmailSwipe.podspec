Pod::Spec.new do |s|
  
  s.name         = "ARTEmailSwipe"
  s.version      = "1.0.2"
  s.summary      = "ARTEmailSwipe is a container class mimicking the new emails implementation in iOS8."
  s.homepage     = "https://github.com/rowant1990/ARTEmailSwipe"
  s.license      = { :type => 'MIT', :text => 'Copyright 2014. Rowan Townshend. This library is distributed under the terms of the MIT/X11.' }
  s.author             = { "Rowan Townshend" => "rowan.townshend@degree53.com" }
  s.platform = :ios, '6.0'
  s.source       = { :git => "https://github.com/rowant1990/ARTEmailSwipe.git", :tag => "1.0.2" }
  s.source_files  = "ARTEmailSwipe/*.{h,m}"
  s.requires_arc          = true

end