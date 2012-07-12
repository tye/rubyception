# This compiles haml templates into a json object and writes it to
# the file app/javascripts/template.js. Its so we can render html
# via javascript.

class Rubyception::Templating
  def self.r partial
    t = TemplatingController.new
    t.r partial
  end


  def self.append_to_tree template, current
    keys  = current.split('/').collect{|k|"['#{k}']"}.join
    partials = {}
    template.each_index do |i|
      partials[template[i]] = self.r("#{current}/#{template[i]}")
    end
    eval "@@templates#{keys} = partials"
  end

  def self.process_tree template, key=nil, current=''
    path = "#{current}/#{key}"
    path = key.to_s if current == ''
    kind = template.class.to_s
    case kind
    when 'Hash'
      template.each do |k,v|
        self.process_tree v, k, path
      end
    when 'Array'
      self.append_to_tree template, path
    end
  end

  def self.compile
    yml            = Rails.root.join 'config','templating.yml'
    file           = File.open yml
    templates      = YAML::load file
    @@templates    = templates
    self.process_tree templates
    js   = "Template = #{@@templates.to_json}"
    path = Rails.root.join 'app','assets','javascripts','template.js'
    File.open(path,'w'){|f|f.write(js)}
  end

end
