import { Server } from 'node:http'
import { NestFactory } from '@nestjs/core'
import serverlessExpress from 'aws-serverless-express'
import { Context, Handler, APIGatewayProxyEvent } from 'aws-lambda'

import { AppModule } from './app.module'

let server: Server

async function bootstrap(): Promise<Server> {
  const app = await NestFactory.create(AppModule, {
    logger: ['error', 'warn'],
  })

  app.enableCors()

  await app.init()

  const expressApp = app.getHttpAdapter().getInstance()
  return serverlessExpress.createServer(expressApp)
}

export const handler: Handler = async (
  event: APIGatewayProxyEvent,
  context: Context,
) => {
  server = server ?? (await bootstrap())

  return serverlessExpress.proxy(server, event, context, 'PROMISE').promise
}
