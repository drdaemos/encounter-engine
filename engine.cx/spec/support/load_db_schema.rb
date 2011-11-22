def load_db_schema
  load_schema = lambda do
    ["schema.rb", "seeds.rb"].each { |file| load Rails.root.join("db", file) }
  end
  silence_stream(STDOUT, &load_schema)
end
