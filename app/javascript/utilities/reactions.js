import $ from 'jquery'

document.addEventListener('DOMContentLoaded', () => {
    const reactionElements = document.querySelectorAll('.reaction')

    reactionElements.forEach((reactionElement) => {
        const likeButton = reactionElement.querySelector('.like-btn')
        const dislikeButton = reactionElement.querySelector('.dislike-btn')

        if (likeButton) {
            likeButton.addEventListener('click', (e) => {
                e.preventDefault()
                handleReactionClick(reactionElement, likeButton, 'like')
            })
        }

        if (dislikeButton) {
            dislikeButton.addEventListener('click', (e) => {
                e.preventDefault()
                handleReactionClick(reactionElement, dislikeButton, 'dislike')
            })
        }
    })

    function handleReactionClick(reactionElement, button, reactionType) {
        const resourceId = reactionElement.dataset.reactionableId
        const resourceType = reactionElement.dataset.reactionableType

        const url = `/reactions/4/${reactionType}?reactionable_type=${resourceType}&reactionable_id=${resourceId}`

        $.ajax({
            url: url,
            type: 'PATCH',
            dataType: 'json',
            success: (data) => {
                // Обновляем рейтинг
                const ratingElement = reactionElement.querySelector('.reactions-rating p');
                if (ratingElement) {
                    ratingElement.textContent = `Rating: ${data.rating}`;
                }

                // Переключаем классы кнопок
                updateButtonStyles(button, reactionType, reactionElement);
            },
            error: (err) => {
                console.error('Error:', err);
            }
        });
    }

    function updateButtonStyles(button, reactionType, reactionElement) {
        const likeButton = reactionElement.querySelector('.like-btn');
        const dislikeButton = reactionElement.querySelector('.dislike-btn');

        if (reactionType === 'like') {
            likeButton.classList.remove('btn-outline-success');
            likeButton.classList.add('btn-success');
            dislikeButton.classList.remove('btn-danger');
            dislikeButton.classList.add('btn-outline-danger');
        } else if (reactionType === 'dislike') {
            dislikeButton.classList.remove('btn-outline-danger');
            dislikeButton.classList.add('btn-danger');
            likeButton.classList.remove('btn-success');
            likeButton.classList.add('btn-outline-success');
        }
    }
})