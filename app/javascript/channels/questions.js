import { createConsumer } from "@rails/actioncable"

const consumer = createConsumer()

consumer.subscriptions.create("QuestionsChannel", {
    received(data) {
        const questionHTML = data.html;
        const questionsList = document.querySelector('.questions-list');
        if (questionsList) {
            questionsList.insertAdjacentHTML('beforeend', questionHTML);
        }
    }
})

export default consumer
