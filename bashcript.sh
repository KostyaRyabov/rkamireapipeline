INPUT_VAR=$1
RELEASE_VAR=$2

echo Test ID: ${INPUT_VAR}

RELEASE_URL="${SYSTEM_TEAMFOUNDATIONSERVERURI}${SYSTEM_TEAMPROJECTID}/_apis/release/releases/${RELEASE_RELEASEID}?api-version=5.0"

echo release url: $RELEASE_URL

RELEASE_JSON=$(curl -H "Authorization: Bearer $SYSTEM_ACCESSTOKEN" $RELEASE_URL)

OUTPUT=`jq ''.variables.${RELEASE_VAR}.value' = '\"${INPUT_VAR}\"'' <<< $RELEASE_JSON`

curl -H "Authorization: Bearer $SYSTEM_ACCESSTOKEN" -H "Content-Type: application/json" -X PUT -d "$OUTPUT" $RELEASE_URL
