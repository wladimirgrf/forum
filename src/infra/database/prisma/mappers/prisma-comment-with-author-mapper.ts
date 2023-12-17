import { Comment as PrismaComment, User as PrismaUser } from '@prisma/client'

import { CommentWithAuthor } from '@/domain/forum/enterprise/entities/value-objects/comment-with-author'
import { UniqueEntityID } from '@/core/entities/unique-entity-id'

type PrismaCommentWithAuthor = PrismaComment & {
  author: PrismaUser
}

export class PrismaCommentWithAuthorMapper {
  static toDomain(raw: PrismaCommentWithAuthor): CommentWithAuthor {
    return CommentWithAuthor.create({
      commentId: new UniqueEntityID(raw.id),
      content: raw.content,
      createdAt: raw.createdAt,
      updatedAt: raw.updatedAt,
      author: { id: new UniqueEntityID(raw.authorId), name: raw.author.name },
    })
  }
}
