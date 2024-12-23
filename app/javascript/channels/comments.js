import { createConsumer } from "@rails/actioncable"

const consumer = createConsumer()

document.addEventListener('DOMContentLoaded', () => {
    const questionsAttr = document.querySelector('.questions')
    const questionId = questionsAttr?.dataset.questionId

    if (questionId) {
        consumer.subscriptions.create({ channel: "CommentsChannel", question_id: questionId }, {
            received(data) {
                const { html, commentable_type, commentable_id } = data
                const commentsContainer = document.querySelector(`.comments[data-commentable-id="${commentable_id}"]`)

                if (commentsContainer) {
                    commentsContainer.insertAdjacentHTML("beforeend", html)
                }
            }
        })
    }
})

export default consumer
