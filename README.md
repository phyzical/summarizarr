# summarizarr

<img src="./badges/badge-branches.svg" alt="Alt text" >
<img src="./badges/badge-lines.svg" alt="Alt text"  >

* supports [sonarr](https://github.com/Sonarr/Sonarr)
* supports [radarr](https://github.com/Radarr/Radarr)
* supports [bazarr](https://github.com/morpheus65535/bazarr)
* supports [lidarr](https://github.com/Lidarr/Lidarr)
* supports [readarr](https://github.com/Radarr/Radarr)
* supports [mylar3](https://github.com/mylar3/mylar3)

TODO:

* support [tdarr](https://github.com/HaveAGitGat/Tdarr)
* improve the notification contents

## Envs

copy the `.env.dist` to `.env` and fill out

NOTE: if you using the env file you need to quote your variables, if your providing the env file to docker directly you don't

| Env                 | Required?                          | Default                 | Description                             |
| ------------------- | ---------------------------------- | ----------------------- | --------------------------------------- |
| RADARR_URL          | only if you want radarr summaries  | '<http://radarr:7878>'  | Url to your radarr instance             |
|                     |                                    |                         |                                         |
| RADARR_API_KEY      | only if you want radarr summaries  | '12345'                 | api key for your radarr instance        |
|                     |                                    |                         |                                         |
| SONARR_URL          | only if you want sonarr summaries  | '<http://sonarr:8989>'  | Url to your sonarr instance             |
|                     |                                    |                         |                                         |
| SONARR_API_KEY      | only if you want sonarr summaries  | '12345'                 | api key for your sonarr instance        |
|                     |                                    |                         |                                         |
| BAZARR_URL          | only if you want bazarr summaries  | '<http://bazarr:8989>'  | Url to your bazarr instance             |
|                     |                                    |                         |                                         |
| BAZARR_API_KEY      | only if you want bazarr summaries  | '12345'                 | api key for your bazarr instance        |
|                     |                                    |                         |                                         |
| LIDARR_URL          | only if you want lidarr summaries  | '<http://lidarr:8686>'  | Url to your lidarr instance             |
|                     |                                    |                         |                                         |
| LIDARR_API_KEY      | only if you want lidarr summaries  | '12345'                 | api key for your lidarr instance        |
|                     |                                    |                         |                                         |
| READARR_URL         | only if you want readarr summaries | '<http://readarr:8787>' | Url to your readarr instance            |
|                     |                                    |                         |                                         |
| READARR_API_KEY     | only if you want readarr summaries | '12345'                 | api key for your readarr instance       |
|                     |                                    |                         |                                         |
| MYLAR3_URL          | only if you want mylar3 summaries  | '<http://mylar3:8090>'  | Url to your mylar3 instance             |
|                     |                                    |                         |                                         |
| MYLAR3_API_KEY      | only if you want mylar3 summaries  | '12345'                 | api key for your mylar3 instance        |
|                     |                                    |                         |                                         |
| DISCORD_WEBHOOK_URL | If not provided stdout is used     | ''                      | webhook url to send the notification to |
|                     |                                    |                         | Note: this should work for any webhook  |
|                     |                                    |                         |                                         |
| SUMMARY_DAYS        | no                                 | '7'                     | The amount of days to summarise         |
|                     |                                    |                         |                                         |

## Running

### Docker

* `make build`
* `make run-image`

OR

`docker run ghcr.io/phyzical/summarizarr -t summarizarr`

## Local

* `bundle`
* `make run`
