import consumer from "./consumer"

consumer.subscriptions.create("CommentsChannel", {
    connected() {
        console.log('Connected to comments channel!')
    },

    disconnected() {
    },

    received(data) {
        console.log(data)

        let commentsTagId = '.comments#' + data.klass_name + '-' + data.commentable_id;
        let commentsList = $(commentsTagId + ' ul');
        let newComment = $('<li>').text(data.comment_body);
        let commentInvite = $(commentsTagId + ' span');

        if (commentsList.length) {
                commentsList.append(newComment);
            } else {
                let newList = $('<ul>').append(newComment);
                $(commentsTagId).append(newList);
                commentInvite.hide();
            }
        }
});
