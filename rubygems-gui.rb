require 'rubygems'
require 'sinatra'
require 'haml'

get '/' do
  "Gem GUI"
  @gems = []
  current_gem = nil
  can_has_description = false
  `gem list -d`.split("\n").each do |line| 
    if line==''
      can_has_description = true
    elsif line[0,1] != ' '
      data = line.match(/([^\s]+) \(([^)]+)\)/)
      current_gem = {
        :title => data[1], 
        :versions => data[2].split(', ').sort do |a,b| 
          a_s = a.split '.'
          b_s = b.split '.'
          res = 0.upto([a_s.length,b_s.length].min-1).inject(nil) do |res, pos|
            if a_s[pos].to_i>b_s[pos].to_i
              res ||= 1
            elsif a_s[pos].to_i<b_s[pos].to_i
              res ||= -1
            end
            res
          end
          res || a_s.length <=> b_s.length
        end,
        :description => '',
      }
      can_has_description = false
      @gems << current_gem
    elsif can_has_description
      current_gem[:description] += ' ' + line.strip
    else
      name, value = line.strip.split(': ',2)
      current_gem[name.downcase.to_sym] = value
    end
  end
  @gems.sort! {|a,b| a[:title].downcase <=> b[:title].downcase}

  Haml::Engine.new(File.read('index.haml')).render(self)
end

post '/uninstall' do 
  gems = params[:gems].map do |title| 
    data = title.match(/^(.+)-([\d.]+)$/)
    data.nil? ? title : data[1]+' --version '+data[2]
  end
  responses = []
  gems.each do |gem|
    responses << '<pre>'+`sudo /opt/ruby-enterprise/bin/gem uninstall --ignore-dependencies #{gem}`+'</pre>'
  end
  responses.join '<hr>'
end
