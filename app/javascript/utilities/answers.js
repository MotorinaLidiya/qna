import $ from 'jquery'

document.addEventListener('DOMContentLoaded', () => {
    const answersAttr = document.querySelector('.answers')
    if (answersAttr) {
        answersAttr.addEventListener('click', (e) => {
            let clickedObject = e.target
            if (clickedObject.classList.contains('edit-answer-link')) {
                e.preventDefault()
                const answerId = clickedObject.dataset.answerId
                $(clickedObject).hide()
                $(`form#edit-answer-${answerId}`).removeClass('d-none')
            }
        })
    }

    $('form').on('ajax:success', (event) => {
        const form = event.currentTarget

        $(form).find('.nested-fields input[type="text"]').val('')
    })
})
