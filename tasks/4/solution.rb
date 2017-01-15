RSpec.describe 'Version' do
  describe "parameter_empty_string" do
    it "empty_string" do
      version = Version.new('')
      expect(version).to eq(0)
    end

    it "zero_string" do
      version = Version.new('0')
      expect(version).to eq(0)
    end

    it "no_parameter_no_brackets" do
      version = Version.new
      expect(version).to eq(0)
    end
  end

  describe "correct_params" do
    it "version_object_nested" do
      var = Version.new(Version.new(Version.new('1.2').to_s + '.9'))
      expect(var).to eq('1.2.9')
    end

    it "variable_parameter" do
      var = '1.3.5'
      expect(Version.new(var)).to eq('1.3.5')
    end

    it "string_parameter" do
      expect(Version.new('1.1.1')).to eq('1.1.1')
    end

    it "last_zero_parameter" do
      expect(Version.new('1.1.0')).to eq('1.1.0')
    end

    it "zero_start_parameter" do
      expect(Version.new('0.0.1')).to eq('0.0.1')
    end

    it "instance_parameter" do
      version = Version.new('1.1.1')
      expect(Version.new(version)).to eq('1.1.1')
    end

    it "negative_number_in_string_parameter" do
      expect { Version.new('-1.1.1') }.to raise_error(ArgumentError)
    end

    it "negative_number_parameter" do
      expect { Version.new(-1.1) }.to raise_error(ArgumentError)
    end
  end

  describe "components_corectness" do
    it "zero_component" do
      expect(Version.new.components(0)).to eq([])
    end

    it "one_component" do
      expect(Version.new.components(1)).to eq([0])
    end

    it "one_component_zero" do
      expect(Version.new(0).components(1)).to eq([0])
    end

    it "zero_component_string" do
      expect(Version.new('').components(1)).to eq([0])
    end

    it "more_component" do
      expect(Version.new('1.3.5').components(3)).to eq([1, 3, 5])
    end

    it "param_more_components" do
      expect(Version.new('1.3.5').components(5)).to eq([1, 3, 5, 0, 0])
    end

    it "wrong_component_parameter" do
      error = NoMethodError
      expect { Version.new('1.3.5').components("s") }.to raise_error(error)
    end

    it "mutabillity" do
      version = Version.new('1.3.5').components(2)
      version.to_s.upcase!
      expect(version).to eq([1, 3])
    end
  end

  describe "incorrect_parameter" do
    it "argument_error_array" do
      expect { Version.new(['1.2.3']) }.to raise_error(ArgumentError)
    end

    it "argument_error_range_number" do
      expect { Version.new(0..3) }.to raise_error(ArgumentError)
    end

    it "argument_error_range_letter" do
      expect { Version.new('a'..'z') }.to raise_error(ArgumentError)
    end

    it "argument_error_point_start" do
      expect { Version.new('.3.3') }.to raise_error(ArgumentError)
    end

    it "argument_error_point_end" do
      expect { Version.new('3.3.') }. to raise_error(ArgumentError)
    end

    it "argument_error_string" do
      expect { Version.new('random_string') }.to raise_error(ArgumentError)
    end

    it "argument_error_dot" do
      expect { Version.new('1.3.5.') }.to raise_error(ArgumentError)
    end
  end
  describe "compare_two_versions" do
    it "first_less_than_second" do
      expect(Version.new('1.3.5')).to be < Version.new('1.3.6')
      expect(Version.new('1.0.0')).to be < Version.new('1.0.0.1')
    end

    it "first_equal_second" do
      expect(Version.new('1.3.5')).to be == Version.new('1.3.5')
      expect(Version.new('1.0.0')).to be == Version.new(1)
    end

    it "first_bigger_than_second" do
      expect(Version.new('1.3.5')).to be > Version.new('1.3.4')
      expect(Version.new('1.0.0.0.1')).to be > Version.new('1.0.0')
    end

    it "first_not_less_second" do
      expect(Version.new('1.1.1') < Version.new('1.1.0')).to eq(false)
      expect(Version.new(''))
    end

    it "first_less_or_equal_second" do
      expect(Version.new('1.3.5')).to be <= Version.new('1.3.5')
    end

    it "first_bigger_or_equal_second" do
      expect(Version.new('1.3.5')).to be >= Version.new('1.3.5')
    end

    it "smaller_bigger_equal" do
      expect(Version.new('1.1.0') <=> Version.new('1.1')).to eq(0)
    end

    it "shorter_longer" do
      expect(Version.new('1.1')).to be < Version.new('1.1.0.1')
    end
  end

  describe "to_string" do
    it "no_parameter" do
      expect(Version.new.to_s).to eq('')
    end

    it "zero_as_parameter" do
      expect(Version.new(0).to_s).to eq('')
    end

    it "correct_input" do
      expect(Version.new('1.3.5.6').to_s).to eq('1.3.5.6')
    end

    it "incorrect_input" do
      expect { Version.new('1.3.4.').to_s }.to raise_error(ArgumentError)
    end

    it "last_zero" do
      expect(Version.new('1.1.0').to_s).to eq('1.1')
    end

    it "zero_start" do
      expect(Version.new('0.0.1').to_s).to eq('0.0.1')
    end
  end

  describe "range_test_include" do
    it "include_version" do
      res = Version::Range.new('0.0.0.1', '0.0.0.2').include?('0.0.0.1.5')
      expect(res).to eq(true)
    end

    it "include_fail" do
      r = Version::Range.new(Version.new('1.5.0'), '1.0.1').include?('1.4.1')
      expect(r).to eq(false)
    end

    it "include_nested" do
      first = Version.new
      second = Version.new(first.to_s + '0.9.2')
      res = Version::Range.new(second, '1.0.0').include?('0.9.5')
      expect(res).to eq(true)
    end

    it "include_from_x_to_x" do
      res = Version::Range.new('1.3.5', '1.3.5').include?('1.3.5')
      expect(res).to eq(false)
    end

    it "include_equal_to_start_version" do
      res = Version::Range.new('1.0.1', '1.1.1').include?('1.0.1')
      expect(res).to eq(true)
    end
  end

  describe "range_test_to_a" do
    it "correct_one" do
      res = Version::Range.new('1.0.1', '1.0.2').to_a
      expect(res).to eq(['1.0.1'])
    end

    it "empty_array" do
      res = Version::Range.new('1.3.5', '1.3.5').to_a
      expect(res).to eq([])
    end

    it "outrange_array" do
      res = Version::Range.new('1.3.5', '1.3.3').to_a
      expect(res).to eq([])
    end

    it "incorrect_range" do
      expect { Version::Range.new '1.', '' }.to raise_error(ArgumentError)
    end
  end
end
