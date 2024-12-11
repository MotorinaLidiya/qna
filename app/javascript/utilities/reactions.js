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

        const url = `/reactions/${reactionType}?reactionable_type=${resourceType}&reactionable_id=${resourceId}`

        $.ajax({
            url: url,
            type: 'PATCH',
            dataType: 'json',
            success: (data) => {
                const ratingElement = reactionElement.querySelector('.reactions-rating p');
                if (ratingElement) {
                    ratingElement.textContent = `Rating: ${data.rating}`;
                }

                updateButtonStyles(button, reactionType, reactionElement);
            },
            error: (err) => {
                console.error('Error:', err);
            }
        });
    }

    function switchButtonStyle(button, color1, color2) {
        if (button.classList.contains(color1)) {
            button.classList.add(color2);
            button.classList.remove(color1);
        } else {
            button.classList.remove(color2);
            button.classList.add(color1);
        }
    }

    function updateButtonStyles(button, reactionType, reactionElement) {
        const likeButton = reactionElement.querySelector('.like-btn');
        const dislikeButton = reactionElement.querySelector('.dislike-btn');

        if (reactionType === 'like') {
            switchButtonStyle(likeButton, 'btn-success', 'btn-outline-success')

            dislikeButton.classList.remove('btn-danger');
            dislikeButton.classList.add('btn-outline-danger');
        } else if (reactionType === 'dislike') {
            switchButtonStyle(dislikeButton, 'btn-danger', 'btn-outline-danger')

            likeButton.classList.remove('btn-success');
            likeButton.classList.add('btn-outline-success');
        }
    }
})