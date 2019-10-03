module Calculator
  class Lexer
    Token = Struct.new(:type, :value)
    TOKENS = {
    # name: '[A-z]+\w*',
      number: '-?\d*\.?\d+',
      l_paren: '#left\(',
      r_paren: '#right\)',
      l_bracket: '\[',
      r_bracket: '\]',
      l_brace: '\{',
      r_brace: '\}',
      exp: '\^',
      sqrt: '#sqrt',
      multiply: '#cdot',
      divide: '#frac',
      add: '\+',
      subtract: '-',
      nil: nil
    }

    def initialize(source)
      @source = analyze_shorthand(source)
      @pos = 0
      @instructions = []
      clear_token
    end

    private

    def analyze_shorthand(source)
      # gsub! doesn't work in Opal
      source
        .gsub("\\", "#")
        .gsub("#sqrt{", "#sqrt[2]{")
    end

    def clear_token
      @token = Token.new(nil, "")
    end

    def next_token
      clear_token
      TOKENS.each do |name, pattern|
        return @token.type = :end_of_file if stream == "" || name == :nil
        next unless value = /^#{pattern}/.match(stream)
        @token.value = value[0]
        @token.type = name
        @pos += value[0].length
        return @token.type
      end
    end

    def stream
      @source[@pos..-1]
    end
  end
end
