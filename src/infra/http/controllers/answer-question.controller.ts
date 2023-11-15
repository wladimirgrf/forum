import {
  BadRequestException,
  Body,
  Controller,
  Param,
  Post,
} from '@nestjs/common'
import { z } from 'zod'

import { CurrentUser } from '@/infra/auth/current-user-decorator'
import { UserPayload } from '@/infra/auth/jwt.strategy'
import { ZodValidationPipe } from '@/infra/http/pipes/zod-validation-pipe'
import { AnswerQuestionUseCase } from '@/domain/forum/application/use-cases/answer-question'

const answerQuestionBodySchema = z.object({
  content: z.string(),
})

const bodyValidationPipe = new ZodValidationPipe(answerQuestionBodySchema)

type AnswerQuestionBodySchema = z.infer<typeof answerQuestionBodySchema>

@Controller('/questions/:questionId/answers')
export class AnswerQuestionController {
  constructor(private answerQuestion: AnswerQuestionUseCase) {}

  @Post()
  async handle(
    @CurrentUser() user: UserPayload,
    @Param('questionId') questionId: string,
    @Body(bodyValidationPipe) body: AnswerQuestionBodySchema,
  ) {
    const { content } = body
    const userId = user.sub

    const result = await this.answerQuestion.execute({
      content,
      questionId,
      authorId: userId,
      attachmentsIds: [],
    })

    if (result.isLeft()) {
      throw new BadRequestException()
    }
  }
}
