import { Attachment as PrismaAttachment } from '@prisma/client'

import { Attachment } from '@/domain/forum/enterprise/entities/attachment'
import { UniqueEntityID } from '@/core/entities/unique-entity-id'

export class PrismaAttachmentMapper {
  static toDomain(raw: PrismaAttachment) {
    return Attachment.create(
      {
        title: raw.title,
        url: raw.url,
      },
      new UniqueEntityID(raw.id),
    )
  }

  static toPrisma(attachment: Attachment) {
    return {
      id: attachment.id.toString(),
      title: attachment.title,
      url: attachment.url,
    }
  }
}
