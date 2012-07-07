# This compiles haml templates into a json object and writes it to
# the file app/javascripts/template.js. Its so we can render html
# via javascript.

class Templating
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
    current = current == '' ? current = key.to_s : current = current+"/#{key}"
    if template.is_a?(Hash)
      template.each{|k,v|self.process_tree(v,k,current)}
    elsif template.is_a?(Array)
      self.append_to_tree template, current
    end
  end

  def self.compile
    file           = File.open(Rails.root.join('config','templating.yml'))
    templates      = YAML::load file
    @@templates    = templates
    self.process_tree templates
    js   = "Template = #{@@templates.to_json}"
    path = Rails.root.join 'app','assets','javascripts','template.js'
    File.open(path,'w'){|f|f.write(js)}
  end

end
