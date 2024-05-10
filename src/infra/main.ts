import { NestFactory } from '@nestjs/core'
import * as swaggerUi from 'swagger-ui-express'
import * as YAML from 'yamljs'

import { AppModule } from './app.module'
import { EnvService } from './env/env.service'

async function bootstrap() {
  const app = await NestFactory.create(AppModule)

  const envService = app.get(EnvService)
  const port = envService.get('PORT')

  const swaggerDocument = YAML.load('./swagger.yaml')
  app.use('/docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument))

  await app.listen(port)
}
bootstrap()
