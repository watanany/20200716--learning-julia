using HTTP: request
using Gumbo: parsehtml


res = request("GET", "https://www.yahoo.co.jp")
doc = parsehtml(res.body |> String)
@show doc
