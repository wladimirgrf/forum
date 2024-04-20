const path = require('node:path')
const CopyPlugin = require('copy-webpack-plugin')

module.exports = {
  mode: 'production',
  entry: './src/main.js',
  resolve: {
    extensions: ['.js'],
  },
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'main.js',
    library: 'handler',
    libraryTarget: 'umd',
    globalObject: 'this',
  },
  target: 'node',
  plugins: [
    new CopyPlugin({
      patterns: [
        { from: '../../prisma', to: 'prisma' },
        { from: '../../node_modules/.prisma', to: 'node_modules/.prisma' },
        { from: './node_modules/@prisma', to: 'node_modules/@prisma' },
        { from: './node_modules/prisma', to: 'node_modules/prisma' },
        { from: './node_modules/.bin/prisma', to: 'node_modules/.bin/prisma' },
        { from: './package.json', to: '.' },
      ],
    }),
  ],
}
