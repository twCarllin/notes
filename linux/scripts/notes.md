# Some shell scripts, all in Bash

## find all folder contain specific file
 - `find . -name Dockerfile -print0 | xargs -0 -n1 dirname | awk -F'/' '{print \$NF}'`
 
## find the 50000 to 50010 lins in doc
 - `tail -n+50000 test.file | head -n10`
