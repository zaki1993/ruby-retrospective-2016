RSpec.describe 'Version' do
  it 'doesn\'t create invalid versions' do
    expect { Version.new('.3') }.to raise_error(
      ArgumentError, "Invalid version string '.3'"
    )
    expect { Version.new('0..3') }.to raise_error(
      ArgumentError, "Invalid version string '0..3'"
    )
    expect { Version.new('123213213..') }.to raise_error(
      ArgumentError, "Invalid version string '123213213..'"
    )
  end

  it 'create valid versions without arguments' do
    expect { Version.new }.not_to raise_error
    expect { Version.new '' }.not_to raise_error
  end

  it 'create valid version out of another version' do
    version = Version.new
    expect { Version.new(version) }.not_to raise_error
  end

  it "parse components" do
    version = Version.new("1.1.1")
    expect(version.components).to eq([1, 1, 1])
  end

  it "parse components with argument" do
    version = Version.new('1.2.3')
    expect(version.components(1)).to eq([1])
    expect(version.components(2)).to eq([1, 2])
    expect(version.components(4)).to eq([1, 2, 3, 0])
  end

  context 'comparing versions' do
    it "can compare with #<=>" do
      version1 = Version.new('1.2.3.0.1')
      version2 = Version.new('1.3.1')
      version3 = Version.new('1.3.1.0')
      version4 = Version.new('1.3.1.1.2')
      expect( version1 <=> version2 ).to eq -1
      expect( version2 <=> version3 ).to eq 0
      expect( version4 <=> version2 ).to eq 1
    end

    it "can compare with #==" do
      version1 = Version.new('1.3.1')
      version2 = Version.new('1.3.1.0')
      version3 = Version.new('1.3.1.1.2')
      expect( version1 == version2 ).to be true
      expect( version1 == version3 ).to be false
    end

    it 'can compare with #>' do
      version1 = Version.new('1.2.3.0.1')
      version2 = Version.new('1.3.1')
      version3 = Version.new('1.3.1.0')
      version4 = Version.new('1.3.1.1.2')
      expect(version2 > version1).to be true
      expect(version3 > version4).to be false
    end

    it 'can compare with #<' do
      version1 = Version.new('1.2.3.0.1')
      version2 = Version.new('1.3.1')
      version3 = Version.new('1.3.1.0')
      expect(version1 < version2).to be true
      expect(version2 < version3).to be false
    end

    it 'can compare with #>=' do
      version1 = Version.new('1.3.1')
      version2 = Version.new('1.3.1.0')
      version3 = Version.new('1.3.1.1.2')
      expect(version1 >= version2).to be true
      expect(version1 >= version3).to be false
    end

    it 'can compare with #<=' do
      version1 = Version.new('1.3.1')
      version2 = Version.new('1.3.1.0')
      version3 = Version.new('1.3.1.1.2')
      expect(version1 <= version2).to be true
      expect(version3 <= version1).to be false
    end

    it 'does\'t change internal state' do
      test_obj = Version.new("1.2.3")
      test_obj.components << 1
      expect(test_obj.components).to eq [1, 2, 3]
    end
  end
  describe "#to_s" do
    it "return the version as string" do
      version = Version.new('1.1.1.0')
      expect(version.to_s).to eq '1.1.1'
    end
  end
  describe 'Version::Range' do
    describe '#include?' do
      it 'check if a range includes a version' do
        range = Version::Range.new(Version.new('1'), Version.new('2'))
        expect(range).to include(Version.new('1.5.4.3.2.3.4.5.1.0'))
        expect(range).to include('1.2.3.4.1')
        expect(range).to_not include('0.9.9.9.9.9.9.9')
        expect(range).to_not include(Version.new('2.0.0.1'))
      end
    end

    describe '#to_a' do
      it 'return all versions in a range' do
        range = Version::Range.new(Version.new('1.1.0'), Version.new('1.2.2'))
        expect(range.to_a).to eq [
          '1.1', '1.1.1', '1.1.2', '1.1.3',
          '1.1.4', '1.1.5', '1.1.6', '1.1.7',
          '1.1.8', '1.1.9', '1.2', '1.2.1'
        ]
      end

      it 'work with 3 components only' do
        range = Version::Range.new(Version.new('1.1'), Version.new('1.2'))
        expect(range.to_a).to eq [
          '1.1', '1.1.1', '1.1.2',
          '1.1.3', '1.1.4', '1.1.5',
          '1.1.6', '1.1.7', '1.1.8', '1.1.9'
        ]
      end

      it 'doesn\'t include first version if it\'s same like last' do
        range = Version::Range.new(Version.new('0'), Version.new('0'))
        expect(range.to_a).to eq []
      end

      it 'work with strings' do
        range = Version::Range.new('0', '0.0.9')
        expect(range.to_a).to eq [
          '0', '0.0.1', '0.0.2',
          '0.0.3', '0.0.4', '0.0.5',
          '0.0.6', '0.0.7', '0.0.8'
        ]
      end
    end
  end
end
