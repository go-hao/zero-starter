package svc

import (
	{{.configImport}}
)

type ServiceContext struct {
	Config {{.config}}
    ErrBadRequest any
	{{.middleware}}
}

func NewServiceContext(c {{.config}}) *ServiceContext {
	return &ServiceContext{
		Config: c,
        ErrBadRequest: nil,
		{{.middlewareAssignment}}
	}
}
