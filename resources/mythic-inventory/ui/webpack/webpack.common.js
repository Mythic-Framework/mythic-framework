const path = require('path');
const webpack = require('webpack');
const TerserPlugin = require('terser-webpack-plugin');
const Dotenv = require('dotenv-webpack');
const SRC = path.resolve(__dirname, 'node_modules');


module.exports = (options) => ({
	mode: options.mode,
	entry: options.entry,
	output: {
		path: path.resolve(process.cwd(), 'dist'),
		publicPath: options.mode !== 'production' ? '/' : '/ui/dist/',
		filename: '[name].js',
	},
	performance: {
		hints: false,
	},
	optimization: {
		splitChunks: {
			minSize: 10000,
			maxSize: 250000,
		},
		minimize: true,
		minimizer: [
			new TerserPlugin({
				terserOptions: {
					format: {
						comments: false,
					},
				},
				extractComments: false,
			}),
		],
	},
	plugins: [new Dotenv(), ...options.plugins],
	module: {
		rules: [
			{
				test: /\.tsx?$/,
				exclude: /node_modules/,
				use: {
					loader: 'ts-loader',
					options: {
						transpileOnly: true,
					},
				},
			},
			{
				test: /\.jsx?$/,
				exclude: /node_modules/,
				use: {
					loader: 'babel-loader',
				},
			},
			{
				test: /\.css$/,
				exclude: /node_modules/,
				use: ['style-loader', 'css-loader'],
			},
			{
				// Preprocess 3rd party .css files located in node_modules
				test: /\.css$/,
				include: /node_modules/,
				use: ['style-loader', 'css-loader'],
			},
			{
				test: /\.html$/,
				use: 'html-loader',
			},
			{
				test: /\.(eot|otf|ttf|woff|woff2|mp3)$/,
				use: 'file-loader',
			},
			{
				test: /\.svg$/,
				use: [
					{
						loader: 'svg-url-loader',
						options: {
							// Inline files smaller than 10 kB
							limit: 10 * 1024,
							noquotes: true,
						},
					},
				],
			},
			{
				test: /\.(jpg|png|webp|gif|gifv)$/,
				use: {
					loader: 'url-loader',
				},
			},
			{
				test: /\.(mp4|webm)$/,
				use: {
					loader: 'url-loader',
					options: {
						limit: 10000,
					},
				},
			},
			{
				test: /\.js$/,
				exclude: /node_modules/,
				use: [
					{
						loader: `ifdef-loader`,
						options: {
							DEBUG: options.mode !== 'production',
							version: 3,
							'ifdef-verbose': true, // add this for verbose output
							'ifdef-triple-slash': true, // add this to use double slash comment instead of default triple slash
						},
					},
				],
			},
			{
				test: /\.js$/,
				enforce: 'pre',
				use: ['source-map-loader'],
			},
		],
	},
	resolve: {
		modules: ['src', 'node_modules'],
		extensions: ['.js', '.jsx', '.react.js'],
	},
});
