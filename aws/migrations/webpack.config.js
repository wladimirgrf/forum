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
        {
          from: '../../node_modules/.prisma/client/libquery_engine-rhel-openssl-3.0.x.so.node',
          to: '.',
        },
        { from: '../../node_modules/.prisma/client/schema.prisma', to: '.' },
      ],
    }),
  ],
}
