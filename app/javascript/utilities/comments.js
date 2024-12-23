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
        const commentErrors = document.querySelector('.comment-errors')

        if (!commentErrors || commentErrors.children.length === 0) {
            $(form).closest('.comment-form-container').addClass('d-none')
            $('.add-comment-link').removeClass('d-none')
        }
    })
})
