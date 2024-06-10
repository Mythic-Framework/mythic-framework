const path = require('path');
const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = require('./webpack.common')({
	mode: 'production',
	entry: [path.join(process.cwd(), 'src/app.js')],
	plugins: [
		new HtmlWebpackPlugin({
			template: 'src/index.html',
			minify: {
				removeComments: true,
				collapseWhitespace: true,
				removeRedundantAttributes: true,
				useShortDoctype: true,
				removeEmptyAttributes: true,
				removeStyleLinkTypeAttributes: true,
				keepClosingSlash: true,
				minifyJS: true,
				minifyCSS: true,
				minifyURLs: true,
			},
			inject: true,
		}),
		new webpack.EnvironmentPlugin({
			NODE_ENV: 'production',
		}),
	],
	performance: {
		assetFilter: (assetFilename) =>
			!/(\.map$)|(^(main\.|favicon\.))/.test(assetFilename),
	},
});
