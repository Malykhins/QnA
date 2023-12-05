import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
    connected() {
        console.log('Connected to questions_channel!')
    },

    disconnected() {
    },

    received(data) {
        console.log(data)
        $('.questions').append(data['partial']);
    }
});
