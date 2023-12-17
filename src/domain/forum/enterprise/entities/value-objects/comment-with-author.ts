import { ValueObject } from '@/core/entities/value-object'

interface AuthorProps {
  id: string
  name: string
}

export interface CommentWithAuthorProps {
  commentId: string
  content: string
  author: AuthorProps
  createdAt: Date
  updatedAt?: Date | null
}

export class CommentWithAuthor extends ValueObject<CommentWithAuthorProps> {
  static create(props: CommentWithAuthorProps) {
    return new CommentWithAuthor(props)
  }

  get commentId() {
    return this.props.commentId
  }

  get content() {
    return this.props.content
  }

  get author() {
    return this.props.author
  }

  get createdAt() {
    return this.props.createdAt
  }

  get updatedAt() {
    return this.props.updatedAt
  }
}
