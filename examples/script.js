const body = "hello world"

addEventListener.call(null, "fetch", function (event) {
  'blah';
  event.respondWith(body)
})