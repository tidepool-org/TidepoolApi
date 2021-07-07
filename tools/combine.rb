#!/usr/bin/env ruby
require 'optparse'
require 'time'
require 'fileutils'
require 'yaml'
require 'json'
require 'logger'

PROGRAM_NAME = File.basename($0)
ROOT_DIR = File.absolute_path(File.dirname(__FILE__))

$logger = Logger.new(STDERR)
$logger.level = Logger::DEBUG
$logger.formatter = proc do |severity, datetime, progname, msg|
    "#{datetime} [#{severity}] #{msg}\n"
end

class Spec
    attr_reader :path, :spec

    def initialize(path, label = '')
        @path = path
        $logger.info("reading #{label} spec #{@path}")
        @spec = YAML.load(File.open(@path))
    end

    def info
        @spec['info']
    end

    def merge!(other)
        @spec['paths'].merge!(other.spec['paths'])

        # expand all array types
        %w[ security tags ].each do |key|
            (other.spec[key] || [ ]).each do |value|
                next if @spec[key].include?(value)
                @spec[key] << value
            end
        end

        # expand all map types
        %w[ schemas responses parameters examples requestBodies headers securitySchemes links callbacks ].each do |key|
            @spec['components'][key].merge!((other.spec['components'] || { })[key] || { })
        end
    end

    def to_yaml
        @spec.to_yaml
    end

    def save(output, preamble, label = '')
        File.open(output, 'w') do |file|
            $logger.info("writing #{label} spec #{output}")
            file.write(preamble)
            file.write(self.to_yaml)
        end
    end
end

options = {
    template: File.absolute_path(File.join(ROOT_DIR, '..', 'templates', 'combined.v1.yaml')),
    input: [ ],
    output: File.absolute_path(File.join(ROOT_DIR, '..', 'reference', 'combined.v1.yaml')),
    exclude: [ ]
}
OptionParser.new do |opts|
    opts.program_name = PROGRAM_NAME
    opts.banner = "usage: #{PROGRAM_NAME} [options] [files]"

    options[:exclude] << options[:template] << options[:output]

    opts.on('-t', '--template FILE', "Template FILE (default: #{options[:template]})") do |file|
        options[:template] = file
    end

    opts.on('-o', '--output FILE', "Output FILE (default: #{options[:output]})") do |file|
        options[:output] = file
    end

    opts.on('-e', '--exclude FILE', "Exclude one or more FILEs (default: #{options[:exclude].join(',')})") do |file|
        options[:exclude] << file
    end

    opts.on('-h', '--help', 'Show this help message') do
        puts opts
        exit 1
    end
end.parse!

combined = Spec.new(options[:template], 'template')
options[:input] = ARGV.map { |file| File.absolute_path(file) }.reject { |file| options[:exclude].include?(file) }.sort
options[:input].each do |file|
    spec = Spec.new(file, 'input')
    combined.merge!(spec)
end

combined.save(options[:output],
    [
        "---",
        "Automatically generated on #{Time.now.iso8601} with #{PROGRAM_NAME}",
        "Options:",
        *[ "--template #{options[:template]}", "--output #{options[:output]}", *options[:exclude].map { |file| "--exclude #{file}" }, *options[:input] ].map { |opt| "  #{opt} \\" },
        "",
        "Do not edit manually",
        ""
    ].map { |line| "# #{line}" }.join("\n"), 'output'
)
