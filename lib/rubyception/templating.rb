# This compiles haml templates into a json object and writes it to
# the file app/javascripts/template.js. Its so we can render html
# via javascript.

class Rubyception::Templating
  def self.r partial
    t = Rubyception::TemplatingController.new
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
        if v.nil?
          self.append_to_tree [k], path
        else
          self.process_tree v, k, path
        end
      end
    when 'Array'
      self.append_to_tree template, path
    end
  end

  def self.compile
    yml            = File.join(File.dirname(__FILE__),'..','..','config','templating.yml')
    file           = File.open yml
    templates      = YAML::load file
    @@templates    = templates
    self.process_tree templates
    js   = "Template = #{@@templates.to_json}"
    path = File.join(File.dirname(__FILE__),'..','..','app','assets','javascripts','rubyception','template.js')
    File.open(path,'w'){|f|f.write(js)}
  end
end
