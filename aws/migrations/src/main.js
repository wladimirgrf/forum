const { execSync } = require('node:child_process');


export async function handler() {
  execSync('npm run start');
}
