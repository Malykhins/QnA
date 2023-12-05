$(document).on('turbolinks:load', function () {
    $('.container').on('click', '.add-comment-form-link', function (e) {
        e.preventDefault();

        let $link = $(this)
        let resourceId = $link.data('resourceId');
        let commentForm = $('.new-comment#' + resourceId + '-form');

        $link.hide();
        commentForm.find('input[type=text], textarea').val('');
        commentForm.removeClass('hidden');

        commentForm.on('submit', 'form', function () {
            commentForm.addClass('hidden');
            $link.show();
        });
    });
});

