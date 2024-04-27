const path = require('path')
const CopyPlugin = require('copy-webpack-plugin')

module.exports = (options, webpack) => {
  const lazyImports = [
    '@nestjs/microservices/microservices-module',
    '@nestjs/websockets/socket-module',
  ]

  return {
    ...options,
    entry: './src/infra/serverless.ts',
    externals: [],
    output: {
      path: path.resolve(__dirname, 'dist'),
      filename: 'main.js',
      library: 'handler',
      libraryTarget: 'umd',
      globalObject: 'this',
    },
    plugins: [
      ...options.plugins,
      new webpack.IgnorePlugin({
        checkResource(resource) {
          if (lazyImports.includes(resource)) {
            try {
              require.resolve(resource)
            } catch (err) {
              return true
            }
          }
          return false
        },
      }),
      new CopyPlugin({
        patterns: [
          {
            from: './node_modules/.prisma/client/libquery_engine-rhel-openssl-3.0.x.so.node',
            to: '.',
          },
          { from: './node_modules/.prisma/client/schema.prisma', to: '.' },
        ],
      }),
    ],
  }
}
