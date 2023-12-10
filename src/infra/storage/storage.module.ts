import { Module } from '@nestjs/common'

import { Uploader } from '@/domain/forum/application/storage/uploader'
import { AWSStorage } from './aws-storage'
import { EnvModule } from '../env/env.module'

@Module({
  imports: [EnvModule],
  providers: [
    {
      provide: Uploader,
      useClass: AWSStorage,
    },
  ],
  exports: [Uploader],
})
export class StorageModule {}
