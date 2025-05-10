package {{.pkg}}
{{if .withCache}}
import (
	"github.com/zeromicro/go-zero/core/stores/cache"
	"github.com/zeromicro/go-zero/core/stores/sqlx"
)
{{else}}

import (
    "context"
    "fmt"

    "github.com/zeromicro/go-zero/core/stores/sqlx"
)
{{end}}
var _ {{.upperStartCamelObject}}Model = (*custom{{.upperStartCamelObject}}Model)(nil)

type (
	// {{.upperStartCamelObject}}Model is an interface to be customized, add more methods here,
	// and implement the added methods in custom{{.upperStartCamelObject}}Model.
	{{.upperStartCamelObject}}Model interface {
		{{.lowerStartCamelObject}}Model
		{{if not .withCache}}withSession(session sqlx.Session) {{.upperStartCamelObject}}Model{{end}}
	}

	custom{{.upperStartCamelObject}}Model struct {
		*default{{.upperStartCamelObject}}Model
	}
)

// New{{.upperStartCamelObject}}Model returns a model for the database table.
func New{{.upperStartCamelObject}}Model(conn sqlx.SqlConn{{if .withCache}}, c cache.CacheConf, opts ...cache.Option{{end}}) {{.upperStartCamelObject}}Model {
	return &custom{{.upperStartCamelObject}}Model{
		default{{.upperStartCamelObject}}Model: new{{.upperStartCamelObject}}Model(conn{{if .withCache}}, c, opts...{{end}}),
	}
}

{{if not .withCache}}
func (m *custom{{.upperStartCamelObject}}Model) withSession(session sqlx.Session) {{.upperStartCamelObject}}Model {
    return New{{.upperStartCamelObject}}Model(sqlx.NewSqlConnFromSession(session))
}

func (m *custom{{.upperStartCamelObject}}Model) findAllByCondition (ctx context.Context, condition string, args ...any) ([]*{{.upperStartCamelObject}}, error) {
	// create query
	query := fmt.Sprintf("select %s from %s", {{.lowerStartCamelObject}}Rows, m.table)
	if len(condition) > 0 {
		query += fmt.Sprintf(" %s", condition)
	}

	// prepare
	stmt, err := m.conn.PrepareCtx(ctx, query)
	if err != nil {
		return nil, err
	}
	defer stmt.Close()

	// exec
	var resp []*{{.upperStartCamelObject}}
	err = stmt.QueryRowsCtx(ctx, &resp, args...)
	if err != nil {
		return nil, err
	}

	return resp, nil
}
{{end}}

