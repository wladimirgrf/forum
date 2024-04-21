const { execSync } = require("node:child_process");
const path = require("node:path");

export async function handler() {
  const PRISMA_CLI_PATH = path.join(
    __dirname,
    "node_modules",
    "prisma",
    "build",
    "index.js"
  );

  execSync(`node ${PRISMA_CLI_PATH} migrate deploy`);
}
