import { AggregateRoot } from '@/core/entities/aggregate-root'
import { UniqueEntityID } from '@/core/entities/unique-entity-id'

export interface CommentProps {
  authorId: UniqueEntityID
  content: string
  createdAt: Date
  updatedAt?: Date | null
}

export abstract class Comment<
  Props extends CommentProps,
> extends AggregateRoot<Props> {
  private touch() {
    this.props.updatedAt = new Date()
  }

  get authorId(): UniqueEntityID {
    return this.props.authorId
  }

  get createdAt(): Date {
    return this.props.createdAt
  }

  get updatedAt(): Date | undefined | null {
    return this.props.updatedAt
  }

  get content(): string {
    return this.props.content
  }

  set content(content: string) {
    this.props.content = content
    this.touch()
  }
}
