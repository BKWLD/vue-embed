<template lang='pug'>

section
	.html(ref='html' v-html='markup')
	transition(v-if='showLoading' name='fade'): .loading(v-if='loading') Loading

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

	props: 
		html: String
		showLoading:
			type: Boolean
			default: true
		wrapperSelector: 
			type: String

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
		scripts: -> @html?.match(scriptsPattern) || []

		# Just the markup without scripts
		markup: -> @html?.replace scriptsPattern, ''

	methods:

		# Eval-able JS from scripts array
		parseScripts: ->

			# iterate through scripts
			for script in @scripts
				scriptTag = new DOMParser().parseFromString(script, "text/html").querySelector("script")
				attributes = scriptTag.attributes

				# Render an external script tag
				if scriptURL = scriptURLPattern.exec(script)
					@externalScripts.push @loadScript scriptURL[1], attributes

				# Queue up code to execute
				else
					@scriptCodes.push script.replace /<\/?script[^>]*>/gi, ''

		# add script to head
		loadScript: (scriptURL, attributes) -> new Promise (resolve, reject) =>
			script = document.createElement('script')

			for attribute in attributes
				script.setAttribute attribute.name, attribute.value

			script.src = scriptURL
			script.async = true
			script.onload = resolve
			script.onerror= reject

			parent = if @wrapperSelector then document.querySelector @wrapperSelector else document.head
			parent.appendChild(script)

</script>
