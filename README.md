# summarizarr

<img src="./badges/badge-branches.svg" alt="Alt text" >
<img src="./badges/badge-lines.svg" alt="Alt text"  >

* supports sonarr
* supports radarr
* supports bazarr
* supports lidarr

TODO:

* support readarr
* support mymar
* support tdarr
* improve the notification contents

## Envs

copy the `.env.dist` to `.env` and fill out

NOTE: if you using the env file you need to quote your variables, if your providing the env file to docker directly you don't

| Env            | Required?                         | Default                | Description                      |
| -------------- | --------------------------------- | ---------------------- | -------------------------------- |
| RADARR_URL     | only if you want radarr summaries | '<http://radarr:7878>' | Url to your radarr instance      |
|                |                                   |                        |                                  |
| RADARR_API_KEY | only if you want radarr summaries | '12345'                | api key for your radarr instance |
|                |                                   |                        |                                  |
| SONARR_URL     | only if you want sonarr summaries | '<http://sonarr:8989>' | Url to your sonarr instance      |
|                |                                   |                        |                                  |
| SONARR_API_KEY | only if you want sonarr summaries | '12345'                | api key for your sonarr instance |
|                |                                   |                        |                                  |
| BAZARR_URL     | only if you want bazarr summaries | '<http://bazarr:8989>' | Url to your bazarr instance      |
|                |                                   |                        |                                  |
| BAZARR_API_KEY | only if you want bazarr summaries | '12345'                | api key for your bazarr instance |
|                |                                   |                        |                                  |
| LIDARR_URL     | only if you want lidarr summaries | '<http://lidarr:8686>' | Url to your lidarr instance      |
|                |                                   |                        |                                  |
| LIDARR_API_KEY | only if you want lidarr summaries | '12345'                | api key for your lidarr instance |
|                |                                   |                        |                                  |
| SUMMARY_DAYS   | no                                | '7'                    | The amount of days to summarise  |
|                |                                   |                        |                                  |

## Running

### Docker

* `make build`
* `make run-image`

OR

`docker run ghcr.io/phyzical/summarizarr -t summarizarr`

## Local

* `bundle`
* `make run`
