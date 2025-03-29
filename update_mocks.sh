#!/bin/bash

# load and export .env
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

# TODO: we should be able to use vcr instead
echo "updating sonarr"
times=45
for i in $(seq 1 $times); do
    file="/api/v3/history?page=$i"
    curl -X 'GET' "${SONARR_URL}${file}&pageSize=15&includeEpisode=true&includeSeries=true&apikey=${SONARR_API_KEY}" \
        -H 'accept: application/json' >"./spec/support/requests/sonarr${file}.json"
done

echo "updating radarr"
times=3
for i in $(seq 1 $times); do
    file="/api/v3/history?page=$i"
    curl -X 'GET' "${RADARR_URL}${file}&pageSize=15&includeMovie=true&apikey=${RADARR_API_KEY}" \
        -H 'accept: application/json' >"./spec/support/requests/radarr${file}.json"
done

echo "updating lidarr"
times=2
for i in $(seq 1 $times); do
    file="/api/v1/history?page=$i"
    curl -X 'GET' "${LIDARR_URL}${file}&pageSize=15&includeArtist=true&includeAlbum=true&includeTrack=true&apikey=${LIDARR_API_KEY}" \
        -H 'accept: application/json' >"./spec/support/requests/lidarr${file}.json"
done

echo "updating readarr"
times=2
for i in $(seq 1 $times); do
    file="/api/v1/history?page=$i"
    curl -X 'GET' "${READARR_URL}${file}&pageSize=15&includeAuthor=true&includeBook=true&apikey=${READARR_API_KEY}" \
        -H 'accept: application/json' >"./spec/support/requests/readarr${file}.json"
done

echo "updating bazarr"
file="/api/episodes/history"
curl -X 'GET' "${BAZARR_URL}${file}?length=5000" \
    -H "X-API-KEY: ${BAZARR_API_KEY}" -H 'accept: application/json' >"./spec/support/requests/bazarr${file}.json"
file="/api/movies/history"
curl -X 'GET' "${BAZARR_URL}${file}?length=5000" \
    -H "X-API-KEY: ${BAZARR_API_KEY}" -H 'accept: application/json' >"./spec/support/requests/bazarr${file}.json"
