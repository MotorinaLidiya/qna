import $ from 'jquery'

document.addEventListener('DOMContentLoaded', () => {
    const questionsAttr = document.querySelector('.questions')
    if (questionsAttr) {
        questionsAttr.addEventListener('click', (e) => {
            let clickedObject = e.target
            if (clickedObject.classList.contains('edit-question-link')) {
                e.preventDefault()
                const questionId = clickedObject.dataset.questionId
                $(clickedObject).hide()
                $(`form#edit-question-${questionId}`).removeClass('d-none')
            }
        })
    }
})
