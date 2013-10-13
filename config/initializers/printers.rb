configuration_file = YAML.load(File.open(File.expand_path("../../printers.yml", __FILE__)))

printers = configuration_file.inject([]) do |memo, (k, v)|
  memo << k
end

printernames = configuration_file.inject({}) do |memo, (k, v)|
  memo.merge(k => v[:id])
end

$printers = printers
$printernames = printernames
