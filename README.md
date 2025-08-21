# README.md

```
Usage: ./zero <option>
Options:
  set                   set go environment variables - GO111MODULE(on) and GOPROXY
  init                  initialize the project
  tidy                  tidy and format the project
  clean                 clean build content
  api <NAME>            create an api app in service/NAME/api
  rpc <NAME>            create a rpc app in service/NAME/rpc
  <MODEL OP> <PATH>     generate app models based on sql files in PATH/sql
                          - PATH      - service/NAME
                          - MODEL OP  - model generate app models with no cache
                                        modelc generate app models with cache
  gen <PATH>            generate or update app code
                          - PATH      - service/NAME/OPT
                          - OPT       - api|rpc
  combo <PATH>          run gen api, gen rpc, model and modelc together
                          - PATH      - service/NAME
  build [PATH]          build app
                          - PATH      - service/NAME/OPT
                                        omit to build all apps
                          - OPT       - api|rpc
  run <PATH>            run app
                          - PATH      - service/NAME/OPT
                          - OPT       - api|rpc
```