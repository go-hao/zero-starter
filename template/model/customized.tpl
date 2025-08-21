{{if not .withCache}}
// ======================== customized ========================
var {{.lowerStartCamelObject}}RowsWithTableAlias = buildRowsWithTableAlias({{.lowerStartCamelObject}}FieldNames)

func (m *custom{{.upperStartCamelObject}}Model) rowsWithTableAlias() string {
    return {{.lowerStartCamelObject}}RowsWithTableAlias
}

// {{.lowerStartCamelObject}}FindAll requires R as a struct pointer
func {{.lowerStartCamelObject}}FindAll[R any](ctx context.Context, m *custom{{.upperStartCamelObject}}Model, query string, condition string, args ...any) ([]R, error) {
	// create query
	if query == "" {
		query = fmt.Sprintf("select %s from %s %s where 1 = 1", m.rowsWithTableAlias(), m.table, tableAlias)
	}
	if condition != "" {
		query += " " + strings.TrimSpace(condition)
	}

	// prepare
	stmt, err := m.conn.PrepareCtx(ctx, query)
	if err != nil {
		return nil, err
	}
	defer stmt.Close()

	// exec
	var resp []R
	err = stmt.QueryRowsCtx(ctx, &resp, args...)
	if err != nil {
		return nil, err
	}

	return resp, nil
}

// {{.lowerStartCamelObject}}List requires R as a struct pointer
//
// if countQuery or listQuery is empty, use default queries
func {{.lowerStartCamelObject}}List[R any](ctx context.Context, m *custom{{.upperStartCamelObject}}Model, paginationOrderBy *PaginationOrderBy, countQuery string, listQuery string, condition string, args ...any) ([]R, int64, error) {
	// ======================== get count ========================
	// create query
	if countQuery == "" || listQuery == "" {
		// use default
		countQuery = fmt.Sprintf("select count(*) from %s %s where 1 = 1", m.table, tableAlias)
		listQuery = fmt.Sprintf("select %s from %s %s where 1 = 1", m.rowsWithTableAlias(), m.table, tableAlias)
	}
	if condition != "" {
		countQuery += " " + strings.TrimSpace(condition)
	}

	// prepare
	stmt, err := m.conn.PrepareCtx(ctx, countQuery)
	if err != nil {
		return nil, 0, err
	}
	defer stmt.Close()

	// exec
	var count int64
	err = stmt.QueryRowCtx(ctx, &count, args...)
	if err != nil {
		return nil, 0, err
	}

	// early return
	if count == 0 {
		return []R{}, 0, nil
	}
	
	// ======================== get list by {{.lowerStartCamelObject}}FindAll ========================
	condition += " " + getPaginationOrderBy(paginationOrderBy)
	list, err := {{.lowerStartCamelObject}}FindAll[R](ctx, m, listQuery, condition, args...)
	if err != nil {
		return nil, 0, err
	}

	return list, count, nil
}
{{end}}
