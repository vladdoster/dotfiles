#!/usr/bin/env bash -e

###################
# ARRAY UTILITIES #
###################

arrayToParameters() {
  local -r array=("${@}")

  local -r string="$(printf "'%s' " "${array[@]}")"

  echo "${string:0:${#string}-1}"
}

arrayToString() {
  local -r array=("${@}")

  arrayToStringWithDelimiter ',' "${array[@]}"
}

arrayToStringWithDelimiter() {
  local -r delimiter="${1}"
  local -r list=("${@:2}")

  local -r string="$(printf "%s${delimiter}" "${list[@]}")"

  echo "${string:0:${#string}-${#delimiter}}"
}

excludeElementFromArray() {
  local -r element="${1}"
  local array=("${@:2}")

  local i=0

  for ((i = 0; i < ${#array[@]}; i = i + 1)); do
    if [[ ${array[i]} == "${element}" ]]; then
      unset array['${i}']
    fi
  done

  echo "${array[@]}"
}

isElementInArray() {
  local -r element="${1}"
  local -r array=("${@:2}")

  local walker=''

  for walker in "${array[@]}"; do
    [[ ${walker} == "${element}" ]] && echo 'true' && return 0
  done

  echo 'false' && return 1
}

sortUniqArray() {
  local -r array=("${@}")

  trimString "$(tr ' ' '\n' <<< "${array[@]}" | sort -u | tr '\n' ' ')"
}

#####################
# COMPILE UTILITIES #
#####################

compileAndInstallFromSource() {
  local -r downloadURL="${1}"
  local -r installFolderPath="${2}"
  local -r installFileOrFolderBinPath="${3}"
  local -r user="${4}"

  initializeFolder "${installFolderPath}"

  local -r currentWorkingDirectory="$(pwd)"
  local -r tempFolder="$(getTemporaryFolder)"

  unzipRemoteFile "${downloadURL}" "${tempFolder}"
  cd "${tempFolder}"
  "${tempFolder}/configure" --prefix="${installFolderPath}"
  make
  make install
  chown -R "${user}:$(getUserGroupName "${user}")" "${installFolderPath}"
  symlinkUsrBin "${installFileOrFolderBinPath}"
  cd "${currentWorkingDirectory}"
  rm -f -r "${tempFolder}"
}

#######################
# DATE TIME UTILITIES #
#######################

convertISO8601ToSeconds() {
  local -r time="${1}"

  if [[ "$(isMacOperatingSystem)" == 'true' ]]; then
    date -j -u -f '%FT%T' "$(awk -F '.' '{ print $1 }' <<< "${time}" | tr -d 'Z')" +'%s'
  elif [[ "$(isAmazonLinuxDistributor)" == 'true' || "$(isCentOSDistributor)" == 'true' || "$(isRedHatDistributor)" == 'true' || "$(isUbuntuDistributor)" == 'true' ]]; then
    date -d "${time}" +'%s'
  else
    fatal '\nFATAL : only support Amazon-Linux, CentOS, Mac, RedHat, or Ubuntu OS'
  fi
}

getISO8601DateTimeNow() {
  date -u +'%Y-%m-%dT%H:%M:%SZ'
}

getUTCNowInSeconds() {
  date -u +'%s'
}

secondsToReadableTime() {
  local -r time="${1}"

  local -r day="$((time / 60 / 60 / 24))"
  local -r hour="$((time / 60 / 60 % 24))"
  local -r minute="$((time / 60 % 60))"
  local -r second="$((time % 60))"

  if [[ ${day} == '0' ]]; then
    printf '%02d:%02d:%02d' "${hour}" "${minute}" "${second}"
  elif [[ ${day} == '1' ]]; then
    printf '%d day and %02d:%02d:%02d' "${day}" "${hour}" "${minute}" "${second}"
  else
    printf '%d days and %02d:%02d:%02d' "${day}" "${hour}" "${minute}" "${second}"
  fi
}

########################
# FILE LOCAL UTILITIES #
########################

appendToFileIfNotFound() {
  local -r file="${1}"
  local -r pattern="${2}"
  local -r string="${3}"
  local -r patternAsRegex="${4}"
  local -r stringAsRegex="${5}"
  local -r addNewLine="${6}"

  # Validate Inputs

  checkExistFile "${file}"
  checkNonEmptyString "${pattern}" 'undefined pattern'
  checkNonEmptyString "${string}" 'undefined string'
  checkTrueFalseString "${patternAsRegex}"
  checkTrueFalseString "${stringAsRegex}"

  if [[ ${stringAsRegex} == 'false' ]]; then
    checkTrueFalseString "${addNewLine}"
  fi

  # Append String

  if [[ ${patternAsRegex} == 'true' ]]; then
    local -r found="$(grep -E -o "${pattern}" "${file}")"
  else
    local -r found="$(grep -F -o "${pattern}" "${file}")"
  fi

  if [[ "$(isEmptyString "${found}")" == 'true' ]]; then
    if [[ ${stringAsRegex} == 'true' ]]; then
      echo -e "${string}" >> "${file}"
    else
      if [[ ${addNewLine} == 'true' ]]; then
        echo >> "${file}"
      fi

      echo "${string}" >> "${file}"
    fi
  fi
}

checkExistFile() {
  local -r file="${1}"
  local -r errorMessage="${2}"

  if [[ ${file} == '' || ! -f ${file} ]]; then
    if [[ "$(isEmptyString "${errorMessage}")" == 'true' ]]; then
      fatal "\nFATAL : file '${file}' not found"
    fi

    fatal "\nFATAL : ${errorMessage}"
  fi
}

checkExistFolder() {
  local -r folder="${1}"
  local -r errorMessage="${2}"

  if [[ ${folder} == '' || ! -d ${folder} ]]; then
    if [[ "$(isEmptyString "${errorMessage}")" == 'true' ]]; then
      fatal "\nFATAL : folder '${folder}' not found"
    fi

    fatal "\nFATAL : ${errorMessage}"
  fi
}

checkValidJSONContent() {
  local -r content="${1}"

  if [[ "$(isValidJSONContent "${content}")" == 'false' ]]; then
    fatal '\nFATAL : invalid JSON'
  fi
}

checkValidJSONFile() {
  local -r file="${1}"

  if [[ "$(isValidJSONFile "${file}")" == 'false' ]]; then
    fatal "\nFATAL : invalid JSON file '${file}'"
  fi
}

cleanUpSystemFolders() {
  header 'CLEANING UP SYSTEM FOLDERS'

  local -r folders=(
    '/tmp'
    '/var/tmp'
  )

  local folder=''

  for folder in "${folders[@]}"; do
    echo "Cleaning up folder '${folder}'"
    emptyFolder "${folder}"
  done
}

copyFolderContent() {
  local -r sourceFolder="${1}"
  local -r destinationFolder="${2}"

  checkExistFolder "${sourceFolder}"
  checkExistFolder "${destinationFolder}"

  find "${sourceFolder}" \
    -mindepth 1 \
    -maxdepth 1 \
    -exec cp -p -r '{}' "${destinationFolder}" \;
}

createAbsoluteUsrBin() {
  local -r binFileName="${1}"
  local -r sourceFilePath="${2}"

  checkExistFile "${sourceFilePath}"

  mkdir -p '/usr/bin'
  printf "#!/bin/bash -e\n\n'%s' \"\${@}\"" "${sourceFilePath}" > "/usr/bin/${binFileName}"
  chmod 755 "/usr/bin/${binFileName}"
}

createFileFromTemplate() {
  local -r sourceFile="${1}"
  local -r destinationFile="${2}"
  local -r oldNewData=("${@:3}")

  checkExistFile "${sourceFile}"
  checkExistFolder "$(dirname "${destinationFile}")"

  local content=''
  content="$(cat "${sourceFile}")"

  local i=0

  for ((i = 0; i < ${#oldNewData[@]}; i = i + 2)); do
    content="$(replaceString "${content}" "${oldNewData[${i}]}" "${oldNewData[i + 1]}")"
  done

  echo "${content}" > "${destinationFile}"
}

createInitFileFromTemplate() {
  local -r serviceName="${1}"
  local -r templateFolderPath="${2}"
  local -r initConfigDataFromTemplate=("${@:3}")

  createFileFromTemplate \
    "${templateFolderPath}/${serviceName}.service.systemd" \
    "/etc/systemd/system/${serviceName}.service" \
    "${initConfigDataFromTemplate[@]}"
}

deleteOldLogs() {
  local logFolderPaths=("${@}")

  header 'DELETING OLD LOGS'

  # Default Log Folder Path

  if [[ ${#logFolderPaths[@]} -lt '1' ]]; then
    logFolderPaths+=('/var/log')
  fi

  # Walk Each Log Folder Path

  local i=0

  for ((i = 0; i < ${#logFolderPaths[@]}; i = i + 1)); do
    checkExistFolder "${logFolderPaths[i]}"

    find \
      -L \
      "${logFolderPaths[i]}" \
      -type f \
      \( \
      -regex '.*-[0-9]+' -o \
      -regex '.*\.[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]\.log' -o \
      -regex '.*\.[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]\.txt' -o \
      -regex '.*\.[0-9]+' -o \
      -regex '.*\.[0-9]+\.log' -o \
      -regex '.*\.gz' -o \
      -regex '.*\.log\.[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]T[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' -o \
      -regex '.*\.old' -o \
      -regex '.*\.xz' \
      \) \
      -delete \
      -print
  done
}

emptyFolder() {
  local -r folder="${1}"

  checkExistFolder "${folder}"

  find "${folder}" \
    -mindepth 1 \
    -delete
}

getFileExtension() {
  local -r string="${1}"

  local -r fullFileName="$(basename "${string}")"

  echo "${fullFileName##*.}"
}

getFileName() {
  local -r string="${1}"

  local -r fullFileName="$(basename "${string}")"

  echo "${fullFileName%.*}"
}

getTemporaryFile() {
  local extension="${1}"

  if [[ "$(isEmptyString "${extension}")" == 'false' && "$(grep -i -o "^." <<< "${extension}")" != '.' ]]; then
    extension=".${extension}"
  fi

  mktemp "$(getTemporaryFolderRoot)/$(date +'%Y%m%d-%H%M%S')-XXXXXXXXXX${extension}"
}

getTemporaryFolder() {
  mktemp -d "$(getTemporaryFolderRoot)/$(date +'%Y%m%d-%H%M%S')-XXXXXXXXXX"
}

getTemporaryFolderRoot() {
  local temporaryFolder='/tmp'

  if [[ "$(isEmptyString "${TMPDIR}")" == 'false' ]]; then
    temporaryFolder="$(formatPath "${TMPDIR}")"
  fi

  echo "${temporaryFolder}"
}

initializeFolder() {
  local -r folder="${1}"

  if [[ -d ${folder} ]]; then
    emptyFolder "${folder}"
  else
    mkdir -p "${folder}"
  fi
}

isEmptyFolder() {
  local -r folderPath="${1}"

  checkExistFolder "${folderPath}"

  if [[ "$(isEmptyString "$(find "${folderPath}" -maxdepth 1 -mindepth 1)")" == 'true' ]]; then
    echo 'true' && return 0
  fi

  echo 'false' && return 1
}

isValidJSONContent() {
  local -r content="${1}"

  if (python -m 'json.tool' <<< "${content}" &> '/dev/null' || python3 -m 'json.tool' <<< "${content}" &> '/dev/null'); then
    echo 'true' && return 0
  fi

  echo 'false' && return 1
}

isValidJSONFile() {
  local -r file="${1}"

  checkExistFile "${file}"

  isValidJSONContent "$(cat "${file}")"
}

moveFolderContent() {
  local -r sourceFolder="${1}"
  local -r destinationFolder="${2}"

  checkExistFolder "${sourceFolder}"
  checkExistFolder "${destinationFolder}"

  find "${sourceFolder}" \
    -mindepth 1 \
    -maxdepth 1 \
    -exec mv '{}' "${destinationFolder}" \;
}

redirectOutputToLogFile() {
  local -r logFile="${1}"

  mkdir -p "$(dirname "${logFile}")"
  exec > >(tee -a "${logFile}") 2>&1
}

resetFolderPermission() {
  local -r folderPath="${1}"
  local -r userLogin="${2}"
  local -r groupName="${3}"

  checkExistFolder "${folderPath}"
  checkExistUserLogin "${userLogin}"
  checkExistGroupName "${groupName}"

  header "RESETTING FOLDER PERMISSION ${folderPath}"

  chown -R "${userLogin}:${groupName}" "${folderPath}"

  find "${folderPath}" \
    -type d \
    \( \
    -not -path "*/.git" -a \
    -not -path "*/.git/*" \
    \) \
    -exec chmod 700 '{}' \; \
    -print

  find "${folderPath}" \
    -type f \
    \( \
    -not -path "*/.git" -a \
    -not -path "*/.git/*" \
    \) \
    -exec chmod 600 '{}' \; \
    -print
}

resetLogs() {
  local logFolderPaths=("${@}")

  # Default Log Folder Path

  if [[ ${#logFolderPaths[@]} -lt '1' ]]; then
    logFolderPaths+=('/var/log')
  fi

  # Delete Old Logs

  deleteOldLogs "${logFolderPaths[@]}"

  # Reset Logs

  header 'RESETTING LOGS'

  local i=0

  for ((i = 0; i < ${#logFolderPaths[@]}; i = i + 1)); do
    checkExistFolder "${logFolderPaths[i]}"

    find "${logFolderPaths[i]}" \
      -type f \
      -exec cp -f '/dev/null' '{}' \; \
      -print
  done
}

sortUniqueTrimFile() {
  local -r filePath="${1}"

  checkExistFile "${filePath}"

  printf '%s' "$(awk 'NF' "${filePath}" | awk '{$1=$1};1' | sort -u)" > "${filePath}"
}

symlinkListUsrBin() {
  local -r sourceFilePaths=("${@}")

  local sourceFilePath=''

  for sourceFilePath in "${sourceFilePaths[@]}"; do
    chmod 755 "${sourceFilePath}"
    rm -f -r "/usr/bin/$(basename "${sourceFilePath}")"
    ln -f -s "${sourceFilePath}" "/usr/bin/$(basename "${sourceFilePath}")"
  done
}

symlinkUsrBin() {
  local -r sourceBinFileOrFolder="${1}"

  if [[ "$(isMacOperatingSystem)" == 'true' ]]; then
    mkdir -p '/usr/bin'

    if [[ -d ${sourceBinFileOrFolder} ]]; then
      find "${sourceBinFileOrFolder}" -maxdepth 1 \( -type f -o -type l \) -perm -u+x -exec bash -c -e '
                for file
                do
                    fileType="$(stat -f "%HT" "${file}")"

                    if [[ "${fileType}" = "Regular File" ]]
                    then
                        ln -f -s "${file}" "/usr/bin/$(basename "${file}")"
                    elif [[ "${fileType}" = "Symbolic Link" ]]
                    then
                        cd "$(dirname "${file}")"

                        if [[ -f "$(readlink "${file}")" ]]
                        then
                            ln -f -s "${file}" "/usr/bin/$(basename "${file}")"
                        fi
                    fi
      done' bash '{}' \;
    elif [[ -f ${sourceBinFileOrFolder} ]]; then
      ln -f -s "${sourceBinFileOrFolder}" "/usr/bin/$(basename "${sourceBinFileOrFolder}")"
    else
      fatal "\nFATAL : '${sourceBinFileOrFolder}' is not directory or file"
    fi
  elif [[ "$(isAmazonLinuxDistributor)" == 'true' || "$(isCentOSDistributor)" == 'true' || "$(isRedHatDistributor)" == 'true' || "$(isUbuntuDistributor)" == 'true' ]]; then
    mkdir -p '/usr/bin'

    if [[ -d ${sourceBinFileOrFolder} ]]; then
      find "${sourceBinFileOrFolder}" -maxdepth 1 -xtype f -perm -u+x -exec bash -c -e '
                for file
                do
                    ln -f -s "${file}" "/usr/bin/$(basename "${file}")"
      done' bash '{}' \;
    elif [[ -f ${sourceBinFileOrFolder} ]]; then
      ln -f -s "${sourceBinFileOrFolder}" "/usr/bin/$(basename "${sourceBinFileOrFolder}")"
    else
      fatal "\nFATAL : '${sourceBinFileOrFolder}' is not directory or file"
    fi
  else
    fatal '\nFATAL : only support Amazon-Linux, CentOS, Mac, RedHat, or Ubuntu OS'
  fi
}

trimFile() {
  local -r filePath="${1}"

  checkExistFile "${filePath}"

  printf '%s' "$(< "${filePath}")" > "${filePath}"
}

#########################
# FILE REMOTE UTILITIES #
#########################

checkExistURL() {
  local -r url="${1}"

  if [[ "$(existURL "${url}")" == 'false' ]]; then
    fatal "\nFATAL : url '${url}' not found"
  fi
}

downloadFile() {
  local -r url="${1}"
  local -r destinationFile="${2}"
  local overwrite="${3}"

  checkExistURL "${url}"

  # Check Overwrite

  if [[ "$(isEmptyString "${overwrite}")" == 'true' ]]; then
    overwrite='false'
  fi

  checkTrueFalseString "${overwrite}"

  # Validate

  if [[ -f ${destinationFile} ]]; then
    if [[ ${overwrite} == 'false' ]]; then
      fatal "\nFATAL : file '${destinationFile}' found"
    fi

    rm -f "${destinationFile}"
  elif [[ -e ${destinationFile} ]]; then
    fatal "\nFATAL : file '${destinationFile}' already exists"
  fi

  # Download

  debug "\nDownloading '${url}' to '${destinationFile}'\n"
  curl -L "${url}" -o "${destinationFile}" --retry 12 --retry-delay 5
}

existURL() {
  local -r url="${1}"

  # Install Curl

  installCURLCommand > '/dev/null'

  # Check URL

  if (curl -f --head -L "${url}" -o '/dev/null' -s --retry 12 --retry-delay 5 \
    || curl -f -L "${url}" -o '/dev/null' -r 0-0 -s --retry 12 --retry-delay 5); then
    echo 'true' && return 0
  fi

  echo 'false' && return 1
}

getRemoteFileContent() {
  local -r url="${1}"

  checkExistURL "${url}"
  curl -s -X 'GET' -L "${url}" --retry 12 --retry-delay 5
}

unzipRemoteFile() {
  local -r downloadURL="${1}"
  local -r installFolder="${2}"
  local extension="${3}"

  # Install Curl

  installCURLCommand

  # Validate URL

  checkExistURL "${downloadURL}"

  # Find Extension

  local exExtension=''

  if [[ "$(isEmptyString "${extension}")" == 'true' ]]; then
    extension="$(getFileExtension "${downloadURL}")"
    exExtension="$(rev <<< "${downloadURL}" | cut -d '.' -f 1-2 | rev)"
  fi

  # Unzip

  if [[ "$(grep -i '^tgz$' <<< "${extension}")" != '' || "$(grep -i '^tar\.gz$' <<< "${extension}")" != '' || "$(grep -i '^tar\.gz$' <<< "${exExtension}")" != '' ]]; then
    debug "\nDownloading '${downloadURL}'\n"
    curl -L "${downloadURL}" --retry 12 --retry-delay 5 | tar -C "${installFolder}" -x -z --strip 1
    echo
  elif [[ "$(grep -i '^tar\.bz2$' <<< "${exExtension}")" != '' ]]; then
    # Install BZip2

    installBZip2Command

    # Unzip

    debug "\nDownloading '${downloadURL}'\n"
    curl -L "${downloadURL}" --retry 12 --retry-delay 5 | tar -C "${installFolder}" -j -x --strip 1
    echo
  elif [[ "$(grep -i '^zip$' <<< "${extension}")" != '' ]]; then
    # Install Unzip

    installUnzipCommand

    # Unzip

    if [[ "$(existCommand 'unzip')" == 'false' ]]; then
      fatal 'FATAL : command unzip not found'
    fi

    local -r zipFile="${installFolder}/$(basename "${downloadURL}")"

    downloadFile "${downloadURL}" "${zipFile}" 'true'
    unzip -q "${zipFile}" -d "${installFolder}"
    rm -f "${zipFile}"
    echo
  else
    fatal "\nFATAL : file extension '${extension}' not supported"
  fi
}

#################
# GIT UTILITIES #
#################

checkValidGitToken() {
  local -r user="${1}"
  local -r token="${2}"
  local -r gitURL="${3}"

  if [[ "$(isValidGitToken "${user}" "${token}" "${gitURL}")" == 'false' ]]; then
    fatal '\nFATAL : invalid token'
  fi
}

getGitOrganizationMembers() {
  local -r user="${1}"
  local -r token="${2}"
  local -r orgName="${3}"
  local gitURL="${4}"

  # Default Values

  if [[ "$(isEmptyString "${gitURL}")" == 'true' ]]; then
    gitURL='https://api.github.com'
  fi

  # Validation

  checkValidGitToken "${user}" "${token}" "${gitURL}"

  # Pagination

  local members='[]'
  local page=1
  local exitCount=0

  for ((page = 1; page > exitCount; page = page + 1)); do
    local currentMembers=''
    currentMembers="$(
      curl \
        -s \
        -X 'GET' \
        -u "${user}:${token}" \
        -L "${gitURL}/orgs/${orgName}/members?page=${page}&per_page=100" \
        --retry 12 \
        --retry-delay 5 \
        | jq \
          --compact-output \
          --raw-output \
          '. // empty'
    )"

    if [[ ${currentMembers} == '[]' ]]; then
      echo "${members}"
      exitCount="$((page + 1))"
    else
      local members="$(
        jq \
          -S \
          --compact-output \
          --raw-output \
          --argjson jqCurrentUsers "${currentMembers}" \
          --argjson jqUsers "${members}" \
          -n '$jqCurrentUsers + $jqUsers | unique_by(.["id"]) // empty'
      )"
    fi
  done
}

getGitOrganizationTeams() {
  local -r user="${1}"
  local -r token="${2}"
  local -r orgName="${3}"
  local gitURL="${4}"

  # Default Values

  if [[ "$(isEmptyString "${gitURL}")" == 'true' ]]; then
    gitURL='https://api.github.com'
  fi

  # Validation

  checkNonEmptyString "${orgName}" 'undefined organization name'
  checkValidGitToken "${user}" "${token}" "${gitURL}"

  # Pagination

  local teams='[]'
  local page=1
  local exitCount=0

  for ((page = 1; page > exitCount; page = page + 1)); do
    local currentTeams=''
    currentTeams="$(
      curl \
        -s \
        -X 'GET' \
        -u "${user}:${token}" \
        -L "${gitURL}/orgs/${orgName}/teams?page=${page}&per_page=100" \
        --retry 12 \
        --retry-delay 5 \
        | jq \
          --compact-output \
          --raw-output \
          '. // empty'
    )"

    if [[ ${currentTeams} == '[]' ]]; then
      echo "${teams}"
      exitCount="$((page + 1))"
    else
      local teams="$(
        jq \
          -S \
          --compact-output \
          --raw-output \
          --argjson jqCurrentTeams "${currentTeams}" \
          --argjson jqTeams "${teams}" \
          -n '$jqCurrentTeams + $jqTeams | unique_by(.["id"]) // empty'
      )"
    fi
  done
}

getGitPrivateRepositorySSHURL() {
  local -r user="${1}"
  local -r token="${2}"
  local -r orgName="${3}"
  local -r gitURL="${4}"

  getGitUserRepositoryObjectKey "${user}" "${token}" 'ssh_url' 'private' "${orgName}" "${gitURL}"
}

getGitPublicRepositorySSHURL() {
  local -r user="${1}"
  local -r token="${2}"
  local -r orgName="${3}"
  local -r gitURL="${4}"

  getGitUserRepositoryObjectKey "${user}" "${token}" 'ssh_url' 'public' "${orgName}" "${gitURL}"
}

getGitRepositoryCollaborators() {
  local -r user="${1}"
  local -r token="${2}"
  local -r orgName="${3}"
  local -r repository="${4}"
  local gitURL="${5}"

  # Default Values

  if [[ "$(isEmptyString "${gitURL}")" == 'true' ]]; then
    gitURL='https://api.github.com'
  fi

  # Validation

  checkValidGitToken "${user}" "${token}" "${gitURL}"
  checkNonEmptyString "${repository}" 'undefined repository'

  # Pagination

  local users='[]'
  local page=1
  local exitCount=0

  for ((page = 1; page > exitCount; page = page + 1)); do
    local currentUsers=''
    currentUsers="$(
      curl \
        -s \
        -X 'GET' \
        -u "${user}:${token}" \
        -L "${gitURL}/repos/${orgName}/${repository}/collaborators?affiliation=direct&page=${page}&per_page=100" \
        --retry 12 \
        --retry-delay 5 \
        | jq \
          --compact-output \
          --raw-output \
          '. // empty'
    )"

    if [[ ${currentUsers} == '[]' ]]; then
      echo "${users}"
      exitCount="$((page + 1))"
    else
      local users="$(
        jq \
          -S \
          --compact-output \
          --raw-output \
          --argjson jqCurrentUsers "${currentUsers}" \
          --argjson jqUsers "${users}" \
          -n '$jqCurrentUsers + $jqUsers | unique_by(.["id"]) // empty'
      )"
    fi
  done
}

getGitRepositoryNameFromCloneURL() {
  local -r cloneURL="${1}"

  checkNonEmptyString "${cloneURL}" 'undefined clone url'

  if [[ "$(grep -F -o '@' <<< "${cloneURL}")" != '' ]]; then
    awk -F '/' '{ print $2 }' <<< "${cloneURL}" | rev | cut -d '.' -f 2- | rev
  else
    awk -F '/' '{ print $5 }' <<< "${cloneURL}" | rev | cut -d '.' -f 2- | rev
  fi
}

getGitTeamUsers() {
  local -r user="${1}"
  local -r token="${2}"
  local gitURL="${3}"
  local -r membersURL="${4}"

  # Default Values

  if [[ "$(isEmptyString "${gitURL}")" == 'true' ]]; then
    gitURL='https://api.github.com'
  fi

  # Validation

  checkValidGitToken "${user}" "${token}" "${gitURL}"

  # Pagination

  local users='[]'
  local page=1
  local exitCount=0

  for ((page = 1; page > exitCount; page = page + 1)); do
    local currentUsers=''
    currentUsers="$(
      curl \
        -s \
        -X 'GET' \
        -u "${user}:${token}" \
        -L "${membersURL}?page=${page}&per_page=100" \
        --retry 12 \
        --retry-delay 5 \
        | jq \
          --compact-output \
          --raw-output \
          '. // empty'
    )"

    if [[ ${currentUsers} == '[]' ]]; then
      echo "${users}"
      exitCount="$((page + 1))"
    else
      local users="$(
        jq \
          -S \
          --compact-output \
          --raw-output \
          --argjson jqCurrentUsers "${currentUsers}" \
          --argjson jqUsers "${users}" \
          -n '$jqCurrentUsers + $jqUsers | unique_by(.["id"]) // empty'
      )"
    fi
  done
}

getGitUserName() {
  local -r user="${1}"
  local -r token="${2}"
  local gitURL="${3}"

  # Default Value

  if [[ "$(isEmptyString "${gitURL}")" == 'true' ]]; then
    gitURL='https://api.github.com'
  fi

  # Validation

  checkValidGitToken "${user}" "${token}" "${gitURL}"

  # Get User Name

  curl \
    -s \
    -X 'GET' \
    -u "${user}:${token}" \
    -L "${gitURL}/user" \
    --retry 12 \
    --retry-delay 5 \
    | jq \
      --compact-output \
      --raw-output \
      --sort-keys \
      '.["name"] // empty'
}

getGitUserPrimaryEmail() {
  local -r user="${1}"
  local -r token="${2}"
  local gitURL="${3}"

  # Default Values

  if [[ "$(isEmptyString "${gitURL}")" == 'true' ]]; then
    gitURL='https://api.github.com'
  fi

  # Validation

  checkValidGitToken "${user}" "${token}" "${gitURL}"

  # Pagination

  local page=1
  local exitCount=0

  for ((page = 1; page > exitCount; page = page + 1)); do
    local emails=''
    emails="$(
      curl \
        -s \
        -X 'GET' \
        -u "${user}:${token}" \
        -L "${gitURL}/user/emails?page=${page}&per_page=100" \
        --retry 12 \
        --retry-delay 5 \
        | jq \
          --compact-output \
          --raw-output \
          --sort-keys \
          '.[] // empty'
    )"

    local primaryEmail=''
    primaryEmail="$(
      jq \
        --compact-output \
        --raw-output \
        --sort-keys \
        'select(.["primary"] == true) |
      .["email"] // empty' \
        <<< "${emails}"
    )"

    if [[ "$(isEmptyString "${primaryEmail}")" == 'false' || "$(isEmptyString "${emails}")" == 'true' ]]; then
      echo "${primaryEmail}"
      exitCount="$((page + 1))"
    fi
  done
}

getGitUserRepositoryObjectKey() {
  local -r user="${1}"
  local -r token="${2}"
  local -r objectKey="${3}"
  local -r kind="${4}"
  local -r orgName="${5}"
  local gitURL="${6}"

  # Default Value

  if [[ "$(isEmptyString "${gitURL}")" == 'true' ]]; then
    gitURL='https://api.github.com'
  fi

  # Validation

  checkNonEmptyString "${objectKey}" 'undefined object key'
  checkValidGitToken "${user}" "${token}" "${gitURL}"

  # Pagination

  local results=''
  local page=1
  local exitCount=0

  for ((page = 1; page > exitCount; page = page + 1)); do
    # User or Organization

    if [[ "$(isEmptyString "${orgName}")" == 'true' ]]; then
      local targetURL="${gitURL}/user/repos?affiliation=owner&page=${page}&per_page=100&visibility=${kind}"
    else
      local targetURL="${gitURL}/orgs/${orgName}/repos?page=${page}&per_page=100&type=${kind}"
    fi

    # Retrieve Objects

    local currentObjectValue=''
    currentObjectValue="$(
      curl \
        -s \
        -X 'GET' \
        -u "${user}:${token}" \
        -L "${targetURL}" \
        --retry 12 \
        --retry-delay 5 \
        | jq \
          --arg jqObjectKey "${objectKey}" \
          --compact-output \
          --raw-output \
          --sort-keys \
          '.[] |
      .[$jqObjectKey] // empty'
    )"

    if [[ "$(isEmptyString "${currentObjectValue}")" == 'true' ]]; then
      exitCount="$((page + 1))"
    elif [[ ${page} == '1' ]]; then
      results="$(printf '%s' "${currentObjectValue}")"
    else
      results="$(printf '%s\n%s' "${results}" "${currentObjectValue}")"
    fi
  done

  # Return Results

  echo "${results}" | sort -f
}

isGitUserSuspended() {
  local -r user="${1}"
  local -r token="${2}"
  local gitURL="${3}"
  local -r login="${4}"

  # Default Values

  if [[ "$(isEmptyString "${gitURL}")" == 'true' ]]; then
    gitURL='https://api.github.com'
  fi

  # Check Status

  local -r suspendedAt="$(
    curl \
      -s \
      -X 'GET' \
      -u "${user}:${token}" \
      -L "${gitURL}/users/${login}" \
      --retry 12 \
      --retry-delay 5 \
      | jq \
        --compact-output \
        --raw-output \
        '.["suspended_at"] // empty'
  )"

  if [[ "$(isEmptyString "${suspendedAt}")" == 'false' ]]; then
    echo 'true' && return 0
  fi

  echo 'false' && return 1
}

isValidGitToken() {
  local -r user="${1}"
  local -r token="${2}"
  local gitURL="${3}"

  # Default Values

  if [[ "$(isEmptyString "${gitURL}")" == 'true' ]]; then
    gitURL='https://api.github.com'
  fi

  # Validation

  local -r result="$(
    curl \
      -s \
      -X 'GET' \
      -u "${user}:${token}" \
      -L "${gitURL}" \
      --retry 12 \
      --retry-delay 5 \
      | jq \
        --compact-output \
        --raw-output \
        --sort-keys \
        '.["message"] // empty'
  )"

  if [[ ${result} == 'Bad credentials' ]]; then
    echo 'false' && return 1
  fi

  echo 'true' && return 0
}

removeGitCollaboratorFromRepository() {
  local -r user="${1}"
  local -r token="${2}"
  local -r gitURL="${3}"
  local -r orgName="${4}"
  local -r repository="${5}"
  local -r collaborator="${6}"

  curl \
    -s \
    -X 'DELETE' \
    -u "${user}:${token}" \
    -L "${gitURL}/repos/${orgName}/${repository}/collaborators/${collaborator}" \
    --retry 12 \
    --retry-delay 5
}

removeGitMemberFromOrganization() {
  local -r user="${1}"
  local -r token="${2}"
  local gitURL="${3}"
  local -r orgName="${4}"
  local -r member="${5}"

  # Default Values

  if [[ "$(isEmptyString "${gitURL}")" == 'true' ]]; then
    gitURL='https://api.github.com'
  fi

  # Remove Member

  curl \
    -s \
    -X 'DELETE' \
    -u "${user}:${token}" \
    -L "${gitURL}/orgs/${orgName}/members/${member}" \
    --retry 12 \
    --retry-delay 5
}

removeGitUserFromTeam() {
  local -r user="${1}"
  local -r token="${2}"
  local -r teamURL="${3}"
  local -r teamUser="${4}"

  curl \
    -s \
    -X 'DELETE' \
    -u "${user}:${token}" \
    -L "${teamURL}/memberships/${teamUser}" \
    --retry 12 \
    --retry-delay 5
}

#####################
# INSTALL UTILITIES #
#####################

installPortableBinary() {
  local -r appTitleName="${1}"
  local -r downloadURL="${2}"
  local -r installFolderPath="${3}"
  local -r binarySubPaths=($(sortUniqArray "$(replaceString "${4}" ',' ' ')"))
  local -r versionOption="${5}"
  local -r remoteUnzip="${6}"

  checkNonEmptyString "${appTitleName}" 'undefined app title name'
  checkNonEmptyString "${versionOption}" 'undefined version option'
  checkTrueFalseString "${remoteUnzip}"

  if [[ ${#binarySubPaths[@]} -lt '1' ]]; then
    fatal '\nFATAL : undefined binary sub paths'
  fi

  header "INSTALLING ${appTitleName}"

  checkRequireLinuxSystem
  checkRequireRootUser

  umask '0022'

  initializeFolder "${installFolderPath}"

  if [[ ${remoteUnzip} == 'true' ]]; then
    if [[ "$(getFileExtension "${downloadURL}")" == 'sh' ]]; then
      curl -s -L "${downloadURL}" --retry 12 --retry-delay 5 | bash -e
    else
      unzipRemoteFile "${downloadURL}" "${installFolderPath}"
    fi

    printf '%s\n\nexport PATH="%s/%s:${PATH}"' \
      '#!/bin/sh -e' \
      "${installFolderPath}" \
      "$(dirname "${binarySubPaths[0]}")" \
      > "/etc/profile.d/$(basename "${installFolderPath}").sh"

    chmod 644 "/etc/profile.d/$(basename "${installFolderPath}").sh"
  else
    downloadFile "${downloadURL}" "${installFolderPath}/${binarySubPaths[0]}" 'true'
  fi

  chown -R "$(whoami):$(whoami)" "${installFolderPath}"

  local binarySubPath=''

  for binarySubPath in "${binarySubPaths[@]}"; do
    symlinkListUsrBin "${installFolderPath}/${binarySubPath}"
  done

  displayVersion "$("/usr/bin/$(basename "${binarySubPaths[0]}")" "${versionOption}")"

  umask '0077'

  installCleanUp
}

#################
# MAC UTILITIES #
#################

closeMacApplications() {
  local -r headerMessage="${1}"
  local -r applicationNames=("${@:2}")

  checkRequireMacSystem

  if [[ ${#applicationNames[@]} -gt '0' ]]; then
    header "${headerMessage}"
  fi

  local applicationName=''

  for applicationName in "${applicationNames[@]}"; do
    applicationName="$(getFileName "${applicationName}")"

    if [[ ${applicationName} != 'Terminal' ]]; then
      local errorMessage=''
      errorMessage="$(osascript -e "tell application \"${applicationName}\" to quit" 2>&1 || true)"

      if [[ "$(isEmptyString "${errorMessage}")" == 'true' || "$(grep -E -o '\(-128)$' <<< "${errorMessage}")" != '' ]]; then
        info "closing '${applicationName}'"
      else
        error "${errorMessage}"
      fi
    fi
  done
}

getMacCurrentUserICloudDriveFolderPath() {
  local -r iCloudFolderPath="$(getCurrentUserHomeFolder)/Library/Mobile Documents/com~apple~CloudDocs"

  if [[ -d ${iCloudFolderPath} ]]; then
    echo "${iCloudFolderPath}"
  else
    echo
  fi
}

openMacApplications() {
  local -r headerMessage="${1}"
  local -r applicationNames=("${@:2}")

  checkRequireMacSystem

  if [[ ${#applicationNames[@]} -gt '0' ]]; then
    header "${headerMessage}"
  fi

  local applicationName=''

  for applicationName in "${applicationNames[@]}"; do
    info "openning '${applicationName}'"
    osascript -e "tell application \"${applicationName}\" to activate"
  done
}

####################
# NUMBER UTILITIES #
####################

checkNaturalNumber() {
  local -r string="${1}"
  local -r errorMessage="${2}"

  if [[ "$(isNaturalNumber "${string}")" == 'false' ]]; then
    if [[ "$(isEmptyString "${errorMessage}")" == 'true' ]]; then
      fatal '\nFATAL : not natural number detected'
    fi

    fatal "\nFATAL : ${errorMessage}"
  fi
}

checkPositiveInteger() {
  local -r string="${1}"
  local -r errorMessage="${2}"

  if [[ "$(isPositiveInteger "${string}")" == 'false' ]]; then
    if [[ "$(isEmptyString "${errorMessage}")" == 'true' ]]; then
      fatal '\nFATAL : not positive number detected'
    fi

    fatal "\nFATAL : ${errorMessage}"
  fi
}

isNaturalNumber() {
  local -r string="${1}"

  if [[ ${string} =~ ^[0-9]+$ ]]; then
    echo 'true' && return 0
  fi

  echo 'false' && return 1
}

isPositiveInteger() {
  local -r string="${1}"

  if [[ ${string} =~ ^[1-9][0-9]*$ ]]; then
    echo 'true' && return 0
  fi

  echo 'false' && return 1
}

################
# OS UTILITIES #
################

checkRequireLinuxSystem() {
  if [[ "$(isAmazonLinuxDistributor)" == 'false' && "$(isCentOSDistributor)" == 'false' && "$(isRedHatDistributor)" == 'false' && "$(isUbuntuDistributor)" == 'false' ]]; then
    fatal '\nFATAL : only support Amazon-Linux, CentOS, RedHat, or Ubuntu OS'
  fi

  if [[ "$(is64BitSystem)" == 'false' ]]; then
    fatal '\nFATAL : non x86_64 OS found'
  fi
}

checkRequireMacSystem() {
  if [[ "$(isMacOperatingSystem)" == 'false' ]]; then
    fatal '\nFATAL : only support Mac OS'
  fi

  if [[ "$(is64BitSystem)" == 'false' ]]; then
    fatal '\nFATAL : non x86_64 OS found'
  fi
}

getMachineDescription() {
  lsb_release -d -s
}

getMachineRelease() {
  lsb_release -r -s
}

is64BitSystem() {
  isMachineHardware 'x86_64'
}

isAmazonLinuxDistributor() {
  isDistributor 'amzn'
}

isCentOSDistributor() {
  isDistributor 'centos'
}

isDistributor() {
  local -r distributor="${1}"

  local -r found="$(grep -F -i -o -s "${distributor}" '/proc/version')"

  if [[ "$(isEmptyString "${found}")" == 'true' ]]; then
    echo 'false' && return 1
  fi

  echo 'true' && return 0
}

isLinuxOperatingSystem() {
  isOperatingSystem 'Linux'
}

isMachineHardware() {
  local -r machineHardware="$(escapeGrepSearchPattern "${1}")"

  local -r found="$(uname -m | grep -E -i -o "^${machineHardware}$")"

  if [[ "$(isEmptyString "${found}")" == 'true' ]]; then
    echo 'false' && return 1
  fi

  echo 'true' && return 0
}

isMacOperatingSystem() {
  isOperatingSystem 'Darwin'
}

isOperatingSystem() {
  local -r operatingSystem="$(escapeGrepSearchPattern "${1}")"

  local -r found="$(uname -s | grep -E -i -o "^${operatingSystem}$")"

  if [[ "$(isEmptyString "${found}")" == 'true' ]]; then
    echo 'false' && return 1
  fi

  echo 'true' && return 0
}

isRedHatDistributor() {
  isDistributor 'redhat'
}

isUbuntuDistributor() {
  isDistributor 'ubuntu'
}

#####################
# PACKAGE UTILITIES #
#####################

getLastAptGetUpdate() {
  if [[ "$(isUbuntuDistributor)" == 'true' ]]; then
    local -r aptDate="$(stat -c %Y '/var/cache/apt')"
    local -r nowDate="$(date +'%s')"

    echo $((nowDate - aptDate))
  fi
}

installBuildEssential() {
  if [[ "$(isUbuntuDistributor)" == 'true' ]]; then
    installPackages 'build-essential'
  elif [[ "$(isAmazonLinuxDistributor)" == 'true' || "$(isCentOSDistributor)" == 'true' || "$(isRedHatDistributor)" == 'true' ]]; then
    installPackages 'gcc-c++' 'kernel-devel' 'make'
  else
    fatal '\nFATAL : only support Amazon-Linux, CentOS, RedHat, or Ubuntu OS'
  fi
}

installBZip2Command() {
  local -r commandPackage=('bzip2' 'bzip2')

  installCommands "${commandPackage[@]}"
}

installCleanUp() {
  header 'CLEANING UP INSTALLATION'

  if [[ "$(isUbuntuDistributor)" == 'true' ]]; then
    DEBIAN_FRONTEND='noninteractive' apt-get --fix-missing -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' autoremove
    DEBIAN_FRONTEND='noninteractive' apt-get --fix-missing -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' clean
    DEBIAN_FRONTEND='noninteractive' apt-get --fix-missing -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' autoclean
  elif [[ "$(isAmazonLinuxDistributor)" == 'true' || "$(isCentOSDistributor)" == 'true' || "$(isRedHatDistributor)" == 'true' ]]; then
    yum clean all
  else
    fatal '\nFATAL : only support Amazon-Linux, CentOS, RedHat, or Ubuntu OS'
  fi
}

installCommands() {
  local -r commandPackageData=("${@}")

  if [[ "$(isUbuntuDistributor)" == 'true' ]]; then
    runAptGetUpdate ''
  fi

  local i=0

  for ((i = 0; i < ${#commandPackageData[@]}; i = i + 2)); do
    local command="${commandPackageData[${i}]}"
    local package="${commandPackageData[i + 1]}"

    checkNonEmptyString "${command}" 'undefined command'
    checkNonEmptyString "${package}" 'undefined package'

    if [[ "$(existCommand "${command}")" == 'false' ]]; then
      installPackages "${package}"
    fi
  done
}

installCURLCommand() {
  local -r commandPackage=('curl' 'curl')

  installCommands "${commandPackage[@]}"
}

installPackage() {
  local -r aptPackage="${1}"
  local -r rpmPackage="${2}"

  if [[ "$(isUbuntuDistributor)" == 'true' ]]; then
    if [[ "$(isEmptyString "${aptPackage}")" == 'false' ]]; then
      if [[ "$(isAptGetPackageInstall "${aptPackage}")" == 'true' ]]; then
        debug "\nApt-Get Package '${aptPackage}' has already been installed"
      else
        echo -e "\033[1;35m\nInstalling Apt-Get Package '${aptPackage}'\033[0m"
        DEBIAN_FRONTEND='noninteractive' apt-get install "${aptPackage}" --fix-missing -y \
          || (DEBIAN_FRONTEND='noninteractive' apt-get install --fix-missing --yes -f -y && DEBIAN_FRONTEND='noninteractive' apt-get install "${aptPackage}" --fix-missing -y)
      fi
    fi
  elif [[ "$(isAmazonLinuxDistributor)" == 'true' || "$(isCentOSDistributor)" == 'true' || "$(isRedHatDistributor)" == 'true' ]]; then
    if [[ "$(isEmptyString "${rpmPackage}")" == 'false' ]]; then
      yum install -y "${rpmPackage}"
    fi
  else
    fatal '\nFATAL : only support Amazon-Linux, CentOS, RedHat, or Ubuntu OS'
  fi
}

installPackages() {
  local -r packages=("${@}")

  if [[ "$(isUbuntuDistributor)" == 'true' ]]; then
    runAptGetUpdate ''
  fi

  local package=''

  for package in "${packages[@]}"; do
    if [[ "$(isUbuntuDistributor)" == 'true' ]]; then
      installPackage "${package}"
    elif [[ "$(isAmazonLinuxDistributor)" == 'true' || "$(isCentOSDistributor)" == 'true' || "$(isRedHatDistributor)" == 'true' ]]; then
      installPackage '' "${package}"
    else
      fatal '\nFATAL : only support Amazon-Linux, CentOS, RedHat, or Ubuntu OS'
    fi
  done
}

installPIPCommand() {
  local -r commandPackage=('pip' 'python-pip')

  installCommands "${commandPackage[@]}"
}

installPIPPackage() {
  local -r package="${1}"

  if [[ "$(isPIPPackageInstall "${package}")" == 'true' ]]; then
    debug "PIP Package '${package}' found"
  else
    echo -e "\033[1;35m\nInstalling PIP package '${package}'\033[0m"
    pip install "${package}"
  fi
}

installUnzipCommand() {
  local -r commandPackage=('unzip' 'unzip')

  installCommands "${commandPackage[@]}"
}

isAptGetPackageInstall() {
  local -r package="$(escapeGrepSearchPattern "${1}")"

  local -r found="$(dpkg --get-selections | grep -E -o "^${package}(:amd64)*\s+install$")"

  if [[ "$(isEmptyString "${found}")" == 'true' ]]; then
    echo 'false' && return 1
  fi

  echo 'true' && return 0
}

isPIPPackageInstall() {
  local -r package="$(escapeGrepSearchPattern "${1}")"

  # Install PIP

  installPIPCommand > '/dev/null'

  # Check Command

  if [[ "$(existCommand 'pip')" == 'false' ]]; then
    fatal 'FATAL : command python-pip not found'
  fi

  local -r found="$(pip list | grep -E -o "^${package}\s+\(.*\)$")"

  if [[ "$(isEmptyString "${found}")" == 'true' ]]; then
    echo 'false' && return 1
  fi

  echo 'true' && return 0
}

runAptGetUpdate() {
  local updateInterval="${1}"

  if [[ "$(isUbuntuDistributor)" == 'true' ]]; then
    local -r lastAptGetUpdate="$(getLastAptGetUpdate)"

    if [[ "$(isEmptyString "${updateInterval}")" == 'true' ]]; then
      # Default To 24 hours
      updateInterval="$((24 * 60 * 60))"
    fi

    if [[ ${lastAptGetUpdate} -gt ${updateInterval} ]]; then
      info 'apt-get update'
      apt-get update -m
    else
      local -r lastUpdate="$(date -u -d @"${lastAptGetUpdate}" +'%-Hh %-Mm %-Ss')"

      info "\nSkip apt-get update because its last run was '${lastUpdate}' ago"
    fi
  fi
}

runUpgrade() {
  header 'UPGRADING SYSTEM'

  if [[ "$(isUbuntuDistributor)" == 'true' ]]; then
    runAptGetUpdate ''

    info '\napt-get upgrade'
    DEBIAN_FRONTEND='noninteractive' apt-get --fix-missing -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' upgrade

    info '\napt-get dist-upgrade'
    DEBIAN_FRONTEND='noninteractive' apt-get --fix-missing -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' dist-upgrade

    info '\napt-get autoremove'
    DEBIAN_FRONTEND='noninteractive' apt-get --fix-missing -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' autoremove

    info '\napt-get clean'
    DEBIAN_FRONTEND='noninteractive' apt-get --fix-missing -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' clean

    info '\napt-get autoclean'
    DEBIAN_FRONTEND='noninteractive' apt-get --fix-missing -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' autoclean
  elif [[ "$(isAmazonLinuxDistributor)" == 'true' || "$(isCentOSDistributor)" == 'true' || "$(isRedHatDistributor)" == 'true' ]]; then
    yum -y --security update
    yum -y update --nogpgcheck --skip-broken
  fi
}

upgradePIPPackage() {
  local -r package="${1}"

  if [[ "$(isPIPPackageInstall "${package}")" == 'true' ]]; then
    echo -e "\033[1;35mUpgrading PIP package '${package}'\033[0m"
    pip install --upgrade "${package}"
  else
    debug "PIP Package '${package}' not found"
  fi
}

#####################
# SERVICE UTILITIES #
#####################

disableService() {
  local -r serviceName="${1}"

  checkNonEmptyString "${serviceName}" 'undefined service name'

  if [[ "$(existCommand 'systemctl')" == 'true' ]]; then
    header "DISABLE SYSTEMD ${serviceName}"

    systemctl daemon-reload
    systemctl disable "${serviceName}"
    systemctl stop "${serviceName}" || true
  else
    header "DISABLE SERVICE ${serviceName}"

    chkconfig "${serviceName}" off
    service "${serviceName}" stop || true
  fi

  statusService "${serviceName}"
}

enableService() {
  local -r serviceName="${1}"

  checkNonEmptyString "${serviceName}" 'undefined service name'

  if [[ "$(existCommand 'systemctl')" == 'true' ]]; then
    header "ENABLE SYSTEMD ${serviceName}"

    systemctl daemon-reload
    systemctl enable "${serviceName}" || true
  else
    header "ENABLE SERVICE ${serviceName}"

    chkconfig "${serviceName}" on
  fi

  statusService "${serviceName}"
}

restartService() {
  local -r serviceName="${1}"

  checkNonEmptyString "${serviceName}" 'undefined service name'

  stopService "${serviceName}"
  startService "${serviceName}"
}

startService() {
  local -r serviceName="${1}"

  checkNonEmptyString "${serviceName}" 'undefined service name'

  if [[ "$(existCommand 'systemctl')" == 'true' ]]; then
    header "STARTING SYSTEMD ${serviceName}"

    systemctl daemon-reload
    systemctl enable "${serviceName}" || true
    systemctl start "${serviceName}"
  else
    header "STARTING SERVICE ${serviceName}"

    chkconfig "${serviceName}" on
    service "${serviceName}" start
  fi

  statusService "${serviceName}"
}

statusService() {
  local -r serviceName="${1}"

  checkNonEmptyString "${serviceName}" 'undefined service name'

  if [[ "$(existCommand 'systemctl')" == 'true' ]]; then
    header "STATUS SYSTEMD ${serviceName}"

    systemctl status "${serviceName}" --full --no-pager || true
  else
    header "STATUS SERVICE ${serviceName}"

    service "${serviceName}" status || true
  fi
}

stopService() {
  local -r serviceName="${1}"

  checkNonEmptyString "${serviceName}" 'undefined service name'

  if [[ "$(existCommand 'systemctl')" == 'true' ]]; then
    header "STOPPING SYSTEMD ${serviceName}"

    systemctl daemon-reload
    systemctl stop "${serviceName}" || true
  else
    header "STOPPING SERVICE ${serviceName}"

    service "${serviceName}" stop || true
  fi

  statusService "${serviceName}"
}

####################
# STRING UTILITIES #
####################

checkNonEmptyString() {
  local -r string="${1}"
  local -r errorMessage="${2}"

  if [[ "$(isEmptyString "${string}")" == 'true' ]]; then
    if [[ "$(isEmptyString "${errorMessage}")" == 'true' ]]; then
      fatal '\nFATAL : empty value detected'
    fi

    fatal "\nFATAL : ${errorMessage}"
  fi
}

checkTrueFalseString() {
  local -r string="${1}"
  local -r errorMessage="${2}"

  if [[ ${string} != 'true' && ${string} != 'false' ]]; then
    if [[ "$(isEmptyString "${errorMessage}")" == 'true' ]]; then
      fatal "\nFATAL : '${string}' is not 'true' or 'false'"
    fi

    fatal "\nFATAL : ${errorMessage}"
  fi
}

debug() {
  local -r message="${1}"

  if [[ "$(isEmptyString "${message}")" == 'false' ]]; then
    echo -e "\033[1;34m${message}\033[0m" 2>&1
  fi
}

deleteSpaces() {
  local -r content="${1}"

  replaceString "${content}" ' ' ''
}

displayVersion() {
  local -r message="${1}"
  local -r applicationName="${2}"

  if [[ "$(isEmptyString "${applicationName}")" == 'true' ]]; then
    header 'DISPLAYING VERSION'
  else
    header "DISPLAYING ${applicationName} VERSION"
  fi

  info "${message}"
}

encodeURL() {
  local -r url="${1}"

  local i=0

  for ((i = 0; i < ${#url}; i++)); do
    local walker=''
    walker="${url:i:1}"

    case "${walker}" in
      [a-zA-Z0-9.~_-])
        printf '%s' "${walker}"
        ;;
      ' ')
        printf +
        ;;
      *)
        printf '%%%X' "'${walker}"
        ;;
    esac
  done
}

error() {
  local -r message="${1}"

  if [[ "$(isEmptyString "${message}")" == 'false' ]]; then
    echo -e "\033[1;31m${message}\033[0m" 1>&2
  fi
}

escapeGrepSearchPattern() {
  local -r searchPattern="${1}"

  sed 's/[]\.|$(){}?+*^]/\\&/g' <<< "${searchPattern}"
}

escapeSearchPattern() {
  local -r searchPattern="${1}"

  sed -e "s@\@@\\\\\\@@g" -e "s@\[@\\\\[@g" -e "s@\*@\\\\*@g" -e "s@\%@\\\\%@g" <<< "${searchPattern}"
}

fatal() {
  local -r message="${1}"

  error "${message}"
  exit 1
}

formatPath() {
  local path="${1}"

  while [[ "$(grep -F '//' <<< "${path}")" != '' ]]; do
    path="$(sed -e 's/\/\/*/\//g' <<< "${path}")"
  done

  sed -e 's/\/$//g' <<< "${path}"
}

header() {
  local -r title="${1}"

  if [[ "$(isEmptyString "${title}")" == 'false' ]]; then
    echo -e "\n\033[1;33m>>>>>>>>>> \033[1;4;35m${title}\033[0m \033[1;33m<<<<<<<<<<\033[0m\n"
  fi
}

indentString() {
  local -r indentString="$(escapeSearchPattern "${1}")"
  local -r string="$(escapeSearchPattern "${2}")"

  sed "s@^@${indentString}@g" <<< "${string}"
}

info() {
  local -r message="${1}"

  if [[ "$(isEmptyString "${message}")" == 'false' ]]; then
    echo -e "\033[1;36m${message}\033[0m" 2>&1
  fi
}

invertTrueFalseString() {
  local -r string="${1}"

  checkTrueFalseString "${string}"

  if [[ ${string} == 'true' ]]; then
    echo 'false' && return 1
  fi

  echo 'true' && return 0
}

isEmptyString() {
  local -r string="${1}"

  if [[ "$(trimString "${string}")" == '' ]]; then
    echo 'true' && return 0
  fi

  echo 'false' && return 1
}

postUpMessage() {
  echo -e "\n\033[1;32m¯\_(ツ)_/¯\033[0m"
}

printTable() {
  emulate bash
  local -r delimiter="${1}"
  local -r tableData="$(removeEmptyLines "${2}")"
  local -r colorHeader="${3}"
  local -r displayTotalCount="${4}"

  if [[ ${delimiter} != '' && "$(isEmptyString "${tableData}")" == 'false' ]]; then
    local -r numberOfLines="$(trimString "$(wc -l <<< "${tableData}")")"

    if [[ ${numberOfLines} -gt '0' ]]; then
      local table=''
      local i=1

      for ((i = 1; i <= "${numberOfLines}"; i = i + 1)); do
        local line=''
        line="$(sed "${i}q;d" <<< "${tableData}")"

        local numberOfColumns=0
        numberOfColumns="$(awk -F "${delimiter}" '{print NF}' <<< "${line}")"

        # Add Line Delimiter

        if [[ ${i} -eq '1' ]]; then
          table="${table}$(printf '%s#+' "$(repeatString '#+' "${numberOfColumns}")")"
        fi

        # Add Header Or Body

        table="${table}\n"

        local j=1

        for ((j = 1; j <= "${numberOfColumns}"; j = j + 1)); do
          table="${table}$(printf '#|  %s' "$(cut -d "${delimiter}" -f "${j}" <<< "${line}")")"
        done

        table="${table}#|\n"

        # Add Line Delimiter

        if [[ ${i} -eq '1' ]] || [[ ${numberOfLines} -gt '1' && ${i} -eq ${numberOfLines} ]]; then
          table="${table}$(printf '%s#+' "$(repeatString '#+' "${numberOfColumns}")")"
        fi
      done

      if [[ "$(isEmptyString "${table}")" == 'false' ]]; then
        local output=''
        output="$(echo -e "${table}" | column -s '#' -t | awk '/^\+/{gsub(" ", "-", $0)}1')"

        if [[ ${colorHeader} == 'true' ]]; then
          echo -e "\033[1;32m$(head -n 3 <<< "${output}")\033[0m"
          tail -n +4 <<< "${output}"
        else
          echo "${output}"
        fi
      fi
    fi

    if [[ ${displayTotalCount} == 'true' && ${numberOfLines} -ge '0' ]]; then
      echo -e "\n\033[1;36mTOTAL ROWS : $((numberOfLines - 1))\033[0m"
    fi
  fi
}

removeEmptyLines() {
  local -r content="${1}"

  echo -e "${content}" | sed '/^\s*$/d'
}

repeatString() {
  local -r string="${1}"
  local -r numberToRepeat="${2}"

  if [[ ${string} != '' && "$(isPositiveInteger "${numberToRepeat}")" == 'true' ]]; then
    local -r result="$(printf "%${numberToRepeat}s")"
    echo -e "${result// /${string}}"
  fi
}

replaceString() {
  local -r content="${1}"
  local -r oldValue="$(escapeSearchPattern "${2}")"
  local -r newValue="$(escapeSearchPattern "${3}")"

  sed "s@${oldValue}@${newValue}@g" <<< "${content}"
}

stringToNumber() {
  local -r string="${1}"

  checkNonEmptyString "${string}" 'undefined string'

  if [[ "$(existCommand 'md5')" == 'true' ]]; then
    md5 <<< "${string}" | tr -cd '0-9'
  elif [[ "$(existCommand 'md5sum')" == 'true' ]]; then
    md5sum <<< "${string}" | tr -cd '0-9'
  else
    fatal '\nFATAL : md5 or md5sum command not found'
  fi
}

stringToSearchPattern() {
  local -r string="$(trimString "${1}")"

  if [[ "$(isEmptyString "${string}")" == 'true' ]]; then
    echo "${string}"
  else
    echo "^\s*$(sed -e 's/\s\+/\\s+/g' <<< "$(escapeSearchPattern "${string}")")\s*$"
  fi
}

trimString() {
  local -r string="${1}"

  sed 's,^[[:blank:]]*,,' <<< "${string}" | sed 's,[[:blank:]]*$,,'
}

warn() {
  local -r message="${1}"

  if [[ "$(isEmptyString "${message}")" == 'false' ]]; then
    echo -e "\033[1;33m${message}\033[0m" 1>&2
  fi
}

####################
# SYSTEM UTILITIES #
####################

addSwapSpace() {
  local swapSize="${1}"
  local swapFile="${2}"

  header 'ADDING SWAP SPACE'

  # Set Default Values

  if [[ "$(isEmptyString "${swapSize}")" == 'true' ]]; then
    swapSize='1024000'
  fi

  if [[ "$(isEmptyString "${swapFile}")" == 'true' ]]; then
    swapFile='/mnt/swapfile'
  fi

  if [[ -f ${swapFile} ]]; then
    swapoff "${swapFile}"
  fi

  rm -f "${swapFile}"
  touch "${swapFile}"

  # Create Swap File

  dd if=/dev/zero of="${swapFile}" bs=1024 count="${swapSize}"
  mkswap "${swapFile}"
  chmod 600 "${swapFile}"
  swapon "${swapFile}"

  # Config Swap File System

  local -r fstabConfig="${swapFile} swap swap defaults 0 0"

  appendToFileIfNotFound '/etc/fstab' "$(stringToSearchPattern "${fstabConfig}")" "${fstabConfig}" 'true' 'false' 'true'

  # Display Swap Status

  free -m
}

checkExistCommand() {
  local -r command="${1}"
  local -r errorMessage="${2}"

  if [[ "$(existCommand "${command}")" == 'false' ]]; then
    if [[ "$(isEmptyString "${errorMessage}")" == 'true' ]]; then
      fatal "\nFATAL : command '${command}' not found"
    fi

    fatal "\nFATAL : ${errorMessage}"
  fi
}

checkRequirePorts() {
  local -r ports=("${@}")

  installPackages 'lsof'

  local -r headerRegex='^COMMAND\s\+PID\s\+USER\s\+FD\s\+TYPE\s\+DEVICE\s\+SIZE\/OFF\s\+NODE\s\+NAME$'
  local -r status="$(lsof -i -n -P | grep "\( (LISTEN)$\)\|\(${headerRegex}\)")"

  local open=''
  local port=''

  for port in "${ports[@]}"; do
    local found=''
    found="$(grep -i ":${port} (LISTEN)$" <<< "${status}" || echo)"

    if [[ "$(isEmptyString "${found}")" == 'false' ]]; then
      open="${open}\n${found}"
    fi
  done

  if [[ "$(isEmptyString "${open}")" == 'false' ]]; then
    echo -e "\033[1;31mFollowing ports are still opened. Make sure you uninstall or stop them before a new installation!\033[0m"
    echo -e -n "\033[1;34m\n$(grep "${headerRegex}" <<< "${status}")\033[0m"
    echo -e "\033[1;36m${open}\033[0m\n"

    exit 1
  fi
}

displayOpenPorts() {
  local -r sleepTimeInSecond="${1}"

  installPackages 'lsof'

  header 'DISPLAYING OPEN PORTS'

  if [[ "$(isEmptyString "${sleepTimeInSecond}")" == 'false' ]]; then
    sleep "${sleepTimeInSecond}"
  fi

  lsof -i -n -P | grep -i ' (LISTEN)$' | sort -f
}

existCommand() {
  local -r command="${1}"

  if [[ "$(which "${command}" 2> '/dev/null')" == '' ]]; then
    echo 'false' && return 1
  fi

  echo 'true' && return 0
}

existDisk() {
  local -r disk="${1}"

  local -r foundDisk="$(fdisk -l "${disk}" 2> '/dev/null' | grep -E -i -o "^Disk\s+$(escapeGrepSearchPattern "${disk}"): ")"

  if [[ "$(isEmptyString "${disk}")" == 'false' && "$(isEmptyString "${foundDisk}")" == 'false' ]]; then
    echo 'true' && return 0
  fi

  echo 'false' && return 1
}

existDiskMount() {
  local -r disk="$(escapeGrepSearchPattern "${1}")"
  local -r mountOn="$(escapeGrepSearchPattern "${2}")"

  local -r foundMount="$(df | grep -E "^${disk}\s+.*\s+${mountOn}$")"

  if [[ "$(isEmptyString "${foundMount}")" == 'true' ]]; then
    echo 'false' && return 1
  fi

  echo 'true' && return 0
}

existModule() {
  local -r module="${1}"

  checkNonEmptyString "${module}" 'undefined module'

  if [[ "$(lsmod | awk '{ print $1 }' | grep -F -o "${module}")" == '' ]]; then
    echo 'false' && return 1
  fi

  echo 'true' && return 0
}

existMount() {
  local -r mountOn="$(escapeGrepSearchPattern "${1}")"

  local -r foundMount="$(df | grep -E ".*\s+${mountOn}$")"

  if [[ "$(isEmptyString "${foundMount}")" == 'true' ]]; then
    echo 'false' && return 1
  fi

  echo 'true' && return 0
}

flushFirewall() {
  header 'FLUSHING FIREWALL'

  iptables -P INPUT ACCEPT
  iptables -P FORWARD ACCEPT
  iptables -P OUTPUT ACCEPT

  iptables -t nat -F
  iptables -t mangle -F
  iptables -F
  iptables -X

  iptables --list

  saveFirewall
}

isPortOpen() {
  local -r port="$(escapeGrepSearchPattern "${1}")"

  checkNonEmptyString "${port}" 'undefined port'

  if [[ "$(isAmazonLinuxDistributor)" == 'true' || "$(isRedHatDistributor)" == 'true' || "$(isUbuntuDistributor)" == 'true' ]]; then
    local -r process="$(netstat -l -n -t -u | grep -E ":${port}\s+" | head -1)"
  elif [[ "$(isCentOSDistributor)" == 'true' || "$(isMacOperatingSystem)" == 'true' ]]; then
    if [[ "$(isCentOSDistributor)" == 'true' ]]; then
      installPackages 'lsof'
    fi

    local -r process="$(lsof -i -n -P | grep -E -i ":${port}\s+\(LISTEN\)$" | head -1)"
  else
    fatal '\nFATAL : only support Amazon-Linux, CentOS, Mac, RedHat, or Ubuntu OS'
  fi

  if [[ "$(isEmptyString "${process}")" == 'true' ]]; then
    echo 'false' && return 1
  fi

  echo 'true' && return 0
}

redirectJDKTMPDir() {
  local -r option="_JAVA_OPTIONS='-Djava.io.tmpdir=/var/tmp'"

  appendToFileIfNotFound '/etc/environment' "${option}" "${option}" 'false' 'false' 'true'
  appendToFileIfNotFound '/etc/profile' "${option}" "${option}" 'false' 'false' 'true'
}

remountTMP() {
  header 'RE-MOUNTING TMP'

  if [[ "$(existMount '/tmp')" == 'true' ]]; then
    mount -o 'remount,rw,exec,nosuid' -v '/tmp'
  else
    warn 'WARN : mount /tmp not found'
  fi
}

saveFirewall() {
  header 'SAVING FIREWALL'

  local ruleFile=''

  for ruleFile in '/etc/iptables/rules.v4' '/etc/iptables/rules.v6' '/etc/sysconfig/iptables' '/etc/sysconfig/ip6tables'; do
    if [[ -f ${ruleFile} ]]; then
      if [[ "$(grep -F '6' <<< "${ruleFile}")" == '' ]]; then
        iptables-save > "${ruleFile}"
      else
        ip6tables-save > "${ruleFile}"
      fi

      info "${ruleFile}"
      cat "${ruleFile}"
      echo
    fi
  done
}

############################
# USER AND GROUP UTILITIES #
############################

addUser() {
  local -r userLogin="${1}"
  local -r groupName="${2}"
  local -r createHome="${3}"
  local -r systemAccount="${4}"
  local -r allowLogin="${5}"

  checkNonEmptyString "${userLogin}" 'undefined user login'
  checkNonEmptyString "${groupName}" 'undefined group name'

  # Options

  if [[ ${createHome} == 'true' ]]; then
    local -r createHomeOption=('-m')
  else
    local -r createHomeOption=('-M')
  fi

  if [[ ${allowLogin} == 'true' ]]; then
    local -r allowLoginOption=('-s' '/bin/bash')
  else
    local -r allowLoginOption=('-s' '/bin/false')
  fi

  # Add Group

  groupadd -f -r "${groupName}"

  # Add User

  if [[ "$(existUserLogin "${userLogin}")" == 'true' ]]; then
    if [[ "$(isUserLoginInGroupName "${userLogin}" "${groupName}")" == 'false' ]]; then
      usermod -a -G "${groupName}" "${userLogin}"
    fi

    # Not Exist Home

    if [[ ${createHome} == 'true' ]]; then
      local -r userHome="$(getUserHomeFolder "${userLogin}")"

      if [[ "$(isEmptyString "${userHome}")" == 'true' || ! -d ${userHome} ]]; then
        mkdir -m 700 -p "/home/${userLogin}"
        chown -R "${userLogin}:${groupName}" "/home/${userLogin}"
      fi
    fi
  else
    if [[ ${systemAccount} == 'true' ]]; then
      useradd "${createHomeOption[@]}" -r "${allowLoginOption[@]}" -g "${groupName}" "${userLogin}"
    else
      useradd "${createHomeOption[@]}" "${allowLoginOption[@]}" -g "${groupName}" "${userLogin}"
    fi
  fi
}

addUserAuthorizedKey() {
  local -r userLogin="${1}"
  local -r groupName="${2}"
  local -r sshRSA="${3}"

  configUserSSH "${userLogin}" "${groupName}" "${sshRSA}" 'authorized_keys'
}

addUserSSHKnownHost() {
  local -r userLogin="${1}"
  local -r groupName="${2}"
  local -r sshRSA="${3}"

  configUserSSH "${userLogin}" "${groupName}" "${sshRSA}" 'known_hosts'
}

addUserToSudoWithoutPassword() {
  local -r userLogin="${1}"

  echo "${userLogin} ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${userLogin}"
  chmod 440 "/etc/sudoers.d/${userLogin}"
}

checkExistGroupName() {
  local -r groupName="${1}"

  if [[ "$(existGroupName "${groupName}")" == 'false' ]]; then
    fatal "\nFATAL : group name '${groupName}' not found"
  fi
}

checkExistUserLogin() {
  local -r userLogin="${1}"

  if [[ "$(existUserLogin "${userLogin}")" == 'false' ]]; then
    fatal "\nFATAL : user login '${userLogin}' not found"
  fi
}

checkRequireNonRootUser() {
  if [[ "$(whoami)" == 'root' ]]; then
    fatal '\nFATAL : non root login required'
  fi
}

checkRequireRootUser() {
  checkRequireUserLogin 'root'
}

checkRequireUserLogin() {
  local -r userLogin="${1}"

  if [[ "$(whoami)" != "${userLogin}" ]]; then
    fatal "\nFATAL : user login '${userLogin}' required"
  fi
}

configUserGIT() {
  local -r userLogin="${1}"
  local -r gitUserName="${2}"
  local -r gitUserEmail="${3}"

  header "CONFIGURING GIT FOR USER ${userLogin}"

  checkExistUserLogin "${userLogin}"
  checkNonEmptyString "${gitUserName}" 'undefined git user name'
  checkNonEmptyString "${gitUserEmail}" 'undefined git user email'

  su -l "${userLogin}" -c 'git config --global pull.rebase false'
  su -l "${userLogin}" -c 'git config --global push.default simple'
  su -l "${userLogin}" -c "git config --global user.email '${gitUserEmail}'"
  su -l "${userLogin}" -c "git config --global user.name '${gitUserName}'"

  info "$(su -l "${userLogin}" -c 'git config --list')"
}

configUserSSH() {
  local -r userLogin="${1}"
  local -r groupName="${2}"
  local -r sshRSA="${3}"
  local -r configFileName="${4}"

  header "CONFIGURING ${configFileName} FOR USER ${userLogin}"

  checkExistUserLogin "${userLogin}"
  checkExistGroupName "${groupName}"
  checkNonEmptyString "${sshRSA}" 'undefined SSH-RSA'
  checkNonEmptyString "${configFileName}" 'undefined config file'

  local -r userHome="$(getUserHomeFolder "${userLogin}")"

  checkExistFolder "${userHome}"

  mkdir -m 700 -p "${userHome}/.ssh"
  touch "${userHome}/.ssh/${configFileName}"
  appendToFileIfNotFound "${userHome}/.ssh/${configFileName}" "${sshRSA}" "${sshRSA}" 'false' 'false' 'false'
  chmod 600 "${userHome}/.ssh/${configFileName}"

  chown -R "${userLogin}:${groupName}" "${userHome}/.ssh"

  cat "${userHome}/.ssh/${configFileName}"
}

deleteUser() {
  local -r userLogin="${1}"

  if [[ "$(existUserLogin "${userLogin}")" == 'true' ]]; then
    userdel -f -r "${userLogin}" 2> '/dev/null' || true
  fi
}

existGroupName() {
  local -r group="${1}"

  if [[ "$(grep -E -o "^${group}:" '/etc/group')" == '' ]]; then
    echo 'false' && return 1
  fi

  echo 'true' && return 0
}

existUserLogin() {
  local -r user="${1}"

  if (id -u "${user}" > '/dev/null' 2>&1); then
    echo 'true' && return 0
  fi

  echo 'false' && return 1
}

generateSSHPublicKeyFromPrivateKey() {
  local -r userLogin="${1}"
  local groupName="${2}"

  # Set Default

  if [[ "$(isEmptyString "${groupName}")" == 'true' ]]; then
    groupName="${userLogin}"
  fi

  # Validate Input

  checkExistUserLogin "${userLogin}"
  checkExistGroupName "${groupName}"

  local -r userHome="$(getUserHomeFolder "${userLogin}")"

  checkExistFile "${userHome}/.ssh/id_rsa"

  # Generate SSH Public Key

  header "GENERATING SSH PUBLIC KEY FOR USER '${userLogin}' FROM PRIVATE KEY"

  rm -f "${userHome}/.ssh/id_rsa.pub"
  su -l "${userLogin}" -c "ssh-keygen -f '${userHome}/.ssh/id_rsa' -y > '${userHome}/.ssh/id_rsa.pub'"
  chmod 600 "${userHome}/.ssh/id_rsa.pub"
  chown "${userLogin}:${groupName}" "${userHome}/.ssh/id_rsa.pub"

  cat "${userHome}/.ssh/id_rsa.pub"
}

generateUserSSHKey() {
  local -r userLogin="${1}"
  local groupName="${2}"

  # Set Default

  if [[ "$(isEmptyString "${groupName}")" == 'true' ]]; then
    groupName="${userLogin}"
  fi

  # Validate Input

  checkExistUserLogin "${userLogin}"
  checkExistGroupName "${groupName}"

  local -r userHome="$(getUserHomeFolder "${userLogin}")"

  checkExistFolder "${userHome}"

  # Generate SSH Key

  header "GENERATING SSH KEY FOR USER '${userLogin}'"

  rm -f "${userHome}/.ssh/id_rsa" "${userHome}/.ssh/id_rsa.pub"
  mkdir -m 700 -p "${userHome}/.ssh"
  chown "${userLogin}:${groupName}" "${userHome}/.ssh"

  su -l "${userLogin}" -c "ssh-keygen -q -t rsa -N '' -f '${userHome}/.ssh/id_rsa'"
  chmod 600 "${userHome}/.ssh/id_rsa" "${userHome}/.ssh/id_rsa.pub"
  chown "${userLogin}:${groupName}" "${userHome}/.ssh/id_rsa" "${userHome}/.ssh/id_rsa.pub"

  cat "${userHome}/.ssh/id_rsa.pub"
}

getCurrentUserHomeFolder() {
  getUserHomeFolder "$(whoami)"
}

getProfileFilePath() {
  local -r user="${1}"

  local -r userHome="$(getUserHomeFolder "${user}")"

  if [[ "$(isEmptyString "${userHome}")" == 'false' && -d ${userHome} ]]; then
    local -r bashProfileFilePath="${userHome}/.bash_profile"
    local -r profileFilePath="${userHome}/.profile"

    if [[ ! -f ${bashProfileFilePath} && -f ${profileFilePath} ]]; then
      echo "${profileFilePath}"
    else
      echo "${bashProfileFilePath}"
    fi
  fi
}

getUserGroupName() {
  local -r userLogin="${1}"

  checkExistUserLogin "${userLogin}"

  id -g -n "${userLogin}"
}

getUserHomeFolder() {
  local -r user="${1}"

  if [[ "$(isEmptyString "${user}")" == 'false' ]]; then
    local -r homeFolder="$(eval "echo ~${user}")"

    if [[ ${homeFolder} == "\~${user}" ]]; then
      echo
    else
      echo "${homeFolder}"
    fi
  else
    echo
  fi
}

isUserLoginInGroupName() {
  local -r userLogin="${1}"
  local -r groupName="${2}"

  checkNonEmptyString "${userLogin}" 'undefined user login'
  checkNonEmptyString "${groupName}" 'undefined group name'

  if [[ "$(existUserLogin "${userLogin}")" == 'true' ]] && [[ "$(groups "${userLogin}" | grep "\b${groupName}\b")" != '' ]]; then
    echo 'true' && return 0
  fi

  echo 'false' && return 1
}

runBackgroundTask() {
  (nohup "$@" &> /dev/null &)
}

progressBar() {
  # Usage: bar 1 10
  #            ^----- Elapsed Percentage (0-100).
  #              ^--- Total length in chars.

  ((elapsed = $1 * $2 / 100))

  # Create the bar with spaces.
  printf -v prog "%${elapsed}s"
  printf -v total "%$(($2 - elapsed))s"

  printf '%s\r' "[${prog// /-}${total}]"
}