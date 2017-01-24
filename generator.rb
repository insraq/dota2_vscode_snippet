require 'json'

text = File.open('items.txt').read

snippets = {}

# Build item snippets
text.each_line do |line|
  item = line.strip
  snippets[item] = {
    prefix: 'item_',
    body: item.strip,
    description: item.strip
  }
end

# f = File.open("npc_abilities.txt")

# current = nil
# f.read.each_line do |line|
#     stripped = line.strip
#     if stripped.start_with?('// Ability: ')
#         current = stripped
#     elsif current && stripped.start_with?('"')
#         key = stripped[1..-2]
#         snippets[key] = {
#             prefix: key.split('_')[0],
#             body: key,
#             description: current[2..-1].strip
#         }
#         current = nil
#     end
# end

f = File.open('npc_heroes.txt')

f.read.each_line do |line|
  stripped = line.strip
  next unless stripped.start_with?('"npc_dota_hero')
  key = stripped[1..-2]
  snippets[key] = {
    prefix: 'npc_dota_hero',
    body: key,
    description: key
  }
end

f = File.open('bot_functions.txt')
current = nil
f.read.each_line do |line|
  stripped = line.strip
  if stripped.include?(':')
    current = stripped
    next
  end
  next if current.nil?
  snippets[current] = {
    prefix: ":#{current.split(/(?=[A-Z])/)[0]}",
    body: current,
    description: "#{current}\n#{stripped}"
  }
  current = nil
end

f = File.open('global_functions.txt')
current = nil
f.read.each_line do |line|
  stripped = line.strip
  if stripped.include?(':')
    current = stripped
    next
  end
  next if current.nil?
  snippets[current] = {
    prefix: current.split(/(?=[A-Z])/)[0],
    body: current,
    description: "#{current}\n#{stripped}"
  }
  current = nil
end

f = File.open('enums.txt')
f.read.each_line do |line|
  stripped = line.strip
  next if stripped == ''
  key = stripped.split('=')[0].strip
  snippets[key] = {
    prefix: stripped.split('_')[0],
    body: key,
    description: stripped
  }
end

File.open('snippets.json', 'w') { |f| f.write(snippets.to_json) }
puts 'Done. checks snippets.json'
