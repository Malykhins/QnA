import consumer from "./consumer"

consumer.subscriptions.create("CommentsChannel", {
    connected() {
        console.log('Connected to comments channel!')
        // Called when the subscription is ready for use on the server
    },

    disconnected() {
        // Called when the subscription has been terminated by the server
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
