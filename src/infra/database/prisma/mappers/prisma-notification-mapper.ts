import { Notification as PrismaNotification } from '@prisma/client'

import { Notification } from '@/domain/notification/enterprise/entities/notification'
import { UniqueEntityID } from '@/core/entities/unique-entity-id'

export class PrismaNotificationMapper {
  static toDomain(raw: PrismaNotification): Notification {
    return Notification.create(
      {
        title: raw.title,
        content: raw.content,
        recipientId: new UniqueEntityID(raw.recipientId),
        createdAt: raw.createdAt,
        readAt: raw.readAt,
      },
      new UniqueEntityID(raw.id),
    )
  }

  static toPrisma(notification: Notification) {
    return {
      id: notification.id.toString(),
      recipientId: notification.recipientId.toString(),
      title: notification.title,
      content: notification.content,
      createdAt: notification.createdAt,
      readAt: notification.readAt,
    }
  }
}
