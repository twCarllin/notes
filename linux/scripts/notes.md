# Some shell scripts, all in Bash

## find all folder contain specific file
 - `find . -name Dockerfile -print0 | xargs -0 -n1 dirname | awk -F'/' '{print \$NF}'`