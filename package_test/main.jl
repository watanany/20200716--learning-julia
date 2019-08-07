#!/usr/bin/env julia
include("pixiv/lib/pixiv.jl")


config = Pixiv.Types.ClientConfig(ENV["PIXIV_ID"], ENV["PIXIV_PASSWORD"])
cli = Pixiv.Types.Client(config)
Pixiv.Auths.login!(cli)
sleep(3)
Pixiv.Bookmarks.autotag!(cli)
