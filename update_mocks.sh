#!/bin/bash

# load and export .env
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

echo "updating sonarr"
times=5
root="./spec/support/requests/sonarr"
mkdir -p "${root}"
for i in $(seq 1 $times); do
    file="/api/v3/history?page=$i"
    curl -X 'GET' "${SONARR_URL}${file}&pageSize=15&includeEpisode=true&includeSeries=true&apikey=${SONARR_API_KEY}" \
        -H 'accept: application/json' >"${root}${file}.json"
done
file="/api/v3/system/status"
curl -X 'GET' "${SONARR_URL}${file}&pageSize=15&includeEpisode=true&includeSeries=true&apikey=${SONARR_API_KEY}" \
    -H 'accept: application/json' >"${root}${file}.json"

echo "updating radarr"
times=3
root="./spec/support/requests/radarr"
mkdir -p "${root}"
for i in $(seq 1 $times); do
    file="/api/v3/history?page=$i"
    curl -X 'GET' "${RADARR_URL}${file}&pageSize=15&includeMovie=true&apikey=${RADARR_API_KEY}" \
        -H 'accept: application/json' >"${root}${file}.json"
done
file="/api/v3/system/status"
curl -X 'GET' "${RADARR_URL}${file}&pageSize=15&includeEpisode=true&includeSeries=true&apikey=${RADARR_API_KEY}" \
    -H 'accept: application/json' >"${root}${file}.json"

echo "updating lidarr"
times=2
root="./spec/support/requests/lidarr"
mkdir -p "${root}"
for i in $(seq 1 $times); do
    file="/api/v1/history?page=$i"
    curl -X 'GET' "${LIDARR_URL}${file}&pageSize=15&includeArtist=true&includeAlbum=true&includeTrack=true&apikey=${LIDARR_API_KEY}" \
        -H 'accept: application/json' >"${root}${file}.json"
done
file="/api/v1/system/status"
curl -X 'GET' "${LIDARR_URL}${file}&pageSize=15&includeEpisode=true&includeSeries=true&apikey=${LIDARR_API_KEY}" \
    -H 'accept: application/json' >"${root}${file}.json"

echo "updating readarr"
root="./spec/support/requests/readarr"
mkdir -p "${root}"
times=2
for i in $(seq 1 $times); do
    file="/api/v1/history?page=$i"
    curl -X 'GET' "${READARR_URL}${file}&pageSize=15&includeAuthor=true&includeBook=true&apikey=${READARR_API_KEY}" \
        -H 'accept: application/json' >"${root}${file}.json"
done
file="/api/v1/system/status"
curl -X 'GET' "${READARR_URL}${file}&pageSize=15&includeEpisode=true&includeSeries=true&apikey=${READARR_API_KEY}" \
    -H 'accept: application/json' >"${root}${file}.json"

echo "updating bazarr"
root="./spec/support/requests/bazarr"
mkdir -p "${root}"
times=2
for i in $(seq 0 $times); do
    pageSize=50
    count=$((i * pageSize))
    file="/api/episodes/history?start=$count"
    curl -X 'GET' "${BAZARR_URL}${file}&length=$pageSize" \
        -H "X-API-KEY: ${BAZARR_API_KEY}" -H 'accept: application/json' >"${root}${file}.json"
done
times=2
for i in $(seq 0 $times); do
    pageSize=50
    count=$((i * pageSize))
    file="/api/movies/history?start=$count"
    curl -X 'GET' "${BAZARR_URL}${file}&length=$pageSize" \
        -H "X-API-KEY: ${BAZARR_API_KEY}" -H 'accept: application/json' >"${root}${file}.json"
done

file="/api/system/status"
curl -X 'GET' "${BAZARR_URL}${file}" \
    -H "X-API-KEY: ${BAZARR_API_KEY}" -H 'accept: application/json' >"${root}${file}.json"

echo "updating mylar3"
root="./spec/support/requests/mylar3"
mkdir -p "${root}"
file="/api?cmd=getHistory"
curl -X 'GET' "${MYLAR3_URL}${file}&apikey=${MYLAR3_API_KEY}" \
    -H 'accept: application/json' >"${root}${file}.json"
file="/api?cmd=getVersion"
curl -X 'GET' "${MYLAR3_URL}${file}&apikey=${MYLAR3_API_KEY}" \
    -H 'accept: application/json' >"${root}${file}.json"
echo "updating tdarr"
root="./spec/support/requests/tdarr"
mkdir -p "${root}/api/v2/client"
times=2
for i in $(seq 0 $times); do
    file="/api/v2/client/jobs?page=$i"
    pageSize=50
    count=$((i * pageSize))
    curl -v -X 'POST' "${TDARR_URL}${file}" \
        -d '{"data":{"start":'"$count"',"pageSize":'$pageSize',"filters":[{"id":"job.type", "value":"transcode"}, {"id": "status", "value":"Transcode success"}],"sorts":[],"opts":{}}}' \
        -H 'accept: application/json' -H 'Content-Type: application/json' >"${root}${file}.json"
done
file="/api/v2/status"
curl -X 'GET' "${TDARR_URL}${file}" \
    -H 'accept: application/json' >"${root}${file}.json"
