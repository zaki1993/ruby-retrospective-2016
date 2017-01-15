class CommandParser
  def initialize(command_name)
    @command_name = command_name
    @args = []
    @opts = []
    @a_blocks = []
    @o_blocks = {}
    @a_idx = 0
    @o_idx = 0
    @num_o = 0
  end

  def argument(argument_name, &arg_block)
    @args << argument_name
    @args
    @a_blocks << arg_block
  end

  def option(short, long, helper_str, &opts_block)
    @o_blocks[long] = opts_block
    @opts << [short, long, helper_str]
    @num_o += 1
    @opts
  end

  def option_with_parameter(short, long, helper_str, parameter)
  end

  def check_opt(value, command_runner)
    if @num_o != 0 && @o_blocks.include?(value[2, value.length])
      @o_blocks[value[2, value.length]].call(command_runner, true)
    elsif @num_o != 0 && @opts[@o_idx].include?(value[1, value.length])
      @o_blocks[@opts[@o_idx][1]].call(command_runner, true)
      @o_idx += 1
    end
  end

  def parse(command_runner, argv)
    argv.each do |value|
      if value.start_with?('-')
        check_opt(value, command_runner)
      else
        @a_blocks[@a_idx].call(command_runner, value)
        @a_idx += 1
      end
    end
  end
end
