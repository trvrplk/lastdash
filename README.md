# LastDash

This is a little passion project of mine. I haven't done programming in a while, but I've been really wanting a nice Last.fm dashboard--something like a homepage showing me what I and my friends are listening to, perhaps with some other interesting data. There are some precidents here: Jake Ledoux's [Last.fm Live](https://jakeledoux.com/live/) is a decently well-known tool that's similar, and Matthias Loibl has [a little thing](https://lastfm.matthiasloibl.com) that's very close to what I'd like. I don't expect people to be able to help me too much, since I'm having a hard time describing exactly what I'm talking about, but if you'd like to help you're welcome to do so. Just make sure to create a `lastfm.yml` file with an `api_key` and `api_secret` attribute. (I don't want to release mine, of course.)

## Hopes for the future

- Nice styling
- Unified page (ie. not two separate interfaces for your now-playing and your friends', as well as an index page where you can enter your username)
- Performance improvements--possibly moving to a Redis system to store results rather than just as part of the HTML; hopefully also a way to find which friends are online without having to get each friend's recent tracks and checking there, as that would reduce the number of requests needed to be sent and documents to be parsed

## Known Bugs

- Users with no friends break the "all" dashboard because there's no array of friends to loop through

## Licensing

> Copyright 2020 trvrplk
>
> Licensed under the Apache License, Version 2.0 (the "License");
> you may not use this file except in compliance with the License.
> You may obtain a copy of the License at
>
>    http://www.apache.org/licenses/LICENSE-2.0
>
> Unless required by applicable law or agreed to in writing, software
> distributed under the License is distributed on an "AS IS" BASIS,
> WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
> See the License for the specific language governing permissions and
> limitations under the License.

I'm using the Apache license because I feel it covers all the right bases, but really I don't think it'll ever come down to me actually needing to enforce anything. Just don't be an ass.
