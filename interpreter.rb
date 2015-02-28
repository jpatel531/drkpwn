file = File.open('./app.drkpwn', 'r').read

matches = file.match(/drkpwn\? >>>(.*)<<< pwnd/m)

app =  matches[1]

pwn_funks = []

app.scan(/(.*) = funk\( \|(.*)\|=>\s\s(.*)/) do |match|
	pwn_funks += match	
end

functions = []

pwn_funks.to_a.each_slice(3) do |funk|
	function = {
		name: funk[0],
		params: (funk[1].empty? ? [] : funk[1].split("*")),
		exec: funk[2]
	}
	functions << function
end

functions.each do |function|
	if app =~ Regexp.new(function[:name] + "\\(.*\\)")

		params = app.match(Regexp.new(function[:name] + "\\((.*)\\)"))[1..-1]

		method = "
			def #{function[:name]}(#{function[:params].join(",")})
				#{function[:exec]}
			end

			#{function[:name]}(#{params.join(",")})
		"
		eval method
	end
end

