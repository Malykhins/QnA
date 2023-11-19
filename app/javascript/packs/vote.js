$(document).on('turbolinks:load', function () {
    $('.vote, .unvote').on('ajax:success', displayRating)
        .on('page:update', displayRating)
        .on('ajax:error', displayErrors)

})

function displayRating (e) {
    console.log(e.detail)
    let rating = e.detail[0].rating;
    let resourceName = e.detail[0].resource_name;
    let resourceId = e.detail[0].resource_id;
    let alreadyVoted = e.detail[0].already_voted;
    let ratingTagName = '.rating' + '#' + resourceName + '-' + resourceId
    let voteTagName = '.vote' + '#' + resourceName + '-' + resourceId + '-' + 'like-dislike'
    let unvoteTagName = '.unvote' + '#' + resourceName + '-' + resourceId + '-' + 'unvote'

    $(ratingTagName).text('Rating: ' + rating);

    if (alreadyVoted) {
        console.log(alreadyVoted)
        $(unvoteTagName).removeClass('hidden')
        $(voteTagName).addClass('hidden')
    } else {console.log(alreadyVoted)
        $(unvoteTagName).addClass('hidden')
        $(voteTagName).removeClass('hidden')
    }
}

function displayErrors (e) {
    console.log(e.detail)
    let message = e.detail[0].error_message;
    console.log(message)
    let resourceName = e.detail[0].resource_name;
    let resourceId = e.detail[0].resource_id;
    let errorTagName = '.errors-vote' + '#' + resourceName + '-' + resourceId + '-' + 'error'
    $(errorTagName).html(message);
}
