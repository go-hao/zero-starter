package {{.PkgName}}

import (
	"net/http"

	{{if .HasRequest}}"github.com/zeromicro/go-zero/rest/httpx"{{end}}
	{{.ImportPackages}}
   	{{if .HasRequest}}"github.com/go-hao/zero/xerrors"{{end}}
    "github.com/go-hao/zero/xhttp"
)

{{if .HasDoc}}{{.Doc}}{{end}}
func {{.HandlerName}}(svcCtx *svc.ServiceContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		{{if .HasRequest}}var req types.{{.RequestType}}
		if err := httpx.Parse(r, &req); err != nil {
            switch e := svcCtx.ErrBadRequest.(type) {
			case *xerrors.Error:
				xhttp.Json(r.Context(), w, e.Detail(err))
			case xerrors.Error:
				xhttp.Json(r.Context(), w, e.Detail(err))
			default:
				xhttp.Json(r.Context(), w, err)
			}
			return
		}

		{{end}}l := {{.LogicName}}.New{{.LogicType}}(r.Context(), svcCtx)
		{{if .HasResp}}resp, {{end}}err := l.{{.Call}}({{if .HasRequest}}&req{{end}})
		if err != nil {
            xhttp.Json(r.Context(), w, err)
		} else {
			xhttp.Json(r.Context(), w, {{if .HasResp}}resp{{else}}nil{{end}})
        }
	}
}
