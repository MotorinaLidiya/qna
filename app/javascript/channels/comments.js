import { createConsumer } from "@rails/actioncable"

const consumer = createConsumer()

document.addEventListener('DOMContentLoaded', () => {
    const questionsAttr = document.querySelector('.questions')
    const questionId = questionsAttr?.dataset.questionId

    if (questionId) {
        consumer.subscriptions.create({ channel: "CommentsChannel", question_id: questionId }, {
            received(data) {
                const commentHTML = data.html
                const comments = document.querySelector('.comments')
                if (comments) {
                    comments.insertAdjacentHTML('beforeend', commentHTML)
                }
            }
        })
    }
})

export default consumer
