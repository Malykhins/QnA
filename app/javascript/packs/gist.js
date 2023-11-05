$(document).on('turbolinks:load ajax:success', function applyGistClient() {
    const GistClient = require("gist-client")
    const gistClient = new GistClient()

    // Получите все ссылки на странице
    const links = $('a');

    // Пройдитесь по каждой ссылке и проверьте, ведет ли она на Gist
    links.each((index, link) => {
        const href = $(link).attr('href');

        // Проверьте, содержит ли ссылка 'gist.github.com'
        if (href && typeof href === 'string' && href.includes('gist.github.com')) {
            const gistContainer = $('<div></div>');
            $(link).replaceWith(gistContainer);

            // Получите ID Gist из ссылки
            const gistId = href.split('/').pop();

            // Загрузите содержимое Gist и отобразите его в созданном контейнере
            gistClient.setToken(process.env.GIST_TOKEN).getOneById(gistId)
                .then(response  => {
                    let fileKeys = Object.keys(response.files)
                    let firstFileKey = fileKeys[0]
                    gistContainer.append(response.files[firstFileKey].content);
                })
                .catch(error => {
                    console.log('Error fetching gist:', error);
                });

        }
    });
});
