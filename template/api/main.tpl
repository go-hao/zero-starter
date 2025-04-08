package main

import (
	"flag"
	"fmt"

	{{.importPackages}}
	"github.com/zeromicro/go-zero/rest/httpx"
    "github.com/go-hao/zero/xvalidator"
)

var configFile = flag.String("f", "etc/{{.serviceName}}.yaml", "the config file")

func main() {
	flag.Parse()

	var c config.Config
	conf.MustLoad(*configFile, &c)
    
    // set custom validator
    validator := xvalidator.New()
	httpx.SetValidator(validator)
	// todo: set custom validations by calling
	// validator.RegisterValidations()

	server := rest.MustNewServer(c.RestConf)
	defer server.Stop()

	ctx := svc.NewServiceContext(c)
	handler.RegisterHandlers(server, ctx)

	fmt.Printf("Starting server at %s:%d...\n", c.Host, c.Port)
	server.Start()
}
