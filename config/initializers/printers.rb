configuration_file = YAML.load(File.open(File.expand_path("../../printers.yml", __FILE__)))

queues = configuration_file.inject({}) do |memo, (k, v)|
  memo.merge(k => v[:queue])
end

printers = configuration_file.inject([]) do |memo, (k, v)|
  memo << k
end

$printers = printers
$queues = queues
