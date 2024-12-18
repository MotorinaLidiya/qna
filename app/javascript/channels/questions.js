import { createConsumer } from "@rails/actioncable"

const consumer = createConsumer()

consumer.subscriptions.create("QuestionsChannel", {
    received(data) {
        console.log(data)
        const questionHTML = data.html;
        const questionData = data

        const questionsList = document.querySelector('.questions-list');
        if (questionsList) {
            questionsList.insertAdjacentHTML('beforeend', questionHTML);
        }

        console.log(questionData)
    }
})

export default consumer
