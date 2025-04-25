import $ from 'jquery'

document.addEventListener('DOMContentLoaded', () => {
    $('.comments').on('click', '.add-comment-link', function (e) {
        e.preventDefault()
        const commentableId = $(this).data('commentableId')
        $(this).addClass('d-none')
        $(`.comment-form-container[data-commentable-id="${commentableId}"]`).removeClass('d-none')
    })

    $('form').on('ajax:success', (event) => {
        const form = event.currentTarget
        const formId = $(form).attr('id')
        const commentableId = formId.split('-')[1]
        const commentErrors = document.querySelector('.comment-errors')

        if (!commentErrors || commentErrors.children.length === 0) {
            $(`.comment-form-container[data-commentable-id="${commentableId}"]`).addClass('d-none')
            $(`.add-comment-link[data-commentable-id="${commentableId}"]`).removeClass('d-none')
        }
    })
})
