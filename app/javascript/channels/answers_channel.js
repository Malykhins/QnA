import consumer from "./consumer"

document.addEventListener('turbolinks:load', function() {
    consumer.subscriptions.create({channel: "AnswersChannel", id: gon.question_id}, {
        connected() {
            console.log('Connected to the answers channel!')
            // Called when the subscription is ready for use on the server
        },

        disconnected() {
            // Called when the subscription has been terminated by the server
        },

        received(data) {
            console.log(data)

            let commentInviteTagName = '.comments#' + 'answer-' + data.answer_id
            // let VoteTagName = '.vote#' + 'answer-' + data.answer_id + '-like-dislike'

            if (gon.current_user_id !== data.answer_author_id) {
                $('.answers').append(data['partial']);
                $(commentInviteTagName).html('<b>Comment: </b><span>No comments! Be the first!</span>');

                // $(VoteTagName).trigger("ajax:success")
            }
        }
    })
})

