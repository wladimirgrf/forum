import { User as PrismaUser } from '@prisma/client'

import { Student } from '@/domain/forum/enterprise/entities/student'
import { UniqueEntityID } from '@/core/entities/unique-entity-id'

export class PrismaStudentMapper {
  static toDomain(raw: PrismaUser): Student {
    return Student.create(
      {
        name: raw.name,
        email: raw.email,
        password: raw.password,
      },
      new UniqueEntityID(raw.id),
    )
  }

  static toPrisma(student: Student) {
    return {
      id: student.id.toString(),
      name: student.name,
      email: student.email,
      password: student.password,
    }
  }
}
