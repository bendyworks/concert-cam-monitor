A small dashboard to watch a Facebook album with the Facebook Graph API.

Built on [Dashing](http://shopify.github.io/dashing/).

## Usage

### Switching to a new event album

When a new Live on King Street rolls around, the app will need to be updated to watch the new album. After you've created the Facebook album, grab the album ID (it will be an integer, like `299717620200480`). You might need to use the Graph API to find the new album ID: https://graph.facebook.com/ConcertCam/albums

Then set the album ID like this (assuming your Heroku remote is set up correctly)

```bash
heroku config:set ALBUM_ID=299717620200480`
```

The app will reboot automatically to track the new album.

## License

Copyright 2014 Bendyworks

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
