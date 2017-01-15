module ParserHelpers
  def parse_arguments(command_runner, argv)
    idx = 0
    argv.each do |argument|
      next if argument[0] == '-'
        @arguments[@arguments.keys[idx]].call(command_runner, argument)
      idx += 1
    end
  end

  def parse_options(command_runner, argv)
    @options.each do |key, value|
      if argv.include?("-#{value[1]}") || argv.include?("--#{key}")
        value[0].call(command_runner, true)
      end
    end
  end

  def parse_options_with_parameters(command_runner, argv)
    @options_with_parameter.each do |key, value|
      argv.each do |argument|
        essentials = argument[2..-1]
        value[1] == argument[1] && value[0].call(command_runner, essentials)
        opt_name, opt_param = essentials.split('=')
        key == opt_name && value[0].call(command_runner, opt_param)
      end
    end
  end
end

class CommandParser
  include ParserHelpers

  def initialize(command_name)
    @command_name = command_name
    @arguments = {}
    @options = {}
    @options_with_parameter = {}
  end

  def argument(name, &block)
    @arguments[name] = block
  end

  def option(short_name, long_name, text, &block)
    @options[long_name] = [block, short_name, text]
  end

  def option_with_parameter(short_name, long_name, text, plholder, &block)
    @options_with_parameter[long_name] = [block, short_name, text, plholder]
  end

  def parse(command_runner, argv)
    parse_arguments(command_runner, argv)
    parse_options(command_runner, argv)
    parse_options_with_parameters(command_runner, argv)
  end

  def help
    res = "Usage: #{@command_name} "
    @arguments.each { |argument, _| res << '[' + argument + '] ' }
    res = res.chop
    @options.each do |name, info|
      res << "\n    -" + info[1] + ', --' + name + ' ' + info[2]
    end
    @options_with_parameter.each do |name, info|
      res << "\n    -" + info[1] + ', --' + name + '=' + info[3] + ' ' + info[2]
    end
    res
  end
end
