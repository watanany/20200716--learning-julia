module Bookmarks
    using Printf: @sprintf

    function index(page::Int)::String
        @sprintf("http://www.pixiv.net/bookmark.php?rest=show&p=%d", page)
    end
end
