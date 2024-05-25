const path = require("node:path");
const CopyPlugin = require("copy-webpack-plugin");

module.exports = {
  mode: "production",
  entry: "./src/main.js",
  resolve: {
    extensions: [".js"],
  },
  output: {
    path: path.resolve(__dirname, "dist"),
    filename: "main.js",
    library: "handler",
    libraryTarget: "umd",
    globalObject: "this",
    clean: true,
  },
  target: "node",
  plugins: [
    new CopyPlugin({
      patterns: [
        { from: "./engines", to: "node_modules/@prisma/engines" },
        { from: "../../prisma", to: "prisma" },
        {
          from: "../../node_modules/prisma",
          to: "node_modules/prisma",
          globOptions: {
            ignore: ["**/libquery_engine-darwin.dylib.node"],
          },
        },
        {
          from: "../../node_modules/@prisma",
          to: "node_modules/@prisma",
          globOptions: {
            ignore: [
              "**/libquery_engine-darwin.dylib.node",
              "**/schema-engine-darwin",
            ],
          },
        },
      ],
    }),
  ],
};
