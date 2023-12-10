import { randomUUID } from 'node:crypto'
import { Injectable } from '@nestjs/common'
import { S3Client, PutObjectCommand } from '@aws-sdk/client-s3'

import {
  UploadParams,
  Uploader,
} from '@/domain/forum/application/storage/uploader'
import { EnvService } from '../env/env.service'

@Injectable()
export class AWSStorage implements Uploader {
  private client: S3Client

  constructor(private envService: EnvService) {
    this.client = new S3Client({
      region: envService.get('AWS_REGION'),
      credentials: {
        accessKeyId: envService.get('AWS_ACCESS_KEY_ID'),
        secretAccessKey: envService.get('AWS_SECRET_ACCESS_KEY'),
      },
    })
  }

  async upload({
    fileName,
    fileType,
    body,
  }: UploadParams): Promise<{ url: string }> {
    const uploadId = randomUUID()
    const uniqueFileName = `${uploadId}-${fileName}`

    await this.client.send(
      new PutObjectCommand({
        Bucket: this.envService.get('AWS_BUCKET_NAME'),
        Key: uniqueFileName,
        ContentType: fileType,
        Body: body,
      }),
    )

    return {
      url: uniqueFileName,
    }
  }
}
