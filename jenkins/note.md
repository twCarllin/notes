# Some notes

## Jenkinsfile
 - The shell default is sh, not bash
 - how to get result from executing shell script
    ```
    def prefix = sh(returnStdout: true, script: 
        """ #!/bin/sh
            basename `git rev-parse --show-toplevel` | grep -P 'service|pipeline' -o
        """).timr()
    ```
