import { createConsumer } from "@rails/actioncable"

const consumer = createConsumer()

document.addEventListener('DOMContentLoaded', () => {
    const questionsAttr = document.querySelector('.questions')
    const questionId = questionsAttr?.dataset.questionId

    if (questionId) {
        consumer.subscriptions.create({ channel: "AnswersChannel", question_id: questionId }, {
            received(data) {
                const answerHTML = data.html
                const answersList = document.querySelector('.answers')
                if (answersList) {
                    answersList.insertAdjacentHTML('beforeend', answerHTML)
                }
            }
        })
    }
})

export default consumer
