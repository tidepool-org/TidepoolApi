#!/usr/bin/env ruby
require 'fileutils'
require 'yaml'
require 'json'
require 'logger'

$logger = Logger.new(STDERR)
$logger.level = Logger::DEBUG
$logger.formatter = proc do |severity, datetime, progname, msg|
    "#{datetime} [#{severity}] #{msg}\n"
end

class Block
    class << self
        def create(content)
            type = content['type']
            data = content['data']
            case type
            when 'text'
                TextBlock.new(data)
            when 'callout'
                CalloutBlock.new(data)
            when 'http'
                HttpBlock.new(content['header'], data)
            when 'jsonSchema'
                JsonSchemaBlock.new(content['header'], data)
            else
                $logger.error { "unrecognized block type #{type}" }
                exit 1
            end
        end
    end
end

class TextBlock < Block
    attr_reader :body

    def initialize(body)
        @body = body
        $logger.debug { to_s }
    end

    def to_s
        "TextBlock: #{@body[0, 30].gsub("\n", " ")}..."
    end

    def to_md
        @body
    end
end

class CalloutBlock < Block
    attr_reader :type, :title, :body

    def initialize(data)
        @type = data['type'] || 'info'
        @title = data['title']
        @body = data['body']
        $logger.debug { to_s }
    end

    def to_s
        "CalloutBlock: #{@type}, #{@title}"
    end

    def to_md
        if @title.nil?
            title = ''
        else
            title = "> ### #{@title}\n>\n"
        end
        <<~MARKDOWN

        <!-- theme: #{@type} -->

        #{title}> #{@body}
        MARKDOWN
    end
end

class HttpBlock < Block
    attr_reader :title, :method, :url
    attr_reader :auth, :headers

    def initialize(header, data)
        @title = header['title']
        @method = data['method']
        @url = data['url']
        @query = data['query']
        @auth = data['auth']
        @headers = data['headers']
        @body = data['body']
        $logger.debug { to_s }
    end

    def to_s
        "HttpBlock: #{@title} #{@method} #{@url}"
    end

    def to_md
        obj = { method: @method, url: @url, query: @query, headers: @headers, body: @body }
        <<~MARKDOWN
        ```yaml http
        #{JSON.pretty_generate(obj)}
        ```
        MARKDOWN
    end
end

class JsonSchemaBlock < Block
    attr_reader :title, :subtitle
    attr_reader :schema

    def initialize(header, data)
        @title = header['title']
        @subtitle = header['subtitle']
        @schema = data
        $logger.debug { to_s }
    end

    def to_s
        "JsonSchemaBlock: #{@title} #{@subtitle}"
    end

    def to_md
        obj = { title: @title, type: 'object', 'properties': @schema }
        <<~MARKDOWN
        ```json json_schema
        #{JSON.pretty_generate(obj)}
        ```
        MARKDOWN
    end
end

class Page
    def initialize(path, page, parent = nil)
        @path = path
        @parent = parent
        @title = page['title']
        @data = page['data']
        $logger.debug { to_s }
    end

    def to_s
        "Page: #{@path}, #{@title}"
    end

    def each_block
        return [ ] unless @data.has_key?('blocks')
        @data['blocks'].map { |b| Block.create(b) }
    end

    def each_child
        return [ ] unless @data.has_key?('children')
        @data['children'].map { |c| Page.new(c['route']['path'], c, self) }
    end

    def to_md
        <<~MARKDOWN
        # #{@title}

        #{each_block.map { |b| b.to_md }.join("\n")}
        MARKDOWN
    end

    def save(root_dir)
        FileUtils.mkdir_p(root_dir)
        path = @path.gsub('/', '')
        path = @title.downcase if path.empty?
        name = File.join(root_dir, "#{path}.md")
        File.open(name, 'w') { |f| f.write(to_md) }

        each_child.each do |child|
            child.save(File.join(root_dir, path))
        end
    end
end

class RootPage < Page
    def initialize(page)
        super(page[0], page[1], nil)
    end
end

FILE = 'main.hub.yml'
ROOT_DIR = 'output'
$logger.info "reading #{FILE}"
hub = YAML.load(File.open(FILE))
hub['pages'].each do |page|
    page = RootPage.new(page)
    page.save(ROOT_DIR)
end
