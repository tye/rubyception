module Rubyception
  filename = Rubyception::Engine.root.join 'config', 'templates.yml'
  yaml = File.read filename
  TEMPLATES = YAML.load yaml
end
