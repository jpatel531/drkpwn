file = File.open('./app.drkpwn', 'r').read

matches = file.match(/drkpwn\? >>>(.*)<<< pwnd/m)

app =  matches[1]

pwn_funks = app.match(/(.*) = funk\( \|(.*)\|=>\s\s(.*)/)[1..-1]

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

		params = app.match(Regexp.new(function[:name] + "\\(.*\\)"))[1..-1]

		puts params

		method = "
			def #{function[:name]}(#{function[:params].join(",")})
				#{function[:exec]}
			end

			#{function[:name]}
		"
		eval method
	end
end

