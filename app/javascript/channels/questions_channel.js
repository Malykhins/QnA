import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
    connected() {
        console.log('Connected to questions_channel!')
    },

    disconnected() {
        // Called when the subscription has been terminated by the server
    },

    received(data) {
        console.log(data)
        $('.questions').append(data['partial']);
    }
});

