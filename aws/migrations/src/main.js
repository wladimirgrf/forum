const { PrismaClient } = require('@prisma/client')

const prisma = new PrismaClient()

export async function handler() {
  await prisma.migrate()
}
