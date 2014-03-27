require 'csv'
Dir.glob("#{Rails.root}/app/models/*.rb").each { |file| require file }

ActiveRecord::Base.descendants.each do |model|
  filename = "#{Rails.root}/db/csv/#{model.to_s.tableize}.csv"
  if File.exist?(filename)
    CSV.foreach(filename, :headers => true) do |row|
      attrs = {}
      row.to_hash.each do |k,v|
        if k =~ /.*\:file/
          attrs[k.split(':')[0]] = File.open("#{Rails.root}/lib/assets/seeds/#{v}")
        else
          attrs[k] = v
        end
      end
      model.create!(attrs.to_hash.symbolize_keys)
    end
    ActiveRecord::Base.connection.reset_pk_sequence!(model.to_s.tableize)
  end
end
