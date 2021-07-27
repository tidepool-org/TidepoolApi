#!/usr/bin/env ruby
require 'pathname'
require 'json'
require 'yaml'

ROOT_DIR = File.join(File.dirname(__FILE__), '..')
CONFIG_FILE = File.join(ROOT_DIR, '.stoplight.json')

def get_config(root_dir)
    File.open(CONFIG_FILE) { |config| JSON::parse(config.read) }
end

class Array
    def to_toc(root_dir = nil)
        map { |i| i.to_toc(root_dir) }
    end
end

class TableEntry
    include Comparable
    attr_reader :title
    
    def initialize(title)
        @title = title
    end

    def <=>(other)
        @title <=> other.title
    end
    
    def to_toc
        raise 'not implemented'
    end
end

class Divider < TableEntry
    def to_toc(root_dir = nil)
        {
            type: "divider",
            title: @title,
        }
    end
end

class Item < TableEntry
    attr_reader :path

    def initialize(title, path)
        super(title)
        @path = path
    end

    def to_toc(root_dir = nil)
        {
            type: "item",
            title: @title,
            uri: root_dir.nil? ? @path : Pathname.new(@path).relative_path_from(root_dir),
        }
    end
end

class Group < TableEntry
    attr_reader :items

    def initialize(title, items = [ ])
        super(title)
        @items = items
    end

    def <<(item)
        @items << item
        self
    end

    def sort!
        @items.sort!
        self
    end

    def to_toc(root_dir = nil)
        {
            type: "group",
            title: @title,
            items: @items.to_toc(root_dir),
        }
    end
end

class Table
    attr_reader :items

    def initialize(items = [ ])
        @items = items
    end

    def <<(item)
        @items << item
        self
    end

    def to_toc(root_dir = nil)
        {
            items: @items.to_toc(root_dir),
        }
    end    
end

def get_title_from_md(file)
    File.open(file) do |f|
        f.each_line do |line|
            # Look for the first H1
            if line =~ /^#\s+(.+)$/
                return $1.chomp.strip
            end
        end
    end
    nil
end

def get_title_from_yaml(file)
    yaml = YAML::load_file(file)
    return yaml['title'] if yaml['info'].nil?
    yaml['info']['title']
end

def get_subdocs(file)
    title = get_title_from_md(file)

    # are there subfolders with the same name?
    path = file.gsub(/\.md/, '')
    if File.exists?(path) and File.directory?(path)
        # if so, make this a group with that file as "Overview"
        overview = Item.new('Overview', file)

        # recursively find all subdocs
        subdocs = Dir[File.join(path, '*.md')].map { |doc| get_subdocs(doc) }

        Group.new(title, [ overview, *subdocs.sort! ])
    else
        # make this a single item with that file as only item
        Item.new(title, file)
    end
end

def get_docs(root_dir)
    docs = [ ]
    docs_path = File.join(root_dir, get_config(root_dir)['formats']['markdown']['rootDir'])
    Dir[File.join(docs_path, '*.md')].each do |file|
        docs << get_subdocs(file)
    end
    docs.sort!
end

def get_operations(file)
    operations = Group.new('Operations')
    yaml = YAML::load_file(file)
    yaml['paths'].each do |path, ops|
        %w[ get post put delete patch options head ].each do |method|
            if ops[method]
                operations << Item.new(ops[method]['summary'], "#{file}\##{ops[method]['operationId']}")
            end
        end
    end
    operations.sort!
end

def get_models(reference_dir)
    models = Group.new('Models')
    path = File.join(reference_dir, 'models', '**', '*.yaml')
    Dir[path].each do |file|
        title = get_title_from_yaml(file) || File.basename(file).gsub(/(\.v\d+)?\.yaml/, '')
        models << Item.new(title, file)
    end
    models.sort!
end

def get_apis(root_dir)
    apis = [ ]
    reference_dir = File.join(root_dir, get_config(root_dir)['formats']['openapi']['rootDir'])
    Dir[File.join(reference_dir, '*.yaml')].each do |file|
        overview = Item.new("Overview", file)
        operations = get_operations(file)
        models = get_models(File.join(reference_dir, File.basename(file).gsub(/(\.v\d+)?\.yaml/, '')))
        title = get_title_from_yaml(file).gsub(/\s+(API|Service)/i, '')
        apis << Group.new(title, [ overview, operations, models ])
    end
    apis.sort!
end

toc = Table.new([
    Divider.new("Documentation"),
    *get_docs(ROOT_DIR),
    Divider.new("API Reference"),
    *get_apis(ROOT_DIR),
])

File.open(File.join(ROOT_DIR, 'toc.json'), 'w') do |f|
    f.write JSON.pretty_generate(toc.to_toc(ROOT_DIR))
end
puts "done"
