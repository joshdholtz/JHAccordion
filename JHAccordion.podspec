#
# To learn more about the attributes see http://docs.cocoapods.org/specification.html
#
Pod::Spec.new do |s|
  s.name         = "JHAccordion"
  s.version      = "0.1.1"
  s.summary      = "An Accordion UI."
  spec.homepage  = "https://github.com/SpotHopperLLC/JHAccordion"
  s.license      = 'MIT'
  s.author       = { "Josh Holtz" => "josh@rokkincat.com" }
  s.source       = { :git => "https://github.com/SpotHopperLLC/JHAccordion.git", :tag => s.version.to_s }
  s.requires_arc = true
  s.source_files = 'Classes'
  s.resources = 'Assets'

  s.ios.exclude_files = 'Classes/osx'
  s.osx.exclude_files = 'Classes/ios'
end
