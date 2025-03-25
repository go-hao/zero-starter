syntax = "v1"

info (
	title: "{{.serviceName}}"
	desc: "{{.serviceName}}"
	author: "{{.gitUser}}"
	email: "{{.gitEmail}}"
)

type Req {
    Name string `path:"name,options=you|me"`
}

type Resp {
    Message string `json:"message"`
}

service {{.serviceName}} {
    @handler Greet
    get /from/:name (Req) returns (Resp)
}
