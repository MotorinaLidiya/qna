import $ from 'jquery'

document.addEventListener('DOMContentLoaded', () => {
    document.querySelector('.answers').addEventListener('click', (e) => {
        let clickedObject = e.target
        if (clickedObject.classList.contains('edit-answer-link')) {
            e.preventDefault();
            const answerId = clickedObject.dataset.answerId;
            $(clickedObject).hide()
            $(`form#edit-answer-${answerId}`).removeClass('d-none')
        }
    });
});
