const path = require('path');
const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = require('./webpack.common')({
	mode: 'development',
	entry: [path.join(process.cwd(), 'src/app.js')],
	plugins: [
		new webpack.HotModuleReplacementPlugin(),
		new HtmlWebpackPlugin({
			inject: true,
			template: 'src/index.html',
		}),
	],
	performance: {
		hints: false,
	},
});
