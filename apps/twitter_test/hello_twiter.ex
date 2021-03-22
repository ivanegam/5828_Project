#use extwitter

#defmodule TwitterApi do
#  def configure() do
ExTwitter.configure(
  [consumer_key: "",
  consumer_secret: "",
  access_token: "",
  access_token_secret: "" ])
#    end
#end




defmodule Forever do
  def loop() do
    IO.puts("running")
    stream = ExTwitter.stream_filter(track: ["#covid", "#vaccine"]) |>
      Stream.map(fn(x) -> x.text end) |>
      Stream.map(fn(x) -> IO.puts "#{x}\n---------------\n" end)
    Enum.to_list(stream)

    loop
  end
end

Forever.loop()
