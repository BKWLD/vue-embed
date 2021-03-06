webpack = require 'webpack'
VueLoaderPlugin = require 'vue-loader/lib/plugin'
nodeExternals = require 'webpack-node-externals'

module.exports = (env, argv) ->
	
	# Build for production but don't uglify so the transpiled code is more
	# readable
	mode: 'production'
	optimization: minimize: false

	entry: index: './index.vue'

	resolve: extensions: ['.js', '.coffee', '.vue']

	module: rules: [
		{ test: /\.coffee$/, loader: 'babel-loader!coffee-loader' }
		{ test: /\.pug$/, loader: 'pug-plain-loader' }
		{ test: /\.vue$/, loader: 'vue-loader' }
	]

	plugins: [
		new VueLoaderPlugin
	]

	output:
		path: __dirname
		libraryTarget: 'commonjs2'
		filename: '[name].js'

	# Every non-relative module is external
	externals: [nodeExternals()]
