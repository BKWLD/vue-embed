<template lang='pug'>

section
	.html(ref='html' v-html='markup')
	transition(name='fade'): .loading(v-if='loading') Loading

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>

# Get the script tags from string
# https://regex101.com/r/doKHCZ/1
# https://stackoverflow.com/a/19188718/59160
scriptsPattern = /<script[\s\S]*?>[\s\S]*?<\/script>/gi

# Get script URL from string
# https://regex101.com/r/14IX5a/1
# https://stackoverflow.com/questions/25632144/javascript-regex-to-get-url-from-string-containing-script-tag
scriptURLPattern = /<script[^>]*src="(.*?)"/gmi

export default

	props: html: String

	data: ->
		loading: true
		externalScripts: []
		scriptCodes: []

	mounted: ->
		@parseScripts()

		# Load external scripts
		try
			await Promise.all @externalScripts
			@loading = false

			# Run inline code
			eval code for code in @scriptCodes

		# Show an error message to users
		catch e then console.error e

	computed:

		# Get scripts from the html
		scripts: -> @html.match(scriptsPattern) || []

		# Just the markup without scripts
		markup: -> @html.replace scriptsPattern, ''

	methods:

		# Eval-able JS from scripts array
		parseScripts: ->

			# iterate through scripts
			for script in @scripts

				# Render an external script tag
				if scriptURL = scriptURLPattern.exec(script)
					@externalScripts.push @loadScript scriptURL[1]

				# Queue up code to execute
				else
					@scriptCodes.push script.replace /<\/?script[^>]*>/gi, ''

		# add script to head
		loadScript: (scriptURL) -> new Promise (resolve, reject) ->
			script = document.createElement('script')
			script.src = scriptURL
			script.async = true
			script.onload = resolve
			script.onerror= reject
			document.head.appendChild(script)

</script>
